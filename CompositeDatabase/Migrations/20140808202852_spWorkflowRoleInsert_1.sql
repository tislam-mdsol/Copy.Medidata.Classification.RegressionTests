/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF object_id('spWorkflowRoleInsert') is not null
	drop  procedure spWorkflowRoleInsert
go

create procedure spWorkflowRoleInsert
	@RoleName NVARCHAR(1000),
	@WorkflowId int,
	@ModuleId tinyint,
	@Active bit,
	@WorkflowRoleID int output,
	@Created datetime output,
	@Updated datetime output,
	@SegmentId INT
as
begin
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	

	INSERT INTO dbo.WorkflowRoles (  
	  RoleName,  
	  WorkflowId, 
	  ModuleId, 
	  SegmentId,  
	  Active,
	  Created,  
	  Updated  
	 ) 
	 VALUES (  
	  @RoleName,  
	  @WorkflowId,
	  @ModuleId,  
	  @SegmentId,  
	  @Active,
	  @UtcDate,  
	  @UtcDate  
	 )  
	 SET @WorkflowRoleID = SCOPE_IDENTITY()  
end
go
