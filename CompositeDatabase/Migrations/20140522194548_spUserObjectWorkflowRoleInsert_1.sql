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

if object_id('spUserObjectWorkflowRoleInsert') is not null
	drop procedure spUserObjectWorkflowRoleInsert
go

create procedure spUserObjectWorkflowRoleInsert
	@GrantToObjectID bigint,
	@GrantToObjectTypeID int,
	@GrantOnObjectID bigint,
	@GrantOnObjectTypeID bigint,
	@WorkflowRoleID bigint,
	@Active bit,
	@DenyObjectRole bit,
	@UserObjectWorkflowRoleID BIGINT OUTPUT,
	@SegmentId INT
as

declare @AllTrackableObjectRoleId int, @utcdatetime datetime
set @utcdatetime = GetUtcDate()


-- get the AllTrackableObjectRoleID from config
set @AllTrackableObjectRoleId = -105
if exists(select configvalue from Configuration where Tag='SecurityAllTrackableObjectsID')
	select @AllTrackableObjectRoleId = cast(configvalue as int) from Configuration where Tag='SecurityAllTrackableObjectsID'


-- make sure it is unique
IF NOT EXISTS (SELECT NULL FROM UserObjectWorkflowRole
	WHERE GrantToObjectTypeID = @GrantToObjectTypeID
		AND GrantToObjectID = @GrantToObjectID
		AND GrantOnObjectID = @GrantOnObjectID
		AND GrantOnObjectTypeID = @GrantOnObjectTypeID
		AND WorkflowRoleID = @WorkflowRoleID
		AND SegmentId = @SegmentId
		AND Active = 1)
BEGIN

	insert into UserObjectWorkflowRole (
		GrantToObjectID,
		GrantToObjectTypeID,
		GrantOnObjectID,
		GrantOnObjectTypeID,
		WorkflowRoleID,
		SegmentId, 
		Active,
		DenyObjectRole,
		Created,
		Updated)
	values (
		@GrantToObjectID,
		@GrantToObjectTypeID,
		@GrantOnObjectID,
		@GrantOnObjectTypeID,
		@WorkflowRoleID,
		@SegmentId,
		@Active,
		@DenyObjectRole,
		@utcdatetime,
		@utcdatetime)

	SET @UserObjectWorkflowRoleID = SCOPE_IDENTITY()  	
	
END
ELSE 
	SET @UserObjectWorkflowRoleID = -1
go
