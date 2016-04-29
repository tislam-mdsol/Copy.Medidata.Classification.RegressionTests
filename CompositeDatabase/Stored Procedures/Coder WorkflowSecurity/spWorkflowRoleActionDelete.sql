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

IF object_id('spWorkflowRoleActionDelete') is not null
	DROP  Procedure  spWorkflowRoleActionDelete
GO

CREATE Procedure spWorkflowRoleActionDelete
(
	@WorkflowRoleActionID bigint
)
AS
BEGIN
	
	delete from WorkflowRoleActions where WorkflowRoleActionID=@WorkflowRoleActionID
	
	/*
	declare @WorkflowRoleID bigint, @RoleName nvarchar(2000), @msg nvarchar(2000)
	select @WorkflowRoleID = WorkflowRoleID from WorkflowRoleActions where WorkflowRoleActionID=@WorkflowRoleActionID
	
	-- 1. cannot delete this  WorkflowRoleAction if it is being used in UserObjectWorkflowRole
	if exists (select null from UserObjectWorkflowRole uowr
		inner join WorkflowRoleActions wra on uowr.WorkflowRoleID = wra.WorkflowRoleID and uowr.SegmentId = wra.SegmentId
		where uowr.Active = 1 and wra.WorkflowRoleActionID = @WorkflowRoleActionID) begin
		
		select @RoleName = dbo.fnLocalDefault(RoleNameID) from WorkflowRoles where WorkflowRoleID = @WorkflowRoleID
		set @msg = 'There are active Users or Groups associated with this WorkflowRoleActionID ' + cast(@WorkflowRoleActionID as nvarchar) + '(' + @RoleName + ')'
		raiserror(@msg, 16, 1)
		return
	end
	else begin
	
		begin transaction
		
		
		if (@@error <> 0) begin
			rollback transaction
			set @msg = 'Failed to delete workflow actions for WorkflowRoleActionID ' + cast(@WorkflowRoleActionID as nvarchar)
			raiserror(@msg, 16, 1)
			return
		end
		commit transaction
	end
	*/
END
GO
 