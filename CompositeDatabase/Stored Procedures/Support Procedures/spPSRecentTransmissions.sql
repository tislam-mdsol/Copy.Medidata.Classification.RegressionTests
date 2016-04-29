 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/


IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSRecentTransmissions')
	DROP PROCEDURE dbo.spPSRecentTransmissions
GO

CREATE PROCEDURE [dbo].[spPSRecentTransmissions]
(
	@StudyOID VARCHAR(50)
)
AS
BEGIN

	SELECT TOP 100 
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
		JOIN TrackableObjects STUDY ON STUDY.ExternalObjectId = TQ.StudyOID
		LEFT JOIN OutTransmissions OT ON TQ.OutTransmissionID = OT.OutTransmissionID
	WHERE
		StudyOID = @StudyOID
	ORDER BY TQ.TransmissionQueueItemID DESC

END
GO  