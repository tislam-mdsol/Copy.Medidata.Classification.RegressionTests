

/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Dan Dapper ddapper@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

/*
// Reports transmission queue item information for segment, comma-delimited list of (codingelement) UUIDs
*/


IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'CMP_ReportTransmissionQueueItemsByUUID')
DROP PROCEDURE dbo.CMP_ReportTransmissionQueueItemsByUUID
GO

CREATE PROCEDURE [dbo].CMP_ReportTransmissionQueueItemsByUUID
(
	@SegmentName VARCHAR(250),
	@CommaDelimitedUUIDs NVARCHAR(MAX)
)

AS
BEGIN

	DECLARE @SegmentID INT, @errorString NVARCHAR(MAX), @Counter int
	DECLARE @UUIDs TABLE (UUID NVARCHAR(100) PRIMARY KEY)

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT @SegmentId = SegmentId
	FROM Segments
	WHERE SegmentName = @SegmentName
	
	IF (@SegmentId IS NULL)
	BEGIN
		SET @errorString = N'ERROR: Segment not found!'
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	INSERT INTO @UUIDs (UUID)
	SELECT * FROM dbo.fnParseDelimitedString(@CommaDelimitedUUIDs, ',')

	SELECT 
		TQI.TransmissionQueueItemID, U.UUID, TQI.FailureCount, TQI.SuccessCount, OT.HttpStatusCode, OT.ResponseText, 
		TQI.Updated, TQI.ServiceWillContinueSending, OT.Acknowledged, OT.TransmissionDate, OT.AcknowledgeDate, 
		replace(replace(replace(replace(replace(OT.TextToTransmit, '<', '('), '>', ')'), char(10), ''), char(13), ''), ',', ';') TextToTransmit
	FROM @UUIDs U
	JOIN CodingElements CE ON U.UUID = CE.UUID and CE.SegmentId = @SegmentId
	JOIN CodingAssignment CA ON CA.CodingElementID = CE.CodingElementId AND CA.Active = 1
	JOIN TransmissionQueueItems TQI on TQI.ObjectId = CA.CodingAssignmentID AND TQI.ObjectTypeID = 2251
	LEFT JOIN OutTransmissions OT on OT.OutTransmissionID = TQI.OutTransmissionID
	ORDER BY TQI.TransmissionQueueItemID
END
GO

