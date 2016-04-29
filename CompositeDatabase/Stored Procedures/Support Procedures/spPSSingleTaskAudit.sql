IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSSingleTaskAudit')
	DROP PROCEDURE dbo.spPSSingleTaskAudit
GO

CREATE PROCEDURE [dbo].[spPSSingleTaskAudit]

	@CodingElementID BIGINT,
	@CodingElementUUID NVARCHAR(100),
	@SegmentName NVARCHAR(255)

AS
BEGIN

	DECLARE @id BIGINT = NULL

	IF (ISNULL(@CodingElementID, 0) < 1)
	BEGIN
		SELECT @id = CodingElementId
		FROM CodingElements
		WHERE UUID = @CodingElementUUID
			AND SegmentId = (SELECT SegmentID FROM Segments WHERE SegmentName = @SegmentName)
	END
	ELSE
		SET @id = @CodingElementID

	IF (ISNULL(@id, 0) < 1)
	BEGIN
		PRINT 'Cannot find task - exiting!'
		RETURN 1
	END

	 -- Show coding responses to Rave apps, with study, and http
	SELECT
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
			-- *** ObjectTypeR ***
			--2251	PartialCodingDecisionMessage
			--2252	OpenQueryMessage
			--2253	CancelQueryMessage
			--2254	CodingRejectionMessage
			--2255	FullCodingDecisionMessage
		LEFT JOIN CodingAssignment CA
			ON TQ.ObjectID = CA.CodingAssignmentID
			AND TQ.ObjectTypeID IN (2255, 2251)
			AND CA.CodingElementID = @id
		LEFT JOIN CodingRejections CR
			ON TQ.ObjectID = CR.CodingRejectionID
			AND TQ.ObjectTypeID = 2254
			AND CR.CodingElementID = @id
		LEFT JOIN CoderQueryHistory CQH
			ON TQ.ObjectID = CQH.QueryHistoryId
			AND TQ.ObjectTypeID IN (2252, 2253)
			AND CQH.QueryId IN (SELECT QueryId FROM CoderQueries CQI
								WHERE CQI.CodingElementId = @id)
		LEFT JOIN OutTransmissions OT 
			ON TQ.OutTransmissionID = OT.OutTransmissionID
	WHERE CA.CodingElementID IS NOT NULL
		OR CR.CodingElementID IS NOT NULL
		OR CQH.QueryId IS NOT NULL
	ORDER BY TQ.Created DESC
 
END
GO
