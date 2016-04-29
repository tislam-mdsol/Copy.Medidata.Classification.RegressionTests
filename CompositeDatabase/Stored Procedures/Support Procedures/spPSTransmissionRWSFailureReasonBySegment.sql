/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Connor Ross cross@mdsol.com
//
// Description:
//  Outputs information as to why terms
//   are failing from RWS even after
//   attempting 5 or more times
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spPSTransmissionRWSFailureReasonBySegment')
	DROP PROCEDURE spPSTransmissionRWSFailureReasonBySegment
GO

--EXEC spPSTransmissionRWSFailureReasonBySegment 'AZ1_CODER_CVGI', '2014-01-01'

CREATE PROCEDURE dbo.spPSTransmissionRWSFailureReasonBySegment
(  
	@SegmentName NVARCHAR(255),
    @LastTransmissionDateAfter DATETIME
)  
AS
BEGIN


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @SegmentId BIGINT
DECLARE @SourceSystemId BIGINT
DECLARE @errorString NVARCHAR(MAX)

SELECT @SegmentId = SegmentId
FROM Segments
WHERE SegmentName = @SegmentName

IF (ISNULL(@SegmentId, 0) < 1)
BEGIN
	SET @errorString = 'Cannot find Segment - exiting!'
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END
-- Get source system from
--  most recent coding element
--  for the requested segment
SELECT TOP 1 @SourceSystemId = SourceSystemId
FROM CodingElements
WHERE SegmentId = @SegmentId
ORDER BY CodingElementId DESC

;WITH Affected_Transmissions_CTE AS (
	SELECT TQI.TransmissionQueueItemId,
		   TQI.SegmentID,
		   TQI.SuccessCount,
		   TQI.FailureCount,
	       CONVERT(XML, OT.ResponseText) ResponseXml,
		   OT.HttpStatusCode,
		   OT.Created,
		   TQI.ObjectId
	FROM TransmissionQueueItems TQI
	JOIN OutTransmissions OT ON OT.OutTransmissionID = TQI.OuttransmissionId
	WHERE TQI.SourceSystemId = @SourceSystemId
	AND TQI.FailureCount > 0
	AND TQI.SuccessCount = 0
	AND TQI.ServiceWillContinueSending = 0
	AND OT.ResponseText <> ''
	AND OT.ResponseText LIKE '<%'
	AND TQI.ObjectTypeId in (2255, 2251)
	AND OT.Created >= @LastTransmissionDateAfter
),
-- Read xml attributes on response node
--  from rws
Parsed_Respose_CTE AS (
	SELECT AT.TransmissionQueueItemId,
	       r.t.value('@ReasonCode','NVARCHAR(255)') 'RWS_Code',
		   r.t.value('@ErrorClientResponseMessage','NVARCHAR(255)') 'ErrorMessage'
	FROM Affected_Transmissions_CTE AT
	CROSS APPLY AT.ResponseXml.nodes('Response') AS r(t)
),
-- hydrate task information
--  for transmission queue items
Task_Information_CTE AS (
	SELECT AT.TransmissionQueueItemId,
	       CE.VerbatimTerm,
		   CE.AssignedTermText,
		   CE.SourceSubject,
		   CE.SourceForm,
		   CE.SourceField,
		   ST.ExternalObjectName,
		   S.SegmentName
	FROM Affected_Transmissions_CTE AT
	JOIN CodingAssignment CA ON CA.CodingAssignmentID = AT.ObjectID
	JOIN CodingElements CE ON CE.CodingElementId = CA.CodingElementID
	JOIN Segments S ON S.SegmentId = AT.SegmentId
	JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = CE.StudyDictionaryVersionId
	JOIN TrackableObjects ST ON ST.TrackableObjectId = SDV.StudyId
)
SELECT TI.SegmentName Segment,
       TI.ExternalObjectName Study,
	   TI.SourceSubject Subject,
	   TI.SourceForm Form,
	   TI.SourceField Field,
	   TI.VerbatimTerm Verbatim,
	   TI.AssignedTermText 'Assigned Term',
	   PR.RWS_Code 'RWS Error Code',
	   PR.ErrorMessage 'Error Message',
	   AT.HttpStatusCode,
	   AT.Created 'Last Transmission Attempt Date'
FROM Affected_Transmissions_CTE AT
JOIN Parsed_Respose_CTE PR ON PR.TransmissionQueueItemId = AT.TransmissionQueueItemId
JOIN Task_Information_CTE TI ON TI.TransmissionQueueItemId = AT.TransmissionQueueItemId
WHERE TI.SegmentName = @SegmentName
ORDER BY Segment, Study, Subject, Form, Field, Verbatim

END
GO