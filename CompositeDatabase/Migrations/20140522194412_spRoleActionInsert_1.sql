IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleActionInsert')
	BEGIN
		DROP  Procedure  spRoleActionInsert
	END

GO

CREATE Procedure dbo.spRoleActionInsert
(
		@RoleID INT,
		@ModuleActionId INT,
		@SegmentID INT,
		@RestrictionMask INT,
		@RestrictionStatus INT,
		@RoleActionID INT OUTPUT
)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	DECLARE @Created DATETIME = @UtcDate, @Updated DATETIME = @UtcDate  
	
	 
	INSERT INTO RoleActions (
		RoleID,
		Created,
		Updated,
		ModuleActionId,
		SegmentID,
		RestrictionMask,
		RestrictionStatus
	) VALUES (
	    @RoleID,
		@Created,
		@Updated,
		@ModuleActionId,
		@SegmentID,
		@RestrictionMask,
		@RestrictionStatus
	)  
	SET @RoleActionID = SCOPE_IDENTITY() 
	
END

GO