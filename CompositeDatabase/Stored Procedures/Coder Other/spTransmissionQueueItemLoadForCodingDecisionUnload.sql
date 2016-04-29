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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTransmissionQueueItemLoadForCodingDecisionUnload')
	DROP PROCEDURE spTransmissionQueueItemLoadForCodingDecisionUnload
GO

CREATE PROCEDURE dbo.spTransmissionQueueItemLoadForCodingDecisionUnload 
(
	@SourceSystemID BIGINT, 
	@SegmentID INT, 
	@StudyOID VARCHAR(50),
	@MaxNumberOfItems INT
)
AS  
  
BEGIN  

SELECT TOP (@MaxNumberOfItems) *
FROM dbo.TransmissionQueueItems
WHERE SegmentID = @SegmentID
	AND SourceSystemID = @SourceSystemID
	AND StudyOID = @StudyOID
	AND IsForUnloadService = 1
	AND SuccessCount = 0
	ORDER BY Created ASC

END

GO 