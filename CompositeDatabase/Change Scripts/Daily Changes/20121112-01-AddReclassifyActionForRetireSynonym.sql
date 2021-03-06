-- Update workflow so that Reclassify WorkflowAction applies to 
-- Waiting Approval and Waiting Transmission states, not just Completed state.
-- This allows BOT to reclassify them after a synonym has been retired

DECLARE @segmentId INT
DECLARE @errorString NVARCHAR(500)
DECLARE @reclassifyActionName NVARCHAR(100) = 'Reclassify'

-- variables reset to NULL on each iteration (segment)
DECLARE @reclassifyActionId INT

---- create cursor over all segments    
DECLARE curSegment CURSOR FOR
	SELECT SegmentID FROM Segments

OPEN curSegment
FETCH curSegment INTO @segmentId
WHILE (@@FETCH_STATUS = 0) BEGIN

	BEGIN TRANSACTION
	BEGIN TRY

		-- Get DEFAULT workflow for segment
		DECLARE @workflowId INT
		SELECT @workflowId = WorkflowID FROM Workflows
		WHERE SegmentID = @segmentId 
			AND OID = 'DEFAULT'

		-- get reclassify action from workflow
		SET @reclassifyActionId = NULL
		SELECT @reclassifyActionId = WorkflowActionID FROM dbo.WorkflowActions 
		WHERE WorkflowID = @workflowId
			AND SegmentId = @segmentId 
			AND OID = @reclassifyActionName
		IF @reclassifyActionId IS NULL
		BEGIN
			SET @errorString = 'Reclassify WorkflowAction not found for segment'
 			RAISERROR(@errorString, 16, 1)
		END

		-- make Reclassify action valid on Waiting Approval state
		DECLARE @waitingApprovalStateId INT
		SELECT @waitingApprovalStateId = WorkflowStateID FROM dbo.WorkflowStates S
			JOIN LocalizedDataStrings L ON S.WorkflowStateNameID = L.StringID
		WHERE S.WorkflowID = @workflowId 
			AND S.SegmentId = @segmentId
			AND L.Locale = 'eng'
			AND L.String = 'Waiting Approval'		
		IF NOT EXISTS(SELECT NULL FROM dbo.WorkflowStateActions 
					  WHERE WorkflowID = @workflowId 
					  AND SegmentId = @segmentId 
					  AND StateID = @waitingApprovalStateId 
					  AND WorkflowActionID = @reclassifyActionId)
		BEGIN
			PRINT 'Creating WorkflowStateAction for WaitingApproval segment ' + CAST(@segmentId AS VARCHAR(10))
			INSERT INTO dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
			VALUES(@workflowId, @segmentId, @waitingApprovalStateId, @reclassifyActionId, 5)
		END

		-- make Reclassify action valid on Waiting Transmission state
		DECLARE @waitingTransmissionStateId INT
		SELECT @waitingTransmissionStateId = WorkflowStateID FROM dbo.WorkflowStates S
			JOIN LocalizedDataStrings L ON S.WorkflowStateNameID = L.StringID
		WHERE S.WorkflowID = @workflowId 
			AND S.SegmentId = @segmentId
			AND L.Locale = 'eng'
			AND L.String = 'Waiting Transmission'		
		IF NOT EXISTS(SELECT NULL FROM dbo.WorkflowStateActions 
					  WHERE WorkflowID = @workflowId 
					  AND SegmentId = @segmentId 
					  AND StateID = @waitingTransmissionStateId 
					  AND WorkflowActionID = @reclassifyActionId)
		BEGIN
			PRINT 'Creating WorkflowStateAction for WaitingTransmission segment ' + CAST(@segmentId AS VARCHAR(10))
			INSERT INTO dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
			VALUES(@workflowId, @segmentId, @waitingTransmissionStateId, @reclassifyActionId, 3)
		END

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH	

		ROLLBACK TRANSACTION
		
		DECLARE @ErrorLine NVARCHAR(500), @ErrorMessage NVARCHAR(500)
		SELECT @ErrorLine = ERROR_LINE(),
			@ErrorMessage = ERROR_MESSAGE()	
		SET @errorString = N'Segment ' + CAST(@segmentId AS NVARCHAR(10)) + ' Caught Exception, Exiting! **** '+cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage + ' ' + CONVERT(VARCHAR,GETUTCDATE(),21)
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)

		BREAK -- don't continue processing segments

	END CATCH

   FETCH curSegment INTO @segmentId
END -- while

CLOSE curSegment
DEALLOCATE curSegment
