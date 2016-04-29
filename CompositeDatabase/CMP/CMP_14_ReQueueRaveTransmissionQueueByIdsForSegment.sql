 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Connor Ross cross@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

/*
// This will requeue ANY transmissions NOT ONLY failed
*/


IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'CMP_14_ReQueueRaveTransmissionQueueByIdsForSegment')
DROP PROCEDURE dbo.CMP_14_ReQueueRaveTransmissionQueueByIdsForSegment
GO

CREATE PROCEDURE [dbo].CMP_14_ReQueueRaveTransmissionQueueByIdsForSegment
(
	@SegmentOID varchar(50),
	@CommaDelimitedTransmissionQueueItemIds NVARCHAR(MAX)
)

AS
BEGIN

	DECLARE @SegmentID INT, @errorString NVARCHAR(MAX)
	
	SELECT @SegmentID = SegmentID
	FROM Segments
	WHERE OID = @SegmentOID
	
	IF (@SegmentID IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	DECLARE @TransmissionQueueItemIds TABLE (TransmissionQueueItemId BIGINT PRIMARY KEY, SegmentId INT)
	INSERT INTO @TransmissionQueueItemIds(TransmissionQueueItemId, SegmentId)
	SELECT *, -1 FROM dbo.fnParseDelimitedString(@CommaDelimitedTransmissionQueueItemIds,',')
	
	UPDATE
		@TransmissionQueueItemIds
	SET
		SegmentId = TransmissionQueueItems.SegmentId
	FROM
		@TransmissionQueueItemIds t
	INNER JOIN
		TransmissionQueueItems
	ON
		t.TransmissionQueueItemId = TransmissionQueueItems.TransmissionQueueItemID
		
	IF EXISTS (SELECT NULL FROM @TransmissionQueueItemIds WHERE SegmentId <> @SegmentID)
	BEGIN
		SET @errorString = N'ERROR: TransmissionQueueItemIds are not in segment or do not exist!'
		PRINT @errorString
		SELECT * FROM @TransmissionQueueItemIds WHERE SegmentId <> @SegmentID
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	UPDATE
		TransmissionQueueItems
	SET
		CumulativeFailCount = CumulativeFailCount + FailureCount, 
		FailureCount = 0,  
		SuccessCount = 0,
		ServiceWillContinueSending = 1
	FROM
		TransmissionQueueItems t
	INNER JOIN
		@TransmissionQueueItemIds ts
	ON
		ts.TransmissionQueueItemId = t.TransmissionQueueItemID
 
END
GO