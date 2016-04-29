--/* ------------------------------------------------------------------------------------------------------
--// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
--//
--// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
--// this file may not be disclosed to third parties, copied or duplicated in 
--// any form, in whole or in part, without the prior written permission of
--// Medidata Solutions Worldwide.
--//
--// Author: Altin Vardhami avardhami@mdsol.com
--// ------------------------------------------------------------------------------------------------------*/

--IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSetupCancelQueryWorkflowAction')
--	DROP PROCEDURE dbo.spSetupCancelQueryWorkflowAction
--GO

--CREATE PROCEDURE dbo.spSetupCancelQueryWorkflowAction
--	@workflowId INT,
--	@segmentId INT,
--	@applicationId INT,
--	@locale CHAR(3)
--AS
--BEGIN

--	BEGIN TRANSACTION
--	BEGIN TRY

--		-- 1. Action
--		DECLARE @workflowActionName13 NVARCHAR(100), @workflowActionNameId13 INT, @workflowActionId13 INT
--		SET @workflowActionName13 = 'Cancel Query'      -- On WaitingManualCode, WaitingApproval

--		EXEC dbo.spLclztnFndOrInsrtDtStrng @workflowActionName13, @locale, @workflowActionNameId13 OUTPUT, @segmentId

--		INSERT INTO dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed, ReasonRequiredType)
--		VALUES(@workflowActionNameId13, @workflowActionName13, @workflowId, @segmentId, 9, 0, 1, 0)

--		SET @workflowActionId13 = scope_identity()

--		-- 2. State Action(s)

--		-- Waiting Manual Code
--		DECLARE @waitingManualId INT
	
--		SELECT @waitingManualId = WorkflowStateID
--		FROM WorkflowStates
--		WHERE WorkflowID = @workflowId
--			AND dbo.fnLocalDataString(WorkflowStatenameId, 'eng', segmentId) = 'Waiting Manual Code'

--		INSERT INTO dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--		VALUES(@workflowId, @segmentId, @waitingManualId, @workflowActionId13, 4)
       
--		-- WaitingApproval
--		DECLARE @waitingApprovalId INT
	
--		SELECT @waitingApprovalId = WorkflowStateID
--		FROM WorkflowStates
--		WHERE WorkflowID = @workflowId
--			AND dbo.fnLocalDataString(WorkflowStatenameId, 'eng', segmentId) = 'Waiting Approval'

--		INSERT INTO dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--		VALUES(@workflowId, @segmentId, @waitingApprovalId, @workflowActionId13, 5)


--		-- 3. Action List(s)
--		DECLARE @actionListId13 INT

--		INSERT INTO dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--		VALUES(@segmentId, @workflowActionId13, '')

--		SET @actionListId13 = SCOPE_IDENTITY()

--		-- 4. Action Item(s)
--		DECLARE @systemActionId INT

--		SELECT @systemActionId = WorkflowSystemActionID
--		FROM dbo.WorkflowSystemActionR 
--		WHERE ActionName = 'CancelQuery' 
--			AND ApplicationID = @applicationId

--		INSERT INTO dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--		VALUES(@segmentId, @actionListId13, @systemActionId, 1, @waitingManualId, 5)

--		COMMIT TRANSACTION
--	END TRY

--	BEGIN CATCH
		
--	ROLLBACK TRANSACTION

--		DECLARE	@ErrorSeverity INT, 
--			@ErrorState INT,
--			@ErrorLine INT,
--			@ErrorMessage NVARCHAR(4000),
--			@ErrorProc NVARCHAR(4000)

--		SELECT @ErrorSeverity = ERROR_SEVERITY(),
--			@ErrorState = ERROR_STATE(),
--			@ErrorLine = ERROR_LINE(),
--			@ErrorMessage = ERROR_MESSAGE(),
--			@ErrorProc = ERROR_PROCEDURE()
--		SELECT @ErrorMessage = coalesce(@ErrorProc, 'spSetupCancelQueryWorkflowAction.sql') + ' (' + cast(@ErrorLine AS NVARCHAR) + '): ' + @ErrorMessage
		
--		RAISERROR (@ErrorMessage,  @ErrorSeverity, @ErrorState);
--		-- upon SQL - 2012 change to 
--		--THROW 60001, @ErrorMessage, @ErrorState;
	
--	END CATCH

--END