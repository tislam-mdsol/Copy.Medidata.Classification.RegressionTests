IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'SynonymSecurityMigration')
BEGIN
	CREATE TABLE [dbo].[SynonymSecurityMigration](
		OldRoleId INT NOT NULL,
		SegmentId INT NOT NULL,
		Locale CHAR(3) NOT NULL,
		SynonymAdminRoleId INT NOT NULL CONSTRAINT DF_SynonymSecurityMigration_SynonymAdminRoleId DEFAULT(-1),
		SynonymListAdminRoleId INT NOT NULL CONSTRAINT DF_SynonymSecurityMigration_SynonymListAdminRoleId DEFAULT(-1),
		BaseStringId INT,
		ListStringId INT,
	 CONSTRAINT [PK_SynonymSecurityMigration] PRIMARY KEY CLUSTERED 
	(
		OldRoleId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)

END
GO

DECLARE @errorString NVARCHAR(1000)
DECLARE @synAdminActionString VARCHAR(50) = 'BasicSynonymAdmin'
DECLARE @synListAdminActionString VARCHAR(50) = 'SynonymListAdmin'

IF NOT EXISTS (SELECT NULL FROM ActionTypeR
	WHERE Name = @synAdminActionString)
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION

		-- 1. INSERT New Action Type(s)
		-- 2. INSERT New Module Action Type(s)

		--{'SynonymDetails','SynonymDetail_RetireSynonyms','SynonymApproval','SynonymAdminView'} -> BasicSynonymAdmin
		--{'SynonymMigration','SynonymMigration_Reconcile'} -> SynonymListAdmin

		-- 3. EVAL ROLE(s)
		-- a) Role has complete coverage 
		-- [R] - add action to existing role
		-- b) Role has partial coverage
		-- [R] - remove all pertinent action(s) from role & create new role/action & assoc
		-- c) Role has no coverage
		-- [R] - do nothing
		-- either way - remove the old actions from the role definition

		-- *** EXEC AREA ***

		-- ... supporting variables

		DECLARE @moduleId INT

		SELECT @moduleId =  ModuleId 
		FROM ModulesR 
		WHERE ModuleName = 'PageDictionarySecurity'

		DECLARE @actionTypeBase INT = 26,
			@actionTypeAdmin INT = 27

		-- Add new data
		DECLARE @synonymAdminAction INT, @synonymListAdminAction INT
			
		--  add base action types
		INSERT INTO ActionTypeR (ActionType, Name) VALUES(@actionTypeBase, @synAdminActionString)
		INSERT INTO ActionTypeR (ActionType, Name) VALUES(@actionTypeAdmin, @synListAdminActionString)

		-- add module action types (into dictionary security)
		INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@moduleId, @actionTypeBase, 1)
		SET @synonymAdminAction = SCOPE_IDENTITY()
		
		INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@moduleId, @actionTypeAdmin, 1)
		SET @synonymListAdminAction = SCOPE_IDENTITY()
		
		DECLARE @moduleActionsForSynonymAdmin TABLE(Id INT PRIMARY KEY)
		DECLARE @moduleActionsForSynonymListAdmin TABLE(Id INT PRIMARY KEY)

		INSERT INTO @moduleActionsForSynonymAdmin
		SELECT ModuleActionID
		FROM ModuleActions
		WHERE ActionType IN (SELECT ActionType FROM ActionTypeR
							WHERE Name IN
								(
									'SynonymDetails',
									'SynonymDetail_RetireSynonyms',
									'SynonymApproval',
									'SynonymAdminView'
								)
							)

		INSERT INTO @moduleActionsForSynonymListAdmin
		SELECT ModuleActionID
		FROM ModuleActions
		WHERE ActionType IN (SELECT ActionType FROM ActionTypeR
							WHERE Name IN
								(
									'SynonymMigration',
									'SynonymMigration_Reconcile'
								)
							)

		-- 0. Log all existing roles
		INSERT INTO SynonymSecurityMigration (OldRoleId, SegmentId, Locale)
		SELECT R.RoleId, R.SegmentID, LPK.InsertedInLocale
		FROM RolesAllModules R
			JOIN LocalizedDataStringPKs LPK
				ON LPK.StringId = R.RoleNameID
				AND ModuleId = @moduleId
				AND Deleted = 0
				AND Active = 1

		-- 1. Eval the roles that contain all 3 synonymadmin conditions & 2 synonymlistadmin ones
		UPDATE SSM
		SET SSM.SynonymAdminRoleId = CASE WHEN ISNULL(SynonymAdmin.ActionCount, 0) = 4 THEN SSM.OldRoleId
											WHEN ISNULL(SynonymAdmin.ActionCount, 0) > 0 THEN 0
											ELSE -1
									END,
			SSM.SynonymListAdminRoleId = CASE WHEN ISNULL(SynonymListAdmin.ActionCount, 0) = 2 THEN SSM.OldRoleId
											WHEN ISNULL(SynonymListAdmin.ActionCount, 0) > 0 THEN 0
											ELSE -1
									END
		FROM SynonymSecurityMigration SSM
			CROSS APPLY
			(
				SELECT ActionCount = COUNT(*)
				FROM @moduleActionsForSynonymAdmin SA
					JOIN RoleActions RA
						ON RA.RoleID = SSM.OldRoleId
						AND SA.Id = RA.ModuleActionId
						AND Deleted = 0
			) AS SynonymAdmin
			CROSS APPLY
			(
				SELECT ActionCount = COUNT(*)
				FROM @moduleActionsForSynonymListAdmin SA
					JOIN RoleActions RA
						ON RA.RoleID = SSM.OldRoleId
						AND SA.Id = RA.ModuleActionId
						AND Deleted = 0
			) AS SynonymListAdmin
			
		-- 2 create supporting locale data
		DECLARE @appendSTR NVARCHAR(10) = ''
		DECLARE @roleName NVARCHAR(4000), @newRoleName VARCHAR(4000)
		DECLARE @stringId INT, @locale CHAR(3),
			@segmentId INT, @oldRoleId INT, @isBaseNeeded BIT, @isListNeeded BIT, @roleIndex INT

		DECLARE sCursor CURSOR FORWARD_ONLY FOR
		SELECT R.RoleID, LDS.String+@appendSTR,
			CASE WHEN SSM.SynonymAdminRoleId = 0 THEN 1 ELSE 0 END,
			CASE WHEN SSM.SynonymListAdminRoleId = 0 THEN 1 ELSE 0 END,
			SSM.Locale,
			SSM.SegmentId
		FROM SynonymSecurityMigration SSM
			JOIN RolesAllModules R
				ON SSM.OldRoleId = R.RoleID
			JOIN LocalizedDataStrings LDS	
				ON R.RoleNameId = LDS.StringID
				AND LDS.Locale = SSM.Locale
		WHERE SSM.SynonymAdminRoleId = 0 OR 
			SSM.SynonymListAdminRoleId = 0

		OPEN sCursor
		FETCH sCursor INTO @oldRoleId, @roleName, @isBaseNeeded, @isListNeeded, @locale, @segmentId
		WHILE (@@fetch_status = 0)
		BEGIN
		
			SET @roleIndex = 0
		
			IF (@isBaseNeeded = 1)
			BEGIN
			
				WHILE (1 = 1)
				BEGIN

					SET @roleIndex = @roleIndex + 1
					SET @newRoleName = @roleName + CAST(@roleIndex AS VARCHAR)
					
					EXEC dbo.spLclztnFndOrInsrtDtStrng @newRoleName, @locale, @stringId OUTPUT, @segmentId

					IF NOT EXISTS (SELECT NULL FROM RolesAllModules
						WHERE SegmentID = @segmentId
							AND RoleNameId = @stringId)
						BREAK
						
				END
			
				UPDATE SynonymSecurityMigration
				SET BaseStringId = @stringId
				WHERE OldRoleId = @oldRoleId
			
			END
			
			IF (@isListNeeded = 1)
			BEGIN

				WHILE (1 = 1)
				BEGIN

					SET @roleIndex = @roleIndex + 1
					SET @newRoleName = @roleName + CAST(@roleIndex AS VARCHAR)
					
					EXEC dbo.spLclztnFndOrInsrtDtStrng @newRoleName, @locale, @stringId OUTPUT, @segmentId

					IF NOT EXISTS (SELECT NULL FROM RolesAllModules
						WHERE SegmentID = @segmentId
							AND RoleNameId = @stringId)
						BREAK
				END
				
				UPDATE SynonymSecurityMigration
				SET ListStringId = @stringId
				WHERE OldRoleId = @oldRoleId
		
			END

			FETCH sCursor INTO @oldRoleId, @roleName, @isBaseNeeded, @isListNeeded, @locale, @segmentId

		END

		CLOSE sCursor
		DEALLOCATE sCursor

		-- 3. Create the new roles needed
		DECLARE @idMapping TABLE(IdOld INT, IdNew INT PRIMARY KEY)

		-- 3.1. synonymadmin
		INSERT INTO RolesAllModules (RoleNameID, OID, ModuleId, SegmentID, Active, UserDeactivated, Deleted)
		OUTPUT inserted.RoleID, inserted.ModuleId INTO @idMapping(IdNew, IdOld)
		SELECT SSM.BaseStringId, '', SSM.OldRoleId, SSM.SegmentId, 1, 0, 0
		FROM SynonymSecurityMigration SSM
		WHERE SynonymAdminRoleId = 0

		UPDATE R
		SET R.ModuleId = @moduleId,
			R.OID = CAST(R.RoleID AS VARCHAR)
		FROM RolesAllModules R
			JOIN @idMapping RM
				ON R.RoleID = RM.IdNew
				
		UPDATE SSM
		SET SSM.SynonymAdminRoleId = RM.IdNew
		FROM SynonymSecurityMigration SSM
			JOIN @idMapping RM
				ON SSM.OldRoleID = RM.IdOld

		DELETE @idMapping

		-- 3.2. synonymlistadmin
		INSERT INTO RolesAllModules (RoleNameID, OID, ModuleId, SegmentID, Active, UserDeactivated, Deleted)
		OUTPUT inserted.RoleID, inserted.ModuleId INTO @idMapping(IdNew, IdOld)
		SELECT SSM.ListStringId, '', SSM.OldRoleId, SSM.SegmentId, 1, 0, 0
		FROM SynonymSecurityMigration SSM
		WHERE SynonymListAdminRoleId = 0

		UPDATE R
		SET R.ModuleId = @moduleId,
			R.OID = CAST(R.RoleID AS VARCHAR)
		FROM RolesAllModules R
			JOIN @idMapping RM
				ON R.RoleID = RM.IdNew

		UPDATE SSM
		SET SSM.SynonymListAdminRoleId = RM.IdNew
		FROM SynonymSecurityMigration SSM
			JOIN @idMapping RM
				ON SSM.OldRoleID = RM.IdOld

		DELETE @idMapping

		-- 4. Modify the RoleActions
		-- 4.1 (hard) remove synAdmins old rights
		DELETE RA
		FROM RoleActions RA
		WHERE RA.ModuleActionId IN (SELECT Id FROM @moduleActionsForSynonymAdmin)
				
		-- 4.2 (hard) remove synListAdmins old rights
		DELETE RA
		FROM RoleActions RA
		WHERE RA.ModuleActionId IN (SELECT Id FROM @moduleActionsForSynonymListAdmin)
				
		-- 4.3 add rights for synAdmins
		INSERT INTO RoleActions(RoleID, ModuleActionId, SegmentID, RestrictionMask, RestrictionStatus, GroupID, Deleted)
		SELECT SynonymAdminRoleId, @synonymAdminAction, SegmentId, 0, 0, 1, 0
		FROM SynonymSecurityMigration
		WHERE SynonymAdminRoleId > 0

		-- 4.4 add rights for synListAdmins
		INSERT INTO RoleActions(RoleID, ModuleActionId, SegmentID, RestrictionMask, RestrictionStatus, GroupID, Deleted)
		SELECT SynonymListAdminRoleId, @synonymListAdminAction, SegmentId, 0, 0, 1, 0
		FROM SynonymSecurityMigration
		WHERE SynonymListAdminRoleId > 0

		-- 5. New RoleAssoc
		-- (merely one action conveys rights to whole new role, denial will however still be supported!)

		-- 5.1 synAdmins
		INSERT INTO UserObjectRole(GrantOnObjectId, GrantOnObjectTypeId, GrantToObjectId, GrantToObjectTypeId,
			RoleID, SegmentID,
			DenyObjectRole, UserDeactivated, Active, Deleted)
		SELECT GrantOnObjectId, GrantOnObjectTypeId, GrantToObjectId, GrantToObjectTypeId,
			SynonymAdminRoleId, UOR.SegmentID,
			DenyObjectRole, UserDeactivated, Active, Deleted
		FROM UserObjectRole UOR
			JOIN SynonymSecurityMigration SSM
				ON SSM.OldRoleId = UOR.RoleID
				AND SSM.OldRoleId <> SSM.SynonymAdminRoleId
				AND SSM.SynonymAdminRoleId > 0
		WHERE Deleted = 0
			AND Active = 1

		-- 5.2 synListAdmins
		INSERT INTO UserObjectRole(GrantOnObjectId, GrantOnObjectTypeId, GrantToObjectId, GrantToObjectTypeId,
			RoleID, SegmentID,
			DenyObjectRole, UserDeactivated, Active, Deleted)
		SELECT GrantOnObjectId, GrantOnObjectTypeId, GrantToObjectId, GrantToObjectTypeId,
			SynonymListAdminRoleId, UOR.SegmentID,
			DenyObjectRole, UserDeactivated, Active, Deleted
		FROM UserObjectRole UOR
			JOIN SynonymSecurityMigration SSM
				ON SSM.OldRoleId = UOR.RoleID
				AND SSM.OldRoleId <> SSM.SynonymListAdminRoleId
				AND SSM.SynonymListAdminRoleId > 0
		WHERE Deleted = 0
			AND Active = 1

	COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		SET @errorString = N'ERROR Group Migration: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
	
END