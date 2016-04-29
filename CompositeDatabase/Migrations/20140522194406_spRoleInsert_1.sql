IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleInsert')
	BEGIN
		DROP  Procedure  spRoleInsert
	END

GO

CREATE Procedure dbo.spRoleInsert
(
		@Active BIT,
		@RoleNameID INT,
		@ModuleId INT,
		@SegmentID INT,
		@OID VARCHAR(50),
		@RoleID INT OUTPUT
)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	DECLARE @Created DATETIME = @UtcDate, @Updated DATETIME = @UtcDate  
	
	 
	INSERT INTO RolesAllModules (
		Active,
		Created,
		Updated,
		RoleNameID,
		ModuleId,
		SegmentID,
		OID
	) VALUES (
		@Active,
		@Created,
		@Updated,
		@RoleNameID,
		@ModuleId,
		@SegmentID,
		@OID
	)  
	SET @RoleID = SCOPE_IDENTITY() 
	
END

GO