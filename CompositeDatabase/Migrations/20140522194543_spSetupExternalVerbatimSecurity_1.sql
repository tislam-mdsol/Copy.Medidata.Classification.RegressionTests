IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSetupExternalVerbatimSecurity')
	DROP PROCEDURE spSetupExternalVerbatimSecurity
GO
CREATE PROCEDURE spSetupExternalVerbatimSecurity
(
	@SegmentID INT,
	@SegmentTypeID INT
)
AS

	DECLARE @ModuleID INT

	SELECT @ModuleID = ModuleId
	FROM ModulesR
	WHERE ObjectTypeId = @SegmentTypeID
		AND ModuleName = 'SegmentSecurity'

	IF (@ModuleID IS NULL)
	BEGIN
		PRINT N'SegmentSecurity Module is defined'
		RETURN
	END

	-- 1. Setup ExternalVerbatimAdmin Role
	DECLARE @newRoleName NVARCHAR(50) ='ExternalVerbatimAdmin'
	DECLARE @RoleID INT

	SELECT @RoleID = RoleID
	FROM RolesAllModules
	WHERE ModuleID = @ModuleID
		AND SegmentID = @SegmentID
		AND OID = @newRoleName
		
	IF (@RoleID IS NULL)
	BEGIN

		DECLARE @RoleNameID INT

		EXEC spLclztnFndOrInsrtDtStrng @newRoleName, 'eng', @RoleNameID OUTPUT, @SegmentID

		INSERT INTO RolesAllModules
		(Active, RoleNameID, ModuleId, SegmentID, Deleted, OID)
		VALUES(1, @RoleNameID, @ModuleID, @SegmentID, 0, @newRoleName)
		
		SET @RoleID = SCOPE_IDENTITY()

	END

	DECLARE @actionType INT

	SELECT @actionType = ActionType
	FROM ActionTypeR
	WHERE Name = 'ManageExternalVerbatim'

	IF (@actionType IS NULL)
	BEGIN
		PRINT N'ManageExternalVerbatim is not defined as ActionType in ActionTypeR'
		RETURN
	END	

	DECLARE @ExternalVerbatimModuleActionId INT

	SELECT @ExternalVerbatimModuleActionId = ModuleActionId
	FROM ModuleActions
	WHERE ModuleId = @ModuleID
		AND ActionType = @actionType

	IF (@ExternalVerbatimModuleActionId IS NULL)
	BEGIN
		PRINT N'ManageExternalVerbatim is not defined as a SegmentAdmin action'
		RETURN
	END	

	UPDATE RA
	SET RA.Deleted = 0
	FROM RoleActions RA
		JOIN ModuleActions MA
			ON MA.ModuleActionId = RA.ModuleActionId
			AND MA.ModuleActionId = @ExternalVerbatimModuleActionId
	WHERE RA.RoleId = @RoleID

	INSERT INTO RoleActions
	(RoleID, GroupID, RestrictionMask, RestrictionStatus, ModuleActionId, SegmentID, Deleted)
	SELECT @RoleID, 1, 0, 0, MA.ModuleActionId, @SegmentID, 0
	FROM ModuleActions MA
		LEFT JOIN RoleActions RA
			ON MA.ModuleActionId = RA.ModuleActionId
			AND RA.RoleId = @RoleID
	WHERE MA.ModuleID = @ModuleID
		AND RA.RoleActionID IS NULL
		AND MA.ModuleActionId = @ExternalVerbatimModuleActionId

GO 