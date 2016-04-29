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

IF object_id('spWorkflowRoleDelete') is not null
	drop procedure spWorkflowRoleDelete
go

create procedure spWorkflowRoleDelete
(
	@WorkflowRoleID bigint
)
as
begin
	declare @RoleName nvarchar(2000), @msg nvarchar(2000), @CoderAdminDefaultRole int
	
	--select @CoderAdminDefaultRole = cast(ConfigValue as int) from Configuration where Tag = 'CoderAdminDefaultRole'
	--select @CoderAdminDefaultRole = DefaultRoleId from ModulesR where ModuleName='MedidataCoder'
	
	if (@CoderAdminDefaultRole is not null and @CoderAdminDefaultRole = @WorkflowRoleID) begin
		raiserror('This role is used as the default role at coding task creation. You must change the default to another role before deleting this Role.', 16, 1)
		return
	end
	else if exists (select null from UserObjectWorkflowRole where WorkflowRoleID = @WorkflowRoleID and Active = 1) begin
		select @RoleName = dbo.fnLocalDefault(RoleNameID) from WorkflowRoles where WorkflowRoleID = @WorkflowRoleID
		set @msg = 'There are active UserObjects associated with this WorkflowRoleID ' + cast(@WorkflowRoleID as nvarchar) + '(' + @RoleName + ')'
		raiserror(@msg, 16, 1)
		return
	end
	else begin
		begin transaction
		delete from UserObjectWorkflowRole where WorkflowRoleId = @WorkflowRoleID and Active = 0
		
		if (@@error <> 0) begin
			rollback transaction
			set @msg = 'Failed to delete inactive entries from table UserObjectWorkflowRole with WorkflowRoleID ' + cast(@WorkflowRoleID as nvarchar)
			raiserror(@msg, 16, 1)
			return
		end
		
		delete from WorkflowRoleActions where WorkflowRoleId = @WorkflowRoleID
		
		if (@@error <> 0) begin
			rollback transaction
			set @msg = 'Failed to delete workflow actions for WorkflowRoleId ' + cast(@WorkflowRoleID as nvarchar)
			raiserror(@msg, 16, 1)
			return
		end
		
		delete from WorkflowRoles where WorkflowRoleId = @WorkflowRoleID
		if (@@error <> 0) begin
			rollback transaction
			set @msg = 'Failed to delete record with WorkflowRoleId ' + cast(@WorkflowRoleID as nvarchar) + ' from table WorkflowRoles.'
			raiserror(@msg, 16, 1)
			return
		end
		commit transaction
	end
end
go
 