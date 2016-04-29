IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserObjectRoleInsert')
	BEGIN
		DROP  Procedure  spUserObjectRoleInsert
	END

GO

CREATE Procedure dbo.spUserObjectRoleInsert
(
		@GrantToObjectId INT,
		@GrantOnObjectId INT,
		@RoleID INT,
		@Active BIT,
		@DenyObjectRole BIT,
		@SegmentID INT,
		@UserObjectRoleId INT OUTPUT
)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	DECLARE @Created DATETIME = @UtcDate, @Updated DATETIME = @UtcDate  
	
	DECLARE @Deleted BIT =0
	 
	INSERT INTO UserObjectRole (
		GrantToObjectId,
		GrantOnObjectId,
		RoleID,
		Active,
		Created,
		Updated,
		DenyObjectRole,
		SegmentID,
		Deleted
	) VALUES (
	   	@GrantToObjectId,
		@GrantOnObjectId,
		@RoleID,
		@Active,
		@Created,
		@Updated,
		@DenyObjectRole,
		@SegmentID,
		@Deleted
	)  
	SET @UserObjectRoleId = SCOPE_IDENTITY() 
	
END

GO