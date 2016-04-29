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

IF object_id('spWorkflowRoleLoadByModuleId') is not null
	drop procedure spWorkflowRoleLoadByModuleId
GO

create proc spWorkflowRoleLoadByModuleId
	@ModuleID int,
	@Locale char(3),
	@ActiveRolesOnly bit,
	@SegmentId INT
as
Begin
	select R.* from WorkflowRoles R 
	inner join ModulesR M on R.ModuleId = M.ModuleId 
		AND R.SegmentId = @SegmentId
	where R.ModuleID = @ModuleID 
		and ((@ActiveRolesOnly=1 AND R.Active=1) OR (@ActiveRolesOnly=0)) 
		and R.WorkflowRoleID > 0
	order by R.RoleName
end
GO
 