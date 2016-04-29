DECLARE @TransmissionItemsTobeUpdated TABLE (TransmissionQueueItemID BIGINT)

INSERT INTO @TransmissionItemsTobeUpdated
SELECT TransmissionQueueItemID 
FROM TransmissionQueueItems TQI
	JOIN TrackableObjects T ON T.ExternalObjectId = TQI.StudyOID
	WHERE TQI.SegmentID <> T.SegmentId 

DECLARE @errorString NVARCHAR(1000)

BEGIN TRY
	BEGIN TRANSACTION		
	-- Set segmentId from study (same logic in the code fix)
	UPDATE TQI
	SET	TQI.SegmentID = T.SegmentId
	FROM TransmissionQueueItems TQI
		JOIN @TransmissionItemsTobeUpdated TQIU ON TQIU.TransmissionQueueItemID = TQI.TransmissionQueueItemID
		CROSS APPLY
		(
			SELECT SegmentId 
			FROM TrackableObjects 
			WHERE TQI.StudyOID = ExternalObjectId
		) AS T
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	SET @errorString = N'ERROR Updating TransmissionQueueItems: ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH