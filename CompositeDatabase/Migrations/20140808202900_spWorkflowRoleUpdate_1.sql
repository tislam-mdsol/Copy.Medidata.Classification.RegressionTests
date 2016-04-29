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

IF object_id('spWorkflowRoleUpdate') is not null
	drop  procedure spWorkflowRoleUpdate
go

create procedure spWorkflowRoleUpdate
	@WorkflowRoleID bigint,
	@RoleName NVARCHAR(1000),
	@WorkflowId int,
	@ModuleId tinyint,
	@Active bit,
	@Updated datetime output,
	@SegmentID INT
as
begin

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SET @Updated = @UtcDate  
	  
	UPDATE dbo.WorkflowRoles SET  
		RoleName = @RoleName,
		WorkflowId = @WorkflowId,
		ModuleId = @ModuleId,
		Active = @Active,
		Updated = @UtcDate  
	WHERE WorkflowRoleID = @WorkflowRoleID  
	
END  
GO