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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TF' AND name = 'fnTrackableObjectsLoad')
	DROP FUNCTION dbo.fnTrackableObjectsLoad
GO
create function [dbo].[fnTrackableObjectsLoad](@SegmentId int, @ExternalObjectTypeId bigint)
	returns @Objects table(ObjectID int, ObjectNameID int, ObjectNameString nvarchar(200)) 
as
begin
	insert into @Objects(ObjectID, ObjectNameID, ObjectNameString) 
		select TrackableObjectID, ExternalObjectNameId, ExternalObjectOID 
		from TrackableObjects 
			where SegmentId = @SegmentId
			and (@ExternalObjectTypeId=0 OR ExternalObjectTypeId = @ExternalObjectTypeId)
		union
		select cast(ConfigValue as int), 0, '[AllTrackableObjects]' from Configuration 
			where Tag = 'SecurityAllTrackableObjectsID'
		Order by ExternalObjectOID
	return
end