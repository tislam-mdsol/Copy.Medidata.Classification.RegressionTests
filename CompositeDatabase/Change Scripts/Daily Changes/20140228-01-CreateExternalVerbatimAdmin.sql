DECLARE @externalVerbatimAdminActionString VARCHAR(50) = 'ManageExternalVerbatim'
IF NOT EXISTS (SELECT NULL FROM ActionTypeR
	WHERE Name = @externalVerbatimAdminActionString)
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		--1. Insert new action type
		DECLARE @actionTypeId INT = 28
		INSERT INTO ActionTypeR (ActionType, Name) 
		VALUES(@actionTypeId, @externalVerbatimAdminActionString)

		-- 2. Tie action type to security module (Segment Security)
		DECLARE @moduleId INT

		SELECT @moduleId =  ModuleId 
		FROM ModulesR 
		WHERE ModuleName = 'SegmentSecurity'
		
		DECLARE @externalVerbatimAdminAction INT
		INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) 
		VALUES(@moduleId, @actionTypeId, 1)
		SET @externalVerbatimAdminAction = SCOPE_IDENTITY()
		
		--3. Adding new role for each segment
		Declare @newRoleName NVARCHAR(50) ='ExternalVerbatimAdmin'
		DECLARE @segmentId INT
		DECLARE segment_cursor CURSOR FOR
		SELECT SegmentId from Segments

		OPEN segment_cursor 
		FETCH NEXT FROM segment_cursor into @segmentId

		WHILE @@FETCH_STATUS =0
		BEGIN
			
			Declare @stringId INT
			Declare @newRoleId INT
				
			EXEC dbo.spLclztnFndOrInsrtDtStrng @newRoleName, 'eng', @stringId OUTPUT, @segmentId
			
			--adding new role in the scope of module
			INSERT INTO RolesAllModules (Active, RoleNameID, ModuleId, SegmentID, UserDeactivated, Deleted, OID)
			                      Values(1,      @stringId,  @moduleId,@segmentId,0,               0,       @newRoleName)
			SET @newRoleId = SCOPE_IDENTITY()

			--tie action to the role
			INSERT INTO RoleActions(RoleID,     ModuleActionId,               SegmentID, RestrictionMask, RestrictionStatus, GroupID, Deleted)
			                 Values(@newRoleId, @externalVerbatimAdminAction, @segmentId, 0,              0,                 1,       0)
   
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
		SET @errorString = N'ERROR adding new role ExternalVerbatimAdmin: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
	
END