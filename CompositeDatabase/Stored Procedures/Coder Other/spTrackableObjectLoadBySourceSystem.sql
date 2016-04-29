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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTrackableObjectLoadBySegmentOID')
	DROP PROCEDURE dbo.spTrackableObjectLoadBySegmentOID
GO
create procedure dbo.spTrackableObjectLoadBySegmentOID
(
	@segmentOID varchar(50)
)
as
begin
	select distinct t.* from TrackableObjects t
	inner join Segments s on t.SegmentId=s.SegmentID
	where s.OID = @segmentOID
		and t.ExternalObjectTypeId = 1
end