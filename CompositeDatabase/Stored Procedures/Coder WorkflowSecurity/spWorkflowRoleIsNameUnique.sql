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

IF object_id('spWorkflowRoleIsNameUnique') is not null
	drop procedure spWorkflowRoleIsNameUnique
go

create procedure spWorkflowRoleIsNameUnique
(
	@IsUnique bit output,
	@RoleName nvarchar(4000),
	@ModuleId int,
	@Locale char(3),
	@WorkflowRoleId bigint,
	@SegmentId INT
)
as
begin
	if exists ( select null from WorkflowRoles 
		where SegmentId  = @SegmentId
			and RoleName = @RoleName 
			and ModuleId = @ModuleId
			and WorkflowRoleId <> @WorkflowRoleId )
		set @IsUnique = 0
	else
		set @IsUnique = 1
end
go

