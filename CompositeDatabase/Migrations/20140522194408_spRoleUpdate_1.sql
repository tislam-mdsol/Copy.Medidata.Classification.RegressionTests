IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleUpdate')
	BEGIN
		DROP  Procedure  spRoleUpdate
	END

GO

CREATE Procedure dbo.spRoleUpdate
(
        @RoleID INT,
		@Active BIT,
		@RoleNameID INT,
		@ModuleId INT,
		@SegmentID INT,
		@Deleted BIT,
		@OID VARCHAR(50)
)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	DECLARE @Updated DATETIME = @UtcDate  
	
	 
	Update RolesAllModules 
	SET 
		Active = @Active,
		RoleNameID = @RoleNameID,
		ModuleId = @ModuleId,
		SegmentID = @SegmentID,
		OID = @OID,
		Updated = @Updated,
		Deleted = @Deleted
	WHERE RoleID = @RoleID
	
END

GO