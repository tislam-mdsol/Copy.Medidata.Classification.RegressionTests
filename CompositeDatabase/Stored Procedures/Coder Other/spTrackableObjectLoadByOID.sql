 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Mark Hwe mhwe@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTrackableObjectLoadByOID')
	DROP PROCEDURE dbo.spTrackableObjectLoadByOID
GO
create procedure dbo.spTrackableObjectLoadByOID
(
	@TrackableObjectOID varchar(50),
	@segmentID bigint
)
as
begin
	select * from TrackableObjects
	where SegmentId = @segmentID
		and ExternalObjectTypeId = 1
		and ExternalObjectOID = @TrackableObjectOID
end