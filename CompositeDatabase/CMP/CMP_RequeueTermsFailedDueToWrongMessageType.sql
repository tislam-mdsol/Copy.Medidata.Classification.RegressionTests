/*
/ This CMP is to address MCC-117661
/ When new transmission queue items are created during the study migration for coding tasks with UUID(CodingContextURI), they were assigned 
/ as Full coding decision message type 2255 instead of correct partial coding decison message type 2251, making transmission to Rave failed.
*/
-- EXEC [dbo].[CMP_RequeueTermsFailedDueToWrongMessageType] 'Lundbecktrials'

IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE='p' and NAME = 'CMP_RequeueTermsFailedDueToWrongMessageType')
DROP PROCEDURE [dbo].[CMP_RequeueTermsFailedDueToWrongMessageType]
GO


CREATE PROCEDURE [dbo].[CMP_RequeueTermsFailedDueToWrongMessageType]
(
	@SegmentName NVARCHAR(255) =''
)
AS 
BEGIN

	DECLARE @SegmentId BIGINT

	SELECT  @SegmentId  = SegmentId
	FROM    Segments
	WHERE   SegmentName = @SegmentName
  
	DECLARE @errorString NVARCHAR(MAX)

	IF ( LEN(@SegmentName) > 0
		 AND ISNULL(@SegmentId , 0) < 1
		) 
		BEGIN
			SET @errorString = 'Cannot find Segment - exiting!'
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN
		END

	;WITH AffectedTerms AS (
		SELECT TQI.TransmissionQueueItemID
		FROM dbo.TransmissionQueueItems TQI
		JOIN dbo.CodingAssignment CA ON CA.CodingAssignmentID = TQI.ObjectID 
		JOIN dbo.CodingElements CE ON CE.CodingElementId = CA.CodingElementID AND CE.UUID <>'' and CE.CodingContextURI <>''
		WHERE TQI.ObjectTypeId = 2255 
		AND TQI.IsForUnloadService = 0
		--only for coding tasks with assignments since we are re-using old transmission queue items for transmission, we cannot use CA.Active=1 anymore
		AND CE.AssignedCodingPath <> ''
		AND TQI.SuccessCount = 0 
		AND TQI.FailureCount > 0 
		AND ServiceWillContinueSending=0
		-- and segment agnostic or for a single specific segment
		AND ( LEN(@SegmentName)    = 0
				OR CE.SegmentId    = @SegmentId
			)
	)

	UPDATE TQI
	SET TQI.CumulativeFailCount = TQI.CumulativeFailCount + TQI.FailureCount,
		TQI.FailureCount = 0,
		TQI.ServiceWillContinueSending = 1,
		TQI.ObjectTypeID=2251
	FROM AffectedTerms A
	JOIN TransmissionQueueItems TQI ON TQI.TransmissionQueueItemID =A.TransmissionQueueItemID


END
GO