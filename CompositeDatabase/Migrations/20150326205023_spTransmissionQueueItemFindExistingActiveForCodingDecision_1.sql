IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spTransmissionQueueItemFindExistingActiveForCodingDecision')
	DROP PROCEDURE dbo.spTransmissionQueueItemFindExistingActiveForCodingDecision
GO

CREATE PROCEDURE dbo.spTransmissionQueueItemFindExistingActiveForCodingDecision
(
	@sourceSystemId BIGINT, 
	@transmissionTypeId BIGINT, 
	@codingElementId BIGINT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	;WITH CA AS
	(
		SELECT *
		FROM CodingAssignment
		WHERE CodingElementID = @codingElementId
	)

	-- pick up the most recent one
	SELECT TOP 1 TQI.*
	FROM CA
		JOIN TransmissionQueueItems TQI
			ON TQI.ObjectID = CA.CodingAssignmentID
			AND (FailureCount = 0 OR ServiceWillContinueSending = 1)
			AND @sourceSystemId = SourceSystemID
			AND @transmissionTypeId = ObjectTypeID
			AND SuccessCount = 0
			AND IsForUnloadService = 0  -- not for polling service
	ORDER BY TransmissionQueueItemID DESC
		
END

GO

 