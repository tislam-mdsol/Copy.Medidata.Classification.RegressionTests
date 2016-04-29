IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_PurgeUnsentQuery')
	DROP PROCEDURE CMP_PurgeUnsentQuery
GO

CREATE PROCEDURE dbo.CMP_PurgeUnsentQuery
(
	@codingElementId INT
)
AS
BEGIN
	DECLARE 
		@queryId INT,
		@queryHistoryId INT,
		@transmissionQueueId INT,
		@outTransmissionId INT

	SELECT 
		@queryId = CQ.QueryId,
		@queryHistoryId = CQH.QueryHistoryId,
		@transmissionQueueId = TQI.TransmissionQueueItemID,
		@outTransmissionId = TQI.OutTransmissionID
	FROM CodingElements CE
		CROSS APPLY
		(
			SELECT TOP 1 *
			FROM CoderQueries CQ
			WHERE CQ.CodingElementId = CE.CodingElementId
			ORDER BY CQ.QueryId DESC
		) AS CQ
		CROSS APPLY
		(
			SELECT TOP 1 *
			FROM CoderQueryHistory CQH
			WHERE CQH.QueryId = CQ.QueryId
			ORDER BY QueryHistoryId DESC
		) AS CQH
		JOIN TransmissionQueueItems TQI
			ON TQI.ObjectID = CQH.QueryHistoryId
			AND TQI.ObjectTypeID = 2252 -- open query
	WHERE CE.CodingElementId = @codingElementId
		AND CE.QueryStatus = 1 -- queued state
		-- created in Coder
		AND ISNULL(QueryUUID, '') <> ''
		-- not yet synced in Rave
		AND ISNUll(CancelURI, '') = ''
		

	IF (@queryId IS NULL)
	BEGIN
		SELECT 'Cannot find start query'
		RETURN 0
	END

	IF (@queryHistoryId IS NULL)
	BEGIN
		SELECT 'Cannot find waiting query History'
		RETURN 0
	END

	IF (@transmissionQueueId IS NULL)
	BEGIN
		SELECT 'Cannot find waiting query tranmission queue Id'
		RETURN 0
	END

	-- verify that only one history log exists per query
	IF (1 < (SELECT COUNT(*) FROM CoderQueryHistory
			WHERE QueryId = @queryId))
	BEGIN
		SELECT 'Multiple query histories exist for query - cannot purge!'
		RETURN 0
	END


	DECLARE @workflowTaskHistoryId BIGINT

	-- find last history for this query
	SELECT TOP 1 @workflowTaskHistoryId = WorkflowTaskHistoryID
	FROM WorkflowTaskHistory
	WHERE WorkflowTaskID = @codingElementId
		AND WorkflowSystemActionID = 7 -- open query
		AND QueryId = @queryId
	ORDER BY WorkflowTaskHistoryID DESC

	IF (@workflowTaskHistoryId IS NULL)
	BEGIN
		SELECT 'Cannot find waiting history Id'
		RETURN 0
	END

	BEGIN TRY
	BEGIN TRANSACTION

		-- remove from queue
		DELETE FROM OutTransmissionLogs
		WHERE TransmissionQueueItemId = @transmissionQueueId
		
		IF (@outTransmissionId IS NOT NULL)
		DELETE FROM OutTransmissions
			WHERE OutTransmissionID = @outTransmissionId

		DELETE FROM TransmissionQueueItems
		WHERE TransmissionQueueItemID = @transmissionQueueId

		-- remove query history
		DELETE FROM CoderQueryHistory
		WHERE QueryId = @queryId

		-- remove query
		DELETE FROM CoderQueries
		WHERE QueryId = @queryId

		-- update task
		UPDATE CodingElements
		SET QueryStatus = 0,
			CacheVersion = CacheVersion + 3
		WHERE CodingElementId = @codingElementId

		-- delete history
		DELETE FROM WorkflowTaskHistory
		WHERE WorkflowTaskHistoryID = @workflowTaskHistoryId

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(4000) = N'CMP ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH	

END


