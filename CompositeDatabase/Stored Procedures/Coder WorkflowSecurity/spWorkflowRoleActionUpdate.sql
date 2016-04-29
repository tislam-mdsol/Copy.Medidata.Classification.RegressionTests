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

IF object_id('spWorkflowRoleActionUpdate') is not null
	drop  procedure spWorkflowRoleActionUpdate
go

create procedure spWorkflowRoleActionUpdate
	@WorkflowRoleActionID bigint,
	@WorkflowRoleID  bigint,
	@WorkflowActionId int,
	@Updated datetime output
as
begin

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SET @Updated = @UtcDate  
	  
	UPDATE dbo.WorkflowRoleActions SET  
		WorkflowRoleID = @WorkflowRoleID,
		WorkflowActionId = @WorkflowActionId,
		Updated = @UtcDate  
	WHERE WorkflowRoleActionID = @WorkflowRoleActionID  
	
END  
GO 