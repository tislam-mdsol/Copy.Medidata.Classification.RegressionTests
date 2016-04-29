/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

-- spLoadAllBatchesForSegment 10

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLoadAllBatchesForSegment')
	DROP PROCEDURE spLoadAllBatchesForSegment
GO
CREATE PROCEDURE dbo.spLoadAllBatchesForSegment
(
	@SegmentID INT
)
AS
BEGIN
        
	SELECT DISTINCT(BatchOID) FROM CodingRequests
	WHERE SegmentId = @SegmentID
		AND ISNULL(BatchOID, '') <> ''

END	
GO  
