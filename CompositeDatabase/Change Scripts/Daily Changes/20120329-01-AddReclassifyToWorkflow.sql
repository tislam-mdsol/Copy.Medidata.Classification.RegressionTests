
-- Perform this update for Segment MedidataReserved1 (SegID=1, WfID=1),
-- which allows future segments to have Reclassify in workflow (via spWorkflowCopy)
-- Also need to perform this for all other existing segments.

DECLARE @segmentId INT
DECLARE @applicationId INT = 1
DECLARE @errorString NVARCHAR(500)
DECLARE @reclassifyActionName nvarchar(100) = 'Reclassify' -- On Completed
	
-- Create global system action
IF not exists(SELECT null FROM dbo.WorkflowSystemActionR WHERE ActionName=N'Reclassify') 
BEGIN
	PRINT 'Creating SystemAction'
	INSERT INTO dbo.WorkflowSystemActionR (ApplicationID, ActionName, Active) 
	VALUES(@applicationId, N'Reclassify', 1)
END

-- variables reset to NULL on each iteration (segment)
DECLARE @reclassifyActionId int
DECLARE @reclassifyActionListId int
DECLARE @stringId INT

-- create cursor over all segments    
DECLARE curSegment CURSOR FOR
	SELECT SegmentID FROM Segments

OPEN curSegment
FETCH curSegment INTO @segmentId
WHILE (@@FETCH_STATUS = 0) BEGIN

	BEGIN TRANSACTION
	BEGIN TRY

		-- Get DEFAULT workflow for segment
		DECLARE @workflowId int
		SELECT @workflowId = WorkflowID FROM Workflows
		WHERE SegmentID = @segmentId AND OID = 'DEFAULT'

		-- Add action to workflow
		SET @reclassifyActionId = NULL
		SELECT @reclassifyActionId = WorkflowActionID FROM dbo.WorkflowActions WHERE WorkflowID = @workflowId
			AND SegmentId = @segmentId AND OID = @reclassifyActionName
		IF @reclassifyActionId IS NULL
		BEGIN
			PRINT 'Creating WorkflowAction for segment ' + CAST(@segmentId AS VARCHAR(10))
			DECLARE @reclassifyActionNameId int
			-- insert eng string first
			EXEC dbo.spLclztnFndOrInsrtDtStrng @reclassifyActionName, 'eng', @reclassifyActionNameId output, @segmentId
			INSERT INTO dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
			VALUES (@reclassifyActionNameId, @reclassifyActionName, @workflowId, @segmentId, 8, 0, 0)
			SET @reclassifyActionId = scope_identity()
		END

		-- Make Reclassify action valid on Completed state
		DECLARE @completedStateId int
		SELECT @completedStateId = WorkflowStateID FROM dbo.WorkflowStates
		WHERE WorkflowID = @workflowId AND SegmentId = @segmentId
			AND IsTerminalState = 1 -- Completed is the only terminal state
		IF not exists(SELECT null FROM dbo.WorkflowStateActions WHERE WorkflowID = @workflowId AND SegmentId = @segmentId AND StateID = @completedStateId AND WorkflowActionID = @reclassifyActionId)
		BEGIN
			PRINT 'Creating WorkflowStateAction for segment ' + CAST(@segmentId AS VARCHAR(10))
			INSERT INTO dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
			VALUES(@workflowId, @segmentId, @completedStateId, @reclassifyActionId, 1)
		END

		-- Add Reclassify action with no condition
		SET @reclassifyActionListId = NULL
		SELECT @reclassifyActionListId = WorkflowActionListID FROM dbo.WorkflowActionList
			WHERE SegmentId = @segmentId AND WorkflowActionID = @reclassifyActionId
		IF @reclassifyActionListId IS NULL
		BEGIN
			PRINT 'Creating WorkflowActionList for segment ' + CAST(@segmentId AS VARCHAR(10))
			INSERT INTO dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
			VALUES(@segmentId, @reclassifyActionId, '')
			SET @reclassifyActionListId=SCOPE_IDENTITY()
		END

		-- Add Reclassify system action to workflow action,
		-- and set target state to Reconsider (note: can be WaitingManualCode when isBypassReconsider)
		DECLARE @systemActionId int, @reconsiderStateId int
		SELECT @systemActionId = WorkflowSystemActionID FROM dbo.WorkflowSystemActionR 
			WHERE ActionName=N'Reclassify' AND ApplicationID = @applicationId
		SELECT @reconsiderStateId = WorkflowStateID FROM dbo.WorkflowStates
			WHERE WorkflowID = @workflowId AND SegmentId = @segmentId AND IsReconsiderState = 1 
		IF not exists(SELECT null FROM dbo.WorkflowActionItems WHERE SegmentId = @segmentId AND WorkflowActionListID = @reclassifyActionListId)
		BEGIN
			PRINT 'Creating WorkflowActionItem for segment ' + CAST(@segmentId AS VARCHAR(10))
			INSERT INTO dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
			VALUES(@segmentId, @reclassifyActionListId, @systemActionId, 1, @reconsiderStateId, 1)
		END

		-- Create translations for Workflow Action
		SET @stringId = NULL
		SELECT @stringId = StringId FROM LocalizedDataStrings 
			WHERE String = @reclassifyActionName and Locale = 'eng' and SegmentId = @segmentId
		IF @stringId IS NOT NULL
		BEGIN
			IF EXISTS (SELECT NULL FROM Localizations WHERE Locale = 'loc') 
			BEGIN
				EXEC dbo.spLclztnFndOrInsrtDtStrng N'LReclassify', 'loc', null, @segmentId
			END	
			IF EXISTS (SELECT NULL FROM Localizations WHERE Locale = 'jpn')
			BEGIN
				EXEC dbo.spLclztnFndOrInsrtDtStrng N'再分類', 'jpn', null, @segmentId
			END	
		END

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH	

		ROLLBACK TRANSACTION
		
		DECLARE @ErrorLine NVARCHAR(500), @ErrorMessage NVARCHAR(500)
		SELECT @ErrorLine = ERROR_LINE(),
			@ErrorMessage = ERROR_MESSAGE()	
		SET @errorString = N'Segment ' + CAST(@segmentId AS NVARCHAR(10)) + ' Caught Exception, Exiting! **** '+cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage + CONVERT(VARCHAR,GETUTCDATE(),21)
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)

		BREAK -- don't continue processing segments

	END CATCH

   FETCH curSegment INTO @segmentId
END -- while

CLOSE curSegment
DEALLOCATE curSegment
