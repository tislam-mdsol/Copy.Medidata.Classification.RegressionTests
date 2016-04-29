/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateMedidataAppAdminRole')
	DROP PROCEDURE spCreateMedidataAppAdminRole
GO
CREATE PROCEDURE spCreateMedidataAppAdminRole
(
	@RoleName NVARCHAR(200),
	@RoleOID VARCHAR(50),
	@SegmentID INT,
	@Locale CHAR(3),
	@UserLogin NVARCHAR(100),
	@SegmentTypeID INT,
	@UserTypeID INT,
	@moduleTypeID INT
)
AS

	--SELECT @RoleOID = 'SegmentAdmin', 
	--		@RoleName = 'SegmentAdmin',
	--		@SegmentID = 2, 
	--		@Locale = 'eng',
	--		@UserLogin = 'cdm1'

	DECLARE @ModuleID INT

	SELECT @ModuleID = ModuleId
	FROM ModulesR
	WHERE ObjectTypeId = @SegmentTypeID
		AND ModuleName = 'ApplicationSecurity'

	IF (@ModuleID IS NULL)
	BEGIN
		PRINT N'ApplicationSecurity Module is not defined'
		RETURN
	END

	DECLARE @UserID INT

	SELECT @UserID = UserID
	FROM Users
	WHERE Login = @UserLogin

	IF (@UserID IS NULL)
	BEGIN
		PRINT N'Cannot find UserId for Login:[' + @UserLogin + N']'
		RETURN
	END

	IF NOT EXISTS (SELECT NULL FROM Segments WHERE SegmentID = @SegmentID)
	BEGIN
		PRINT N'Cannot find segmentID:['+CAST(@SegmentID AS VARCHAR)+']'
		RETURN
	END
	
	-- 0. Make sure ObjectSegments entry exists - otherwise create it
	DECLARE @ObjectSegmentID INT
	
	SELECT @ObjectSegmentID = ObjectSegmentID
	FROM ObjectSegments
	WHERE ObjectID = @ModuleID
		AND ObjectTypeID = @moduleTypeID
		AND SegmentID = @SegmentID
		
	IF (@ObjectSegmentID IS NULL)
	BEGIN
		-- create the connection
		INSERT INTO ObjectSegments
		(ObjectID, ObjectTypeID, SegmentID,  ReadOnly, DefaultSegment, Deleted)
		VALUES(@ModuleID, @moduleTypeID, @SegmentID, 0, 0, 0)
		
		SET @ObjectSegmentID = SCOPE_IDENTITY()
		
	END
	

	-- 1. Setup SuperUser Role
	DECLARE @RoleID INT

	SELECT @RoleID = RoleID
	FROM RolesAllModules
	WHERE ModuleID = @ModuleID
		AND SegmentID = @SegmentID
		
	IF (@RoleID IS NULL)
	BEGIN

		DECLARE @RoleNameID INT

		EXEC spLclztnFndOrInsrtDtStrng @RoleName, @Locale, @RoleNameID OUTPUT, @SegmentID

		INSERT INTO RolesAllModules
		(Active, RoleNameID, ModuleId, SegmentID, Deleted, OID)
		VALUES(1, @RoleNameID, @ModuleID, @SegmentID, 0, @RoleOID)
		
		SET @RoleID = SCOPE_IDENTITY()

	END


	-- fix actions
	IF NOT EXISTS (SELECT NULL FROM ModuleActions
		WHERE ModuleID = @ModuleID)
	BEGIN
		PRINT N'No ModuleActions are defined for ApplicationModule'
		RETURN
	END
	
	UPDATE RoleActions
	SET Deleted = 0
	WHERE RoleId = @RoleID

	INSERT INTO RoleActions
	(RoleID, GroupID, RestrictionMask, RestrictionStatus, ModuleActionId, SegmentID, Deleted)
	SELECT @RoleID, 1, 0, 0, MA.ModuleActionId, @SegmentID, 0
	FROM ModuleActions MA
		LEFT JOIN RoleActions RA
			ON MA.ModuleActionId = RA.ModuleActionId
			AND RA.RoleId = @RoleID
	WHERE MA.ModuleID = @ModuleID
		AND RA.RoleActionID IS NULL


	-- fix the user object role assignment
	DECLARE @userObjRoleID INT

	SELECT @userObjRoleID = UserObjectRoleId
	FROM UserObjectRole
	WHERE GrantOnObjectId = @SegmentID
		AND GrantOnObjectTypeId = @SegmentTypeID
		AND GrantToObjectId = @UserID
		AND GrantToObjectTypeId = @UserTypeID
		AND SegmentID = @SegmentID
		AND RoleId = @RoleID
		
	IF (@userObjRoleID IS NOT NULL)
	BEGIN
		-- make sure assignment is active
		UPDATE UserObjectRole
		SET Active = 1, Deleted = 0, DenyObjectRole = 0
		WHERE UserObjectRoleID = @userObjRoleID
			
	END
	ELSE
	BEGIN
		-- create if does not exist
		INSERT INTO UserObjectRole
		(GrantOnObjectId, GrantOnObjectTypeId, GrantToObjectId, GrantToObjectTypeId, Active, RoleID, SegmentID, Deleted, DenyObjectRole)
		VALUES(@SegmentID, @SegmentTypeID, @UserID, @UserTypeID, 1, @RoleID, @SegmentID, 0, 0) 

	END

GO  