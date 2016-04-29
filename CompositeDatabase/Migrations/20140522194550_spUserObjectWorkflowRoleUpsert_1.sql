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

if object_id('spUserObjectWorkflowRoleUpsert') is not null
	drop procedure dbo.spUserObjectWorkflowRoleUpsert
go

create procedure [dbo].[spUserObjectWorkflowRoleUpsert]
(
	@GrantToObjectID bigint,
	@GrantToObjectTypeID int,
	@GrantOnObjectID bigint,
	@GrantOnObjectTypeID bigint,
	@WorklfowRoleID bigint,
	@Active bit,
	@DenyObjectRole bit,
	@Count int output, -- 0: if inserted, 1:if updated
	@SegmentId INT
)
as
begin

	declare @AllTrackableObjectsId int, @utcdatetime datetime
	set @utcdatetime = GetUtcDate()

	
	-- get the @AllTrackableObjectsId from config
	set @AllTrackableObjectsId = -105
	if exists(select null from Configuration where Tag='SecurityAllTrackableObjectsID')
		select @AllTrackableObjectsId = cast(configvalue as int) from Configuration where Tag='SecurityAllTrackableObjectsID'
	
	if exists (select null from UserObjectWorkflowRole 
		where SegmentId = @SegmentId 
			and GrantToObjectID = @GrantToObjectID 
			and GrantToObjectTypeID = @GrantToObjectTypeID 
			and GrantOnObjectID = @GrantOnObjectID 
			and GrantOnObjectTypeID = @GrantOnObjectTypeID) begin
			
		update UserObjectWorkflowRole 
		set GrantToObjectID = @GrantToObjectID,
			GrantToObjectTypeID = @GrantToObjectTypeID,
			GrantOnObjectID = @GrantOnObjectID,
			GrantOnObjectTypeID = @GrantOnObjectTypeID,
			WorkflowRoleID = @WorklfowRoleID,
			SegmentId = @SegmentId,
			Active = @Active,
			DenyObjectRole = @DenyObjectRole,
			Updated = @utcdatetime
			where SegmentId = @SegmentId 
				and GrantToObjectID = @GrantToObjectID 
				and GrantToObjectTypeID = @GrantToObjectTypeID 
				and GrantOnObjectID = @GrantOnObjectID 
				and GrantOnObjectTypeID=@GrantOnObjectTypeID
				
			set @Count = 1
	end
	else begin		
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
			@WorklfowRoleID,
			@SegmentId,
			@Active,
			@DenyObjectRole,
			@utcdatetime,
			@utcdatetime)
			
			set @Count = 0
	end
end
go