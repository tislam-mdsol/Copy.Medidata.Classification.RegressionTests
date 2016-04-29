 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
// ------------------------------------------------------------------------------------------------------*/


IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSCoderToRaveIssue')
DROP PROCEDURE dbo.spPSCoderToRaveIssue
GO

CREATE PROCEDURE [dbo].[spPSCoderToRaveIssue]

@SegmentName NVARCHAR(255),
@StudyName NVARCHAR(2000)

AS
BEGIN

 -- Show coding responses to Rave apps, with study, and http
SELECT top 100 AP.Name as App, 
STUDY.ExternalObjectName as StudyName, 
TQ.TransmissionQueueItemID,
TQ.ObjectTypeID,
TQ.ObjectID,
TQ.StudyOID,
TQ.FailureCount,
TQ.SuccessCount,
TQ.SourceSystemID,
TQ.Created,
TQ.Updated,
TQ.SegmentID,
SG.SegmentName,
TQ.CumulativeFailCount,
TQ.ServiceWillContinueSending,
TQ.IsForUnloadService,
OT.OutTransmissionID,
OT.TransmissionTypeID,
OT.Acknowledged,
OT.AcknowledgeDate,
OT.TransmissionSuccess,
OT.TransmissionDate,
OT.HttpStatusCode,
OT.WebExceptionStatus,
OT.ResponseText 
FROM TransmissionQueueItems TQ
INNER JOIN Application AP ON AP.SourceSystemID = TQ.SourceSystemID
INNER JOIN Segments SG ON TQ.SegmentID = SG.SegmentId
INNER JOIN TrackableObjects STUDY ON STUDY.ExternalObjectId = TQ.StudyOID
LEFT JOIN OutTransmissions OT ON TQ.OutTransmissionID = OT.OutTransmissionID
WHERE TQ.FailureCount > 0 and SG.SegmentName = @SegmentName and STUDY.ExternalObjectName = @StudyName-- or to confirm success, use TQ.SuccessCount = 1
ORDER BY TQ.Created DESC
 
END
GO