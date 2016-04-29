﻿IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleActionUpdate')
	BEGIN
		DROP  Procedure  spRoleActionUpdate
	END

GO

CREATE Procedure dbo.spRoleActionUpdate
(
		@RoleID INT,
		@ModuleActionId INT,
		@SegmentID INT,
		@RestrictionMask INT,
		@RestrictionStatus INT,
		@RoleActionID INT,
		@Deleted BIT
)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	DECLARE @Updated DATETIME = @UtcDate  
	
	 
	UPDATE RoleActions 
	SET 
		RoleID            = @RoleID,
		Updated           = @Updated,
		ModuleActionId    = @ModuleActionId,
		SegmentID         = @SegmentID,
		RestrictionMask   = @RestrictionMask,
		RestrictionStatus = @RestrictionStatus,
		Deleted           = @Deleted
	 WHERE RoleActionID = @RoleActionID
	
END

GO