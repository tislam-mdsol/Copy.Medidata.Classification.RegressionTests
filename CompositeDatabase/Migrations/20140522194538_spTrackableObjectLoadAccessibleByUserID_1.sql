/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTrackableObjectLoadAccessibleByUserID')
	DROP PROCEDURE spTrackableObjectLoadAccessibleByUserID
GO

CREATE procedure [dbo].[spTrackableObjectLoadAccessibleByUserID]
(
	@UserID bigint,
	@ExternalObjectTypeId bigint,
	@SegmentId INT,
	@TrackableObjectTypeID INT,
	@UserTypeID INT
)
as
begin
	declare @AllTrackableObjectsID int

	declare @TrackableObjectByRole table (TrackableObjectID int)
	declare @TrackableObjectByGroup table (TrackableObjectID int)
	declare @TrackableObjectDeniedByRole table (TrackableObjectID int)
	
	set @AllTrackableObjectsID = -105
	if exists (select null from Configuration where Tag='SecurityAllTrackableObjectsID')
		select @AllTrackableObjectsID = cast(ConfigValue as int) from Configuration where Tag='SecurityAllTrackableObjectsID' 
	
	-- Check if User does not have access to the segment
	if NOT EXISTS (SELECT NULL FROM ObjectSegments
		WHERE ObjectID = @UserID and ObjectTypeID = @UserTypeID AND SegmentID = @SegmentId ) begin
		PRINT N'UserId: ' + cast(@UserID as varchar) + ' is not assigned to this segment:'  + cast(@SegmentId as varchar)	
		RETURN
	end
	
	-- if DenyObjectRole on @AllTrackableObjectsID -- return nothing
	if exists ( select null from UserObjectWorkflowRole 
			where GrantToObjectId = @UserID 
			and GrantToObjectTypeId = @UserTypeID
			and GrantOnObjectTypeId = @TrackableObjectTypeID
			and GrantOnObjectId = @AllTrackableObjectsID
			and DenyObjectRole = 1 
			and SegmentId = @SegmentId
			and Active = 1) begin
		
		select * from TrackableObjects where TrackableObjectID is null order by ExternalObjectOID
		return
	end

	-- get the TrackableObjects DeniedBy User Role assignement
	insert into @TrackableObjectDeniedByRole
		select P.TrackableObjectID from TrackableObjects P 
		inner join UserObjectWorkflowRole U on P.TrackableObjectID = U.GrantOnObjectId
				and U.GrantOnObjectTypeId = @TrackableObjectTypeID
				and U.GrantToObjectId = @UserID
				and U.GrantToObjectTypeId = @UserTypeID
				and Active = 1
				and U.DenyObjectRole = 1
				and U.SegmentId = @SegmentId
	
	-- find accessible TrackableObjectID in the segment assigned by @AllTrackableObjectsID for the user
	if exists ( select null from UserObjectWorkflowRole 
			where GrantToObjectId = @UserID
				and GrantToObjectTypeId = @UserTypeID
				and GrantOnObjectTypeId = @TrackableObjectTypeID
				and GrantOnObjectId = @AllTrackableObjectsID
				and Active = 1
				and DenyObjectRole = 0 
				and SegmentId = @SegmentId) begin
				
		insert into @TrackableObjectByRole 
		select TrackableObjectID from TrackableObjects 
			where SegmentId = @SegmentId
				and (@ExternalObjectTypeId = 0 or ExternalObjectTypeId = @ExternalObjectTypeId)
	end
	else begin -- find accessible TrackableObjectID in the segment assigned by individual TrackableObjectsID for the user
		insert into @TrackableObjectByRole
		select P.TrackableObjectID from TrackableObjects P 
			inner join UserObjectWorkflowRole U on P.TrackableObjectID = U.GrantOnObjectId
				and U.GrantOnObjectTypeId = @TrackableObjectTypeID
				and U.GrantToObjectId = @UserID
				and U.GrantToObjectTypeId = @UserTypeID
				and Active = 1
				and U.DenyObjectRole = 0
				and U.SegmentId = @SegmentId
	end
	
	-- get the combined TrackableObjects by User+SecurityGroup excluding DeniedByRole
	select distinct P2.* from (
		(
			select P.* from TrackableObjects P 
			inner join @TrackableObjectByRole T 
				on P.TrackableObjectID = T.TrackableObjectID
				AND P.SegmentID = @SegmentId
		)
		union
		(
			select P.* from TrackableObjects P 
			inner join @TrackableObjectByGroup T 
				on P.TrackableObjectID = T.TrackableObjectID
				AND P.SegmentID = @SegmentId
		)
	) P2
	where P2.TrackableObjectID not in (select TrackableObjectID from @TrackableObjectDeniedByRole) order by P2.ExternalObjectOID
end
 