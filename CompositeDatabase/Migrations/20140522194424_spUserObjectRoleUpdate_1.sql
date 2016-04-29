IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserObjectRoleUpdate')
	BEGIN
		DROP  Procedure  spUserObjectRoleUpdate
	END

GO

CREATE Procedure dbo.spUserObjectRoleUpdate
(
		@GrantToObjectId INT,
		@GrantOnObjectId INT,
		@RoleID INT,
		@Active BIT,
		@GrantOnObjectTypeId INT,
		@GrantToObjectTypeId INT,
		@DenyObjectRole BIT,
		@SegmentID INT,
		@Deleted BIT,
		@UserObjectRoleId INT
)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	DECLARE @Updated DATETIME = @UtcDate  
	
	 
	Update UserObjectRole
	SET GrantToObjectId     = @GrantToObjectId,
		GrantOnObjectId     = @GrantOnObjectId,
		RoleID              = @RoleID,
		Active              = @Active,
		Updated             = @Updated,
		GrantOnObjectTypeId = @GrantOnObjectTypeId,
		GrantToObjectTypeId = @GrantToObjectTypeId,
		DenyObjectRole      = @DenyObjectRole,
		SegmentID           = @SegmentID,
		Deleted             = @Deleted
	WHERE UserObjectRoleId = @UserObjectRoleId
	
END

GO