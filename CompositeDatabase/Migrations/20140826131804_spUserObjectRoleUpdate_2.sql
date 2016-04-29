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
		@DenyObjectRole BIT,
		@SegmentID INT,
		@Deleted BIT,
		@UserObjectRoleId INT
)

AS

BEGIN
	
	 
	Update UserObjectRole
	SET GrantToObjectId     = @GrantToObjectId,
		GrantOnObjectId     = @GrantOnObjectId,
		RoleID              = @RoleID,
		Active              = @Active,
		Updated             = GetUtcDate(),
		DenyObjectRole      = @DenyObjectRole,
		SegmentID           = @SegmentID,
		Deleted             = @Deleted
	WHERE UserObjectRoleId = @UserObjectRoleId
	
END

GO