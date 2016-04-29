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

if object_id('spUserObjectWorkflowRoleUpdate') is not null
	drop procedure spUserObjectWorkflowRoleUpdate
go

create procedure spUserObjectWorkflowRoleUpdate
	@UserObjectWorkflowRoleID BIGINT,
	@GrantToObjectID bigint,
	@GrantToObjectTypeID int,
	@GrantOnObjectID bigint,
	@GrantOnObjectTypeID bigint,
	@WorkflowRoleID bigint,
	@Active bit,
	@DenyObjectRole bit,
	@SegmentId INT
as

declare @AllTrackableObjectRoleId int, @utcdatetime datetime
set @utcdatetime = GetUtcDate()

-- get the AllTrackableObjectRoleID from config
set @AllTrackableObjectRoleId = -105
if exists(select configvalue from Configuration where Tag='SecurityAllTrackableObjectsID')
	select @AllTrackableObjectRoleId = cast(configvalue as int) from Configuration where Tag='SecurityAllTrackableObjectsID'


	update UserObjectWorkflowRole set
		GrantToObjectID = @GrantToObjectID,
		GrantToObjectTypeID = @GrantToObjectTypeID,
		GrantOnObjectID = @GrantOnObjectID,
		GrantOnObjectTypeID = @GrantOnObjectTypeID,
		WorkflowRoleID = @WorkflowRoleID,
		SegmentId = @SegmentId,
		Active = @Active,
		DenyObjectRole = @DenyObjectRole,
		Updated = @utcdatetime
	where UserObjectWorkflowRoleID = @UserObjectWorkflowRoleID


go
 