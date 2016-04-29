 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationLoadBySegmentID')
	DROP PROCEDURE spApplicationLoadBySegmentID
GO

CREATE PROCEDURE dbo.spApplicationLoadBySegmentID 
(
	@segmentID INT
)  
AS  
  
BEGIN  

SELECT DISTINCT A.*
	FROM Application A
		inner join ApplicationTrackableObject B on A.ApplicationID = B.ApplicationID
		inner join TrackableObjects C on B.TrackableObjectID = C.TrackableObjectID
	WHERE A.Deleted = 0 
		  AND B.Deleted = 0
		  AND C.SegmentId = @segmentID

END

GO
