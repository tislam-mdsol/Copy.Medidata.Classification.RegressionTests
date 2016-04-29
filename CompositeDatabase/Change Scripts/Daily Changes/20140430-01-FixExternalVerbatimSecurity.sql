DECLARE @externalVerbatimAdminRoleName NVARCHAR(50) ='ExternalVerbatimAdmin'
DECLARE @segmentAdminRoleName NVARCHAR(50) = 'SegmentAdmin'
DECLARE @actionType INT = 28

DECLARE @moduleId INT

SELECT @moduleId =  ModuleId 
FROM ModulesR 
WHERE ModuleName = 'SegmentSecurity'

DECLARE @ExternalVerbatimAdminModuleActionID INT

SELECT @ExternalVerbatimAdminModuleActionID =  ModuleActionID 
FROM ModuleActions
WHERE ModuleId = @moduleId
	AND ActionType = @actionType

IF (@ExternalVerbatimAdminModuleActionID IS NULL)
BEGIN
	PRINT 'Cannot find moduleAction for ExternalVerbatimAdmin'
END
ELSE
BEGIN

	BEGIN TRY
		BEGIN TRANSACTION

		-- 1. Fix SegmentAdmin roles
		UPDATE RA
		SET DELETED = 1
		FROM RoleActions RA
			JOIN RolesAllModules RM
				ON RA.RoleId = RM.RoleId
				AND RM.ModuleId = @moduleId
				AND RM.OID = @segmentAdminRoleName
				AND RA.ModuleActionID = @ExternalVerbatimAdminModuleActionID
				AND RA.Deleted = 0
		
		-- 2. Fix ExternalVerbatimAdmin roles
		UPDATE RA
		SET DELETED = 1
		FROM RoleActions RA
			JOIN RolesAllModules RM
				ON RA.RoleId = RM.RoleId
				AND RM.ModuleId = @moduleId
				AND RM.OID = @externalVerbatimAdminRoleName
				AND RA.ModuleActionID <> @ExternalVerbatimAdminModuleActionID
				AND RA.Deleted = 0

		-- 3. Add missing role(s) for each segment
		DECLARE @segmentId INT
		DECLARE segment_cursor CURSOR FOR
		SELECT SegmentId 
		FROM Segments S
		WHERE NOT EXISTS (SELECT NULL
				FROM RolesAllModules RM
				WHERE ModuleId = @moduleId
					AND RM.SegmentId = S.SegmentId
					AND OID = @externalVerbatimAdminRoleName)

		OPEN segment_cursor 
		FETCH NEXT FROM segment_cursor into @segmentId

		WHILE @@FETCH_STATUS =0
		BEGIN
			
			DECLARE @stringId INT
			DECLARE @newRoleId INT

			EXEC dbo.spLclztnFndOrInsrtDtStrng @externalVerbatimAdminRoleName, 'eng', @stringId OUTPUT, @segmentId
			
			--adding new role in the scope of module
			INSERT INTO RolesAllModules (Active, RoleNameID, ModuleId, SegmentID, UserDeactivated, Deleted, OID)
									Values(1,      @stringId,  @moduleId,@segmentId,0,               0,       @externalVerbatimAdminRoleName)
			SET @newRoleId = SCOPE_IDENTITY()

			--tie action to the role
			INSERT INTO RoleActions(RoleID,     ModuleActionId,               SegmentID, RestrictionMask, RestrictionStatus, GroupID, Deleted)
								Values(@newRoleId, @ExternalVerbatimAdminModuleActionID, @segmentId, 0,              0,                 1,       0)

			FETCH NEXT FROM segment_cursor into @segmentId 
		END

		CLOSE segment_cursor
		DEALLOCATE segment_cursor 
		
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		IF CURSOR_STATUS('global','segment_cursor')>=-1
		BEGIN
			DEALLOCATE segment_cursor
		END
		DECLARE @errorString NVARCHAR(MAX)
		SET @errorString = N'ERROR Fixing segment Admin roles: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
	
END