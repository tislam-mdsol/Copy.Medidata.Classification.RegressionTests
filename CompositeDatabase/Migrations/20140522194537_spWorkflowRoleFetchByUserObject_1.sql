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

if exists (select * from sysobjects where type = 'P' and name = 'spWorkflowRoleFetchByUserObject')
	drop procedure spWorkflowRoleFetchByUserObject
go

create procedure spWorkflowRoleFetchByUserObject
(
	@UserObjectID bigint,
	@UserObjectTypeID int,
	@GrantOnObjectID bigint,
	@GrantOnObjectTypeID bigint,
	@SegmentId INT,
	@UserTypeID int,
	@TrackableObjectTypeID int
)
as
begin
	declare @AllTrackableObjectsID int
	
	-- User does not have access to the segment
	IF NOT EXISTS (SELECT NULL FROM ObjectSegments
		WHERE ObjectID = @UserObjectID and ObjectTypeID = @UserObjectTypeID AND SegmentID = @SegmentId ) begin
		PRINT N'UserObjectId: ' + cast(@UserObjectID as varchar) + ' is not assigned to this segment:'  + cast(@SegmentId as varchar)	
		RETURN
	end
	
	declare @WorkflowRoles table(WorkflowRoleID int)
	declare @SecurityGroups table(SecurityGroupID int)

	set @AllTrackableObjectsID = -105
	if exists (select null from Configuration where Tag='SecurityAllTrackableObjectsID')
		select @AllTrackableObjectsID = cast(ConfigValue as int) from Configuration where Tag='SecurityAllTrackableObjectsID' 

		
	if (coalesce(@GrantOnObjectID, 0) <> 0) begin
		if (@UserObjectTypeID = @UserTypeID) begin --User Type
			insert into @WorkflowRoles 
			select WorkflowRoleID from UserObjectWorkflowRole
				where GrantToObjectId		= @UserObjectID 
					and GrantToObjectTypeId	= @UserTypeID 
					and DenyObjectRole		= 0
					and Active				= 1
					and SegmentId			= @SegmentId
					and ( @GrantOnObjectTypeID = @TrackableObjectTypeID and (
							GrantOnObjectId = @GrantOnObjectID or 
							GrantOnObjectId = @AllTrackableObjectsID))
					and WorkflowRoleId in (
						select WorkflowRoleId from WorkflowRoles R 
						inner join ModulesR M  on R.ModuleId = M.ModuleId and M.ObjectTypeID = @GrantOnObjectTypeID
						)
		end

	end
	else begin -- TrackableObject ID is not specified.
		
		insert into @WorkflowRoles 
		select R.WorkflowRoleId from WorkflowRoles R 
				inner join UserObjectWorkflowRole U on R.WorkflowRoleId = U.WorkflowRoleId and R.SegmentId = U.SegmentId
					where U.GrantToObjectID = @UserObjectID
					and U.GrantToObjectTypeID = @UserObjectTypeID
					and U.GrantOnObjectTypeID = @GrantOnObjectTypeID
					and U.DenyObjectRole	= 0
					and U.Active			= 1
					and R.Active			= 1
					and R.SegmentId			= @SegmentId
					
		
	end
	select distinct R.* 
		from WorkflowRoles R 
		inner join @WorkflowRoles T on R.WorkflowRoleId = T.WorkflowRoleID and R.Active = 1
		inner join ModulesR M on R.ModuleId = M.ModuleId and M.ObjectTypeID = @GrantOnObjectTypeID
end
go