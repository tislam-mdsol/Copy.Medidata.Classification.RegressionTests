--/* ------------------------------------------------------------------------------------------------------
--// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
--//
--// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
--// this file may not be disclosed to third parties, copied or duplicated in 
--// any form, in whole or in part, without the prior written permission of
--// Medidata Solutions Worldwide.
--//
--// Author: Jalal Uddin juddin@mdsol.com
--//
--// Note: 
--//	1.	This stored procedure will create a default workflow along with necessary workflowStates, 
--//		workflowActions, workflowActionList, WorkflowActionItems and WorkflowActionItemData
--//  2.	This procedure will NOT create the ObjectSegments assignment for workflows.
--//	3.	Use example [Create default workflow]: 
--//			exec spCodingElementsCleanup								-- to cleanup all existing coding elements
--//			exec spWorkflowsCleanup										-- cleanup all workflow definitions
--//			exec spCreateDefaultWorkflowWithReconsiderState 1, 'Default', 'eng'			-- create default workflow
--//
--// ------------------------------------------------------------------------------------------------------*/

--IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateDefaultWorkflowWithReconsiderState')
--	DROP PROCEDURE dbo.spCreateDefaultWorkflowWithReconsiderState
--GO

--create procedure dbo.spCreateDefaultWorkflowWithReconsiderState
--	@segmentId int,
--	@WorkflowOID varchar(50),
--	@locale char(3),
--	@WorkflowId int output
--as
--begin

--	declare 
--		@contextId int, 
--		@workflowNameStringId int, 
--		@segmentOid varchar(50), 
--		@isActive bit, 
--		@varIsAutoCodeId int, 
--		@varIsReviewRequired int, 
--		@varIsApprovalRequired int, 
--		@varIsResetRequired int,
--		@varIsAutoApproval int,
--		@varIsAutoApprovalExecutedAlready int,
--		@varIsByPassTransmit int,
--		@applicationName nvarchar(200), 
--		@applicationId int
    
--	set @contextId = 1 -- system
--	set @isActive = 1
--	set @applicationName = N'MedidataCoder'
	
--	exec dbo.spLclztnFndOrInsrtDtStrng @WorkflowOID, @locale, @workflowNameStringId output, @segmentId

--	-- check if workflow already exist int the segment - return
--	select @WorkflowId = w.WorkflowId 
--		from Workflows w
--		inner join Segments s on w.SegmentID = s.SegmentID 
--		where s.SegmentID = @segmentId and w.WorkflowNameID = @workflowNameStringId
	
--	if (@WorkflowId is not null) begin
--		select @segmentOid = OID from Segments where SegmentID = @segmentId
--		print N'Workflow: [' + @WorkflowOID + N'] already exist for Segment: [' + @segmentOid + N'] in the system.'
--		return 0
--	end	

--	SET XACT_ABORT ON
	
--	begin transaction
--	begin try
--		--1. Find or create application
--		if exists(select null from dbo.ApplicationR where ApplicationName=@applicationName) begin
--			select @applicationId = ApplicationID from dbo.ApplicationR where ApplicationName=@applicationName
--		end
--		else begin
--			insert into dbo.ApplicationR(ApplicationName) values(@applicationName)
--			set @applicationId = scope_identity()
--		end
		
--		--3. Create Workflows
--		insert into dbo.Workflows(WorkflowNameID, OID, SegmentID, Active) values(@workflowNameStringId, @WorkflowOID, @segmentId, @isActive)
--		set @WorkflowId = scope_identity()
--		PRINT N'WorkflowId: ' + CAST(@WorkflowId AS NVARCHAR) + N' Created.'
	
	
--		--4. Create WorkflowReasons [Assignable to workflow actions]
--		/*
--			Ambiguous verbatim term
--			Matching term not found for this verbatim term
--			Too many matches found for this verbatim term
--			Following standard coding practice
--			Coding algorithm is not specified
--		*/
--		declare @workflowReason1 nvarchar(200), @workflowReasonNameId1 int, @workflowReasonId1 int
--		set @workflowReason1 = 'Ambiguous verbatim term'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowReason1, @locale, @workflowReasonNameId1 output, @segmentId
--		Insert into dbo.WorkflowReasons(SegmentId, WorkflowID, ReasonNameId) values(@segmentId, @workflowId, @workflowReasonNameId1)
--		set @workflowReasonId1 = scope_identity()
		
--		declare @workflowReason2 nvarchar(200), @workflowReasonNameId2 int, @workflowReasonId2 int
--		set @workflowReason2 = 'Matching term not found for this verbatim term'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowReason2, @locale, @workflowReasonNameId2 output, @segmentId
--		Insert into dbo.WorkflowReasons(SegmentId, WorkflowID, ReasonNameId) values(@segmentId, @workflowId, @workflowReasonNameId2)
--		set @workflowReasonId2 = scope_identity()
		
--		declare @workflowReason3 nvarchar(200), @workflowReasonNameId3 int, @workflowReasonId3 int
--		set @workflowReason3 = 'Too many matches found for this verbatim term'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowReason3, @locale, @workflowReasonNameId3 output, @segmentId
--		Insert into dbo.WorkflowReasons(SegmentId, WorkflowID, ReasonNameId) values(@segmentId, @workflowId, @workflowReasonNameId3)
--		set @workflowReasonId3 = scope_identity()
		
--		declare @workflowReason4 nvarchar(200), @workflowReasonNameId4 int, @workflowReasonId4 int
--		set @workflowReason4 = 'Following standard coding practice'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowReason4, @locale, @workflowReasonNameId4 output, @segmentId
--		Insert into dbo.WorkflowReasons(SegmentId, WorkflowID, ReasonNameId) values(@segmentId, @workflowId, @workflowReasonNameId4)
--		set @workflowReasonId4 = scope_identity()
		
--		declare @workflowReason5 nvarchar(200), @workflowReasonNameId5 int, @workflowReasonId5 int
--		set @workflowReason5 = 'Coding algorithm is not specified'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowReason5, @locale, @workflowReasonNameId5 output, @segmentId
--		Insert into dbo.WorkflowReasons(SegmentId, WorkflowID, ReasonNameId) values(@segmentId, @workflowId, @workflowReasonNameId5)
--		set @workflowReasonId5 = scope_identity()

		
--		--5. Create WorkflowVariables
--		insert into dbo.WorkflowVariables(VariableName, DataFormat, WorkflowID, DefaultValue, SegmentId)
--			values('IsAutoCode', 'Boolean', @workflowId, 'True', @segmentId) -- default autocode
--		set @varIsAutoCodeId = scope_identity()
			
--		insert into dbo.WorkflowVariables(VariableName, DataFormat, WorkflowID, DefaultValue, SegmentId)
--			values('IsReviewRequired', 'Boolean', @workflowId, 'False', @segmentId) -- default not required
--		set @varIsReviewRequired = scope_identity()
		
--		insert into dbo.WorkflowVariables(VariableName, DataFormat, WorkflowID, DefaultValue, SegmentId)
--			values('IsApprovalRequired', 'Boolean', @workflowId, 'True', @segmentId)-- default not required
--		set @varIsApprovalRequired = scope_identity()
	
--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		insert into dbo.WorkflowVariables(VariableName, DataFormat, WorkflowID, DefaultValue, SegmentId)
--			values('IsResetRequired', 'Boolean', @workflowId, 'False', @segmentId)-- default not required
--		set @varIsResetRequired = scope_identity()
	
--		-- for bypassing approval upon coding to coding rule(synonym)
--		insert into dbo.WorkflowVariables(VariableName, DataFormat, WorkflowID, DefaultValue, SegmentId)
--			values('IsAutoApproval', 'Boolean', @workflowId, 'True', @segmentId)-- default not required
--		set @varIsAutoApproval = scope_identity()
		
--		-- internal support for bypass approval (to avoid recursion on the same action/state)
--		insert into dbo.WorkflowVariables(VariableName, DataFormat, WorkflowID, DefaultValue, SegmentId)
--			values('IsAutoApproveExecutedAlready', 'Boolean', @workflowId, 'False', @segmentId)-- default not required
--		set @varIsAutoApprovalExecutedAlready = scope_identity()
		
--		-- for bypassing transmit
--		insert into dbo.WorkflowVariables(VariableName, DataFormat, WorkflowID, DefaultValue, SegmentId)
--			values('IsBypassTransmit', 'Boolean', @workflowId, 'False', @segmentId)-- default value is false
--		set @varIsByPassTransmit = scope_identity()
		
--		--6. Create WorkflowVariableLookupValues
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsAutoCodeId, 'True', @segmentId)
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsAutoCodeId, 'False', @segmentId)
		
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsReviewRequired, 'True', @segmentId)
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsReviewRequired, 'False', @segmentId)

--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsApprovalRequired, 'True', @segmentId)
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsApprovalRequired, 'False', @segmentId)

--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsResetRequired, 'True', @segmentId)
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsResetRequired, 'False', @segmentId)
		
--		-- for AutoApproval
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsAutoApproval, 'True', @segmentId)
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsAutoApproval, 'False', @segmentId)

--		-- for bypassApproval support
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsAutoApprovalExecutedAlready, 'True', @segmentId)
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsAutoApprovalExecutedAlready, 'False', @segmentId)

--		-- for bypassTransmit
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsByPassTransmit, 'True', @segmentId)
--		insert into dbo.WorkflowVariableLookupValues(WorkflowVariableID, Value, SegmentId) values(@varIsByPassTransmit, 'False', @segmentId)

--		--7. Create WorkflowStateIcons: Image is null
--		declare @workflowStateName1 nvarchar(100), @workflowStateNameId1 int, @workflowStateId1 int
--		set @workflowStateName1 = 'Start'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowStateName1, @locale, @workflowStateNameId1 output, @segmentId
		
--		declare @workflowStateName2 nvarchar(100), @workflowStateNameId2 int, @workflowStateId2 int
--		set @workflowStateName2 = 'Waiting Manual Code'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowStateName2, @locale, @workflowStateNameId2 output, @segmentId
		
--		declare @workflowStateName3 nvarchar(100), @workflowStateNameId3 int, @workflowStateId3 int
--		set @workflowStateName3 = 'Waiting Approval'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowStateName3, @locale, @workflowStateNameId3 output, @segmentId

--		declare @workflowStateName4 nvarchar(100), @workflowStateNameId4 int, @workflowStateId4 int
--		set @workflowStateName4 = 'Waiting Transmission'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowStateName4, @locale, @workflowStateNameId4 output, @segmentId

--		declare @workflowStateName5 nvarchar(100), @workflowStateNameId5 int, @workflowStateId5 int
--		set @workflowStateName5 = 'Completed'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowStateName5, @locale, @workflowStateNameId5 output, @segmentId

--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		declare @workflowStateName6 nvarchar(100), @workflowStateNameId6 int, @workflowStateId6 int
--		set @workflowStateName6 = 'Reconsider'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowStateName6, @locale, @workflowStateNameId6 output, @segmentId


--		-- WorkflowStateIcons
--		declare @workflowIconId1 int, @workflowIconId2 int, @workflowIconId3 int, @workflowIconId4 int, @workflowIconId5 int, @workflowIconId6 int
--		insert into dbo.WorkflowStateIcons(SegmentID, WorkflowStateIconNameID, Active) values(@segmentId, @workflowStateNameId1, @isActive)
--		set @workflowIconId1 = scope_identity()
--		insert into dbo.WorkflowStateIcons(SegmentID, WorkflowStateIconNameID, Active) values(@segmentId, @workflowStateNameId2, @isActive)
--		set @workflowIconId2 = scope_identity()
--		insert into dbo.WorkflowStateIcons(SegmentID, WorkflowStateIconNameID, Active) values(@segmentId, @workflowStateNameId3, @isActive)
--		set @workflowIconId3 = scope_identity()
--		insert into dbo.WorkflowStateIcons(SegmentID, WorkflowStateIconNameID, Active) values(@segmentId, @workflowStateNameId4, @isActive)
--		set @workflowIconId4 = scope_identity()
--		insert into dbo.WorkflowStateIcons(SegmentID, WorkflowStateIconNameID, Active) values(@segmentId, @workflowStateNameId5, @isActive)
--		set @workflowIconId5 = scope_identity()
		
--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		insert into dbo.WorkflowStateIcons(SegmentID, WorkflowStateIconNameID, Active) values(@segmentId, @workflowStateNameId6, @isActive)
--		set @workflowIconId6 = scope_identity()

--		--8. Create WorkflowStates: Icon Image not set
--		insert into dbo.WorkflowStates(WorkflowStateNameID, WorkflowID, WorkflowStateIconID, IsStartState, IsTerminalState, SegmentId)
--			values(@workflowStateNameId1, @workflowId, @workflowIconId1, 1, 0, @segmentId)
--		set @workflowStateId1 = scope_identity()
		
--		insert into dbo.WorkflowStates(WorkflowStateNameID, WorkflowID, WorkflowStateIconID, IsStartState, IsTerminalState, SegmentId)
--			values(@workflowStateNameId2, @workflowId, @workflowIconId2, 0, 0, @segmentId)
--		set @workflowStateId2 = scope_identity()
		
--		insert into dbo.WorkflowStates(WorkflowStateNameID, WorkflowID, WorkflowStateIconID, IsStartState, IsTerminalState, SegmentId)
--			values(@workflowStateNameId3, @workflowId, @workflowIconId3, 0, 0, @segmentId)
--		set @workflowStateId3 = scope_identity()
		
--		insert into dbo.WorkflowStates(WorkflowStateNameID, WorkflowID, WorkflowStateIconID, IsStartState, IsTerminalState, SegmentId)
--			values(@workflowStateNameId4, @workflowId, @workflowIconId4, 0, 0, @segmentId)
--		set @workflowStateId4 = scope_identity()
		
--		insert into dbo.WorkflowStates(WorkflowStateNameID, WorkflowID, WorkflowStateIconID, IsStartState, IsTerminalState, SegmentId)
--			values(@workflowStateNameId5, @workflowId, @workflowIconId5, 0, 1, @segmentId)
--		set @workflowStateId5 = scope_identity()
		
--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		insert into dbo.WorkflowStates(WorkflowStateNameID, WorkflowID, WorkflowStateIconID, IsStartState, IsTerminalState, SegmentId, IsReconsiderState)
--			values(@workflowStateNameId6, @workflowId, @workflowIconId6, 0, 0, @segmentId, 1)
--		set @workflowStateId6 = scope_identity()
		
		
--		/*----------------------------------------------------------------------------------------------------------------
--		-- Create Transition State from Transmit: applicable to Aynchronous states - NO actions
--		declare @workflowStateName6 nvarchar(100), @workflowStateNameId6 int, @workflowStateId6 int
--		set @workflowStateName6 = 'Transmitting'
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowStateName6, @locale, @segmentId, @workflowStateNameId6 output
		
--		insert into dbo.WorkflowStates(WorkflowStateNameID, WorkflowID, WorkflowStateIconID, IsStartState, IsTerminalState, SegmentId)
--			values(@workflowStateNameId6, @workflowId, @workflowIconId6, 0, 0, @segmentId)
--		set @workflowStateId6 = scope_identity()
--		*/----------------------------------------------------------------------------------------------------------------
		
--		--9. Create WorkflowActions
--		/*
--             * Coding Actions: StartAutoCode, Code, Reject, RetryAutoCode, Approve, Transmit
--             * On Start: StartAutoCode
--             * On WaitingManualCode: Code, Reject, RetryAutoCode
--             * On WaitingApproval: Approve, Comment
--             * On WaitingTransmission: Transmit
--             * On Completed: 
--        */
--		declare @workflowActionName1 nvarchar(100), @workflowActionNameId1 int, @workflowActionId1 int
--		set @workflowActionName1 = 'Start Auto Code'	-- OnStart
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName1, @locale, @workflowActionNameId1 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId1, @workflowActionName1, @workflowId, @segmentId, 2, 1, 0)
--		set @workflowActionId1 = scope_identity()
		
--		declare @workflowActionName2 nvarchar(100), @workflowActionNameId2 int, @workflowActionId2 int
--		set @workflowActionName2 = 'Code'			-- On WaitingManualCode
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName2, @locale, @workflowActionNameId2 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId2, @workflowActionName2, @workflowId, @segmentId, 3, 0, 1) 
--		set @workflowActionId2 = scope_identity()
		
--		declare @workflowActionName3 nvarchar(100), @workflowActionNameId3 int, @workflowActionId3 int
--		set @workflowActionName3 = 'Open Query'			-- On WaitingManualCode, WaitingApproval
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName3, @locale, @workflowActionNameId3 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed, ReasonRequiredType)
--			values(@workflowActionNameId3, @workflowActionName3, @workflowId, @segmentId, 4, 0, 1, 1) -- reason mandatory
--		set @workflowActionId3 = scope_identity()
		
--		declare @workflowActionName4 nvarchar(100), @workflowActionNameId4 int, @workflowActionId4 int
--		set @workflowActionName4 = 'Retry Auto Code'			-- On WaitingManualCode if autocode requested
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName4, @locale, @workflowActionNameId4 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId4, @workflowActionName4, @workflowId, @segmentId, 5, 1, 0)
--		set @workflowActionId4 = scope_identity()
		
--		declare @workflowActionName5 nvarchar(100), @workflowActionNameId5 int, @workflowActionId5 int
--		set @workflowActionName5 = 'Recode'			-- On WaitingApproval
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName5, @locale, @workflowActionNameId5 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed, ReasonRequiredType)
--			values(@workflowActionNameId5, @workflowActionName5, @workflowId, @segmentId, 6, 0, 1, 1) -- reason mandatory
--		set @workflowActionId5 = scope_identity()
		
--		declare @workflowActionName6 nvarchar(100), @workflowActionNameId6 int, @workflowActionId6 int
--		set @workflowActionName6 = 'Approve'			-- On WaitingApproval
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName6, @locale, @workflowActionNameId6 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId6, @workflowActionName6, @workflowId, @segmentId, 7, 0, 1)
--		set @workflowActionId6 = scope_identity()
		
--		declare @workflowActionName60 nvarchar(100), @workflowActionNameId60 int, @workflowActionId60 int
--		set @workflowActionName60 = 'AutoApproveInternal'			-- On WaitingApproval
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName60, @locale, @workflowActionNameId60 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId60, @workflowActionName60, @workflowId, @segmentId, 6, 1, 0)
--		set @workflowActionId60 = scope_identity()


--		declare @workflowActionName7 nvarchar(100), @workflowActionNameId7 int, @workflowActionId7 int
--		set @workflowActionName7 = 'Transmit'			-- On WaitingApproval
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName7, @locale, @workflowActionNameId7 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId7, @workflowActionName7, @workflowId, @segmentId, 8, 1, 0)
--		set @workflowActionId7 = scope_identity()

--		declare @workflowActionName70 nvarchar(100), @workflowActionNameId70 int, @workflowActionId70 int
--		set @workflowActionName70 = 'CompleteWithoutTransmission'	-- On WaitingTransmit
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName70, @locale, @workflowActionNameId70 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId70, @workflowActionName70, @workflowId, @segmentId, 7, 1, 0) -- Set Ordinal value to 7?
--		set @workflowActionId70 = scope_identity()
		
--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		-- reset this with the highest ordinal priority (lowest ordinal)
--		-- always automatic
--		declare @workflowActionName8 nvarchar(100), @workflowActionNameId8 int, @workflowActionId8 int
--		set @workflowActionName8 = 'Reconsider'			-- On ReClassify
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName8, @locale, @workflowActionNameId8 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId8, @workflowActionName8, @workflowId, @segmentId, 1, 1, 1)
--		set @workflowActionId8 = scope_identity()
		
--		-- for reclassifying past and/or current coding decisions while already in reconsider state
--		-- always manual
--		-- a) Leave as it is
--		declare @workflowActionName9 nvarchar(100), @workflowActionNameId9 int, @workflowActionId9 int
--		set @workflowActionName9 = 'Leave As Is'			-- On Leave past coding decision alone
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName9, @locale, @workflowActionNameId9 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId9, @workflowActionName9, @workflowId, @segmentId, 1, 0, 1)
--		set @workflowActionId9 = scope_identity()
		
--		-- b) Reject Past Coding decisions (reclassify...)
--		declare @workflowActionName10 nvarchar(100), @workflowActionNameId10 int, @workflowActionId10 int
--		set @workflowActionName10 = 'Reject Coding Decision'			-- On Leave past coding decision alone
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName10, @locale, @workflowActionNameId10 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed)
--			values(@workflowActionNameId10, @workflowActionName10, @workflowId, @segmentId, 1, 0, 1)
--		set @workflowActionId10 = scope_identity()

--		-- Comment Action
--		declare @workflowActionName12 nvarchar(100), @workflowActionNameId12 int, @workflowActionId12 int
--		set @workflowActionName12 = 'Add Comment'			-- On WaitingApproval
--		exec dbo.spLclztnFndOrInsrtDtStrng @workflowActionName12, @locale, @workflowActionNameId12 output, @segmentId
--		insert into dbo.WorkflowActions(NameID, OID, WorkflowID, SegmentId, Ordinal, IsAutoAllowed, IsManualAllowed, ReasonRequiredType)
--			values(@workflowActionNameId12, @workflowActionName12, @workflowId, @segmentId, 7, 0, 1, 1) -- reason mandatory
--		set @workflowActionId12 = scope_identity()

--		--10. Create WorkflowStateAction
--		--10a. On Start: StartAutoCode
--			-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--			-- reset this with the highest ordinal priority (lowest ordinal)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId1, @workflowActionId8, 1)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId1, @workflowActionId1, 2)
			
--		--10b. On WaitingManualCode:  Code, RetryAutoCode, Reject
--			-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--			-- reset this with the highest ordinal priority (lowest ordinal)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId2, @workflowActionId8, 1)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId2, @workflowActionId2, 2)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId2, @workflowActionId4, 3)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId2, @workflowActionId3, 3)
			
--		--10c. WaitingApproval: Approve, Recode, Reject, Comment
--			-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--			-- reset this with the highest ordinal priority (lowest ordinal)

--			-- added new action (automatic on approval) that takes directly to transmit if successful,
--			-- or leaves in waitingapproval if not
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId3, @workflowActionId60, 1)


--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId3, @workflowActionId8, 1)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId3, @workflowActionId6, 2)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId3, @workflowActionId5, 3)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId3, @workflowActionId3, 4)
				
--			-- Comment
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId3, @workflowActionId12, 4)
			
		
--		--10d. On WaitingTransmission: Transmit

--			-- added new action (automatic on transmission) that takes directly to completed if successful,
--			-- or leaves in waitingtransmit if not
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId4, @workflowActionId70, 1)

--			-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--			-- reset this with the highest ordinal priority (lowest ordinal)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId4, @workflowActionId8, 1)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId4, @workflowActionId7, 2)

--		--10e. On Completed: check for reclassify
--			-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--			-- reset this with the highest ordinal priority (lowest ordinal)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId5, @workflowActionId8, 1)


--		--10f. On Reconsider: Leave coding decision as it is, or reject it (send it to GO-state)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId6, @workflowActionId9, 1)
--			insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--				values(@workflowId, @segmentId, @workflowStateId6, @workflowActionId10, 2)

--		/*------------------------------------------------------------------------------------------------------------
--		-- On Transmitting: Cancel
--		insert into dbo.WorkflowStateActions(WorkflowID, SegmentId, StateID, WorkflowActionID, Ordinal)
--			values(@workflowId, @segmentId, @workflowStateId6, @workflowActionId8, 1)
--		*/------------------------------------------------------------------------------------------------------------
		
--		--11. Create WorkflowActionReasons
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId2, @workflowReasonId1)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId2, @workflowReasonId2)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId2, @workflowReasonId3)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId2, @workflowReasonId4)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId2, @workflowReasonId5)
		
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId3, @workflowReasonId1)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId3, @workflowReasonId2)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId3, @workflowReasonId3)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId3, @workflowReasonId4)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId3, @workflowReasonId5)

--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId4, @workflowReasonId1)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId4, @workflowReasonId2)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId4, @workflowReasonId3)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId4, @workflowReasonId4)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId4, @workflowReasonId5)

--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId5, @workflowReasonId1)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId5, @workflowReasonId2)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId5, @workflowReasonId3)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId5, @workflowReasonId4)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId5, @workflowReasonId5)

--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId6, @workflowReasonId1)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId6, @workflowReasonId2)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId6, @workflowReasonId3)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId6, @workflowReasonId4)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId6, @workflowReasonId5)

--		-- Reason for Comment action
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId12, @workflowReasonId1)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId12, @workflowReasonId2)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId12, @workflowReasonId3)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId12, @workflowReasonId4)
--		insert into dbo.WorkflowActionReasons(SegmentId, WorkflowActionId, WorkflowReasonId) values(@segmentId, @workflowActionId12, @workflowReasonId5)

--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		-- reset this with the highest ordinal priority (lowest ordinal)
--		-- NO REASONS SHOULD BE NEEDED AT THIS POINT

--		--12. Create WorkflowActionList
--		/*
--             * Coding Actions: StartAutoCode, Code, Reject, RetryAutoCode, Approve, Transmit, CompleteWithoutTransmission
--             * On Start: StartAutoCode
--             * On WaitingManualCode: Code, Reject, RetryAutoCode
--             * On WaitingApproval: Approve
--             * On WaitingTransmission: Transmit, CompleteWithoutTransmission
--             * On Completed: no action
--        */ 

--		--12 On Reclassify
--		-- for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--		-- reset this with the highest ordinal priority (lowest ordinal)
--		declare @actionListId_a1 int, @actionListId_b1 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId8, 'IsResetRequired==true')	-- success => change state to waiting approval
--		set @actionListId_a1 = SCOPE_IDENTITY()							-- failure => change state to waiting ManualCode
--		--Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--		--	values(@segmentId, @workflowActionId1, 'IsResetRequired==false')	--change state to waiting ManualCode
--		--set @actionListId_b1 = SCOPE_IDENTITY()        
        

--        --12a. On Start: Branch from action based on IsAutoCode variable value
--        --	On Start: StartAutoCode
--        declare @actionListId1 int
--        Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId1, 'IsAutoCode==true && IsApprovalRequired==true')	-- success => change state to waiting approval
--		set @actionListId1 = SCOPE_IDENTITY()							-- failure => change state to waiting ManualCode
		
--		declare @actionListId2 int										
--        Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId1, 'IsAutoCode==false')	--change state to waiting ManualCode
--		set @actionListId2 = SCOPE_IDENTITY()
		
--		-- added to allow automatical approval skipping
--        declare @actionListId1Approval int
--        Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId1, 'IsAutoCode==true && IsApprovalRequired==false')	-- success => change state to waiting approval
--		set @actionListId1Approval = SCOPE_IDENTITY()							-- failure => change state to waiting ManualCode
		
--		--12b. On WaitingManualCode: Code, Reject, RetryAutoCode
--		-- Code
--		declare @actionListId3 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId2, 'IsApprovalRequired==true')  -- change state to waiting approval
--		set @actionListId3 = SCOPE_IDENTITY()
		
--		declare @actionListId4 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId2, 'IsApprovalRequired==false') -- change state to waiting transmission
--		set @actionListId4 = SCOPE_IDENTITY()
		
--		-- Reject
--		declare @actionListId5 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId3, '') --change state to waiting transmission
--		set @actionListId5 = SCOPE_IDENTITY()

--		-- RetryAutoCode
--		declare @actionListId6 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId4, 'IsAutoCode==true && IsApprovalRequired==true') --change state to Start and run action StartAutoCode
--		set @actionListId6 = SCOPE_IDENTITY()
		
--		-- added to allow automatical approval skipping
--        declare @actionListId6Approval int
--        Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId4, 'IsAutoCode==true && IsApprovalRequired==false')	-- success => change state to waiting approval
--		set @actionListId6Approval = SCOPE_IDENTITY()							-- failure => change state to waiting ManualCode

		
--		--12c. On WaitingApproval: Approve, ReCode, Reject
--		-- AutoApproval (bypassApproval)
--		declare @actionListId70 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId60, 'IsResetRequired==false && IsAutoApproval==true && IsAutoApproveExecutedAlready==false')	-- change state to WaitingTransmission
--		set @actionListId70 = SCOPE_IDENTITY()
		
--		--Approve
--		declare @actionListId7 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId6, 'IsResetRequired==false')	-- change state to WaitingTransmission
--		set @actionListId7 = SCOPE_IDENTITY()
		
--		-- ReCode
--		declare @actionListId8 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId5, 'IsResetRequired==false')	-- change state to WaitingManualCode
--		set @actionListId8=SCOPE_IDENTITY()
		
--		-- Comment
--		declare @actionListId12 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId12, '')	-- stay at WaitingApproval state
--		set @actionListId12=SCOPE_IDENTITY()

--		--12d. On WaitingTransmission: Transmit
--		-- BypassTransmit
--		declare @actionListId90 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId70, 'IsBypassTransmit==true')	-- change state to Completed
--		set @actionListId90 = SCOPE_IDENTITY()
		
--		-- Transmit
--		declare @actionListId9 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId7, 'IsBypassTransmit==false')  -- success => change state to [Completed -->] Transmitting
--		set @actionListId9 = SCOPE_IDENTITY()			-- failure => no state change
		
--		--12e. On Reconsider: LeaveAsItIs, RejectCodingDecision
--		declare @actionListId10 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId9, '')  -- success => change state to [Reconsider -->] LeaveAsItIs (completed)
--		set @actionListId10 = SCOPE_IDENTITY()			-- failure => no state change

--		declare @actionListId11 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId10, '')  -- success => change state to [Reconsider -->] RejectCodingDecision (start)
--		set @actionListId11 = SCOPE_IDENTITY()			-- failure => no state change
		

--		/*------------------------------------------------------------------------------------------------------------
--		-- On Transmitting: Cancel
--		declare @actionListId10 int
--		Insert into dbo.WorkflowActionList(SegmentId, WorkflowActionID, ConditionExpression)
--			values(@segmentId, @workflowActionId8, '')  -- success => change state to Waiting Transmission
--		set @actionListId10 = SCOPE_IDENTITY()	
--		*/------------------------------------------------------------------------------------------------------------
		
		
--		--13. Create WorkflowActionItems
--		/*
--			 * Coding Actions: StartAutoCode, Code, Reject, RetryAutoCode, Approve, Transmit
--			 * On Start: StartAutoCode
--			 * On WaitingManualCode: Code, Reject, RetryAutoCode
--			 * On WaitingApproval: Approve, Reject, Comment
--			 * On WaitingTransmission: Transmit
--			 * On Completed: no action
--			 * rules: if workflowSystemActionId is null --> make sure the success flag is 0
--        */
--        --13a0. for retiring/purging synonyms - and reclassifying past and/or current coding decisions
--        declare @systemActionId int
--        select @systemActionId = WorkflowSystemActionID 
--        from WorkflowSystemActionR 
--        where ActionName='Reconsider' and ApplicationID = @applicationId
--		-- set state to GO State if ReClassify Success
--        insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId_a1, @systemActionId, 1, @workflowStateId2, 1)


--        --13a. On Start: StartAutoCode
--        --13a1. AutoCode: Run AutoCoding() and set state to WaitingApproval if autocode success
--        select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='AutoCoding' and ApplicationID = @applicationId
--        insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId1, @systemActionId, 1, @workflowStateId3, 2)
		
--		--13a2. AutoCode: set state to WaitingManualCode if autocode fails
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId1, null, 0, @workflowStateId2, 3) -- TBD: check if null to be replaced by @systemActionId

--		--13a1-NoApproval. AutoCode: set state to Transmission if autocode succeeds
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId1Approval, @systemActionId, 1, @workflowStateId4, 4) 

--		--13a2-NoApproval. AutoCode: set state to WaitingManualCode if autocode fails
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId1Approval, null, 0, @workflowStateId2, 5) -- TBD: check if null to be replaced by @systemActionId


--		--13a3. ManualCode: run SuggestForManualCoding() and set state to WaitingManualCode
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='SuggestManualCoding' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId2, @systemActionId, 1, @workflowStateId2, 2)
			
--		--13b. WaitingManualCode: Code, Reject, RetryAutoCode
--		--13b1. Code : set state to WaitingApproval if IsApprovalRequired
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='ManualCoding' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId3, @systemActionId, 1, @workflowStateId3, 2)
		
--		--13b2. Code : set state to WaitingTransmission if IsApprovalRequired = false
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId4, @systemActionId, 1, @workflowStateId4, 3)
			
--		--13b3. Reject : set state to WaitingTransmission
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='OpenQuery' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId5, @systemActionId, 1, @workflowStateId4, 4)

--		--13b4. RetryAutoCode: set state to WaitingApproval if autocode success
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='AutoCoding' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId6, @systemActionId, 1, @workflowStateId3, 2)
		
--		--13b5. RetryAutoCode: set state to WaitingManualCode if autocode fails
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId6, null, 0, @workflowStateId2, 3)
		
		
--		--13b4-NoApproval. AutoCode: set state to Transmission if autocode succeeds
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId6Approval, @systemActionId, 1, @workflowStateId4, 4) 

--		--13b5-NoApproval. AutoCode: set state to WaitingManualCode if autocode fails
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId6Approval, null, 0, @workflowStateId2, 5) -- TBD: check if null to be replaced by @systemActionId
		
--		--13c. WaitingApproval: Approve 
		
--		--13c1-0. WaitingApproval: Approve and set state to WaitingTransmission if AutoApproval
--		-- TODO : make new systemaction! @systemActionId
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='AutoApprovalIfCodingRuleMatch' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId70, @systemActionId, 1, @workflowStateId4, 2)
		
--		--insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--		--	values(@segmentId, @actionListId70, null, 0, @workflowStateId3, 3)		
		
--		--13c1. WaitingApproval: Approve and set state to WaitingTransmission
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='ApproveCoding' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId7, @systemActionId, 1, @workflowStateId4, 2)
		
--		--13c2. WaitingApproval: Recode and set state to WaitingManualCode
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='ReCoding' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId8, @systemActionId, 1, @workflowStateId2, 2) -- TBD: check successFlag should it be false?
			
--		--13c3. WaitingApproval: Comment--Add a comment to the coding deicsion
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='SetWorkflowState' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId12, @systemActionId, 1, @workflowStateId3, 2)

		
--		--13d1-0. WaitingTransmission: Transmit and set state to Completed if BypassTransmit
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='TransmitCoding' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId90,  @systemActionId, 1, @workflowStateId5, 2)
		
--		--13d1. WaitingTransmission: Transmit and set state to completed
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId9, @systemActionId, 1, @workflowStateId5, 2)
		
		
--		--13e1. Reconsider - Leave as it is
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='LeaveAsItIs' and ApplicationID = @applicationId
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId10, @systemActionId, 1, @workflowStateId5, 1)
		
--		--13e2. Reconsider - RejectCodingDecision
--		select @systemActionId = WorkflowSystemActionID from dbo.WorkflowSystemActionR where ActionName='RejectCodingDecision' and ApplicationID = @applicationId		
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId11, @systemActionId, 1, @workflowStateId1, 1)

		
--		/*------------------------------------------------------------------------------------------------------------
--		--14a. Transmitting: on success set state to Completed
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId9, null, 1, @workflowStateId5, 1)
		
--		--14b. Transmitting: Cancel set state to WaitingTransmission
--		insert into dbo.WorkflowActionItems(SegmentId, WorkflowActionListID, WorkflowSystemActionID, SuccessFlag, TargetStateID, Ordinal)
--			values(@segmentId, @actionListId10, null, 1, @workflowStateId4, 1)
--		*/------------------------------------------------------------------------------------------------------------
		
--		-- setup the CancelQuery Workflow modification
--		EXEC spSetupCancelQueryWorkflowAction @workflowId, @segmentId, @applicationId, @locale
		
--		--15. Create WorkflowActionItemData [TBD - no need for the default workflow]
	
--		PRINT N'Workflow: [' + @WorkflowOID + ' for Segment: [' + @segmentOid + ' is being created as ID ' + CAST(@workflowId AS NVARCHAR)

--		commit transaction
--	end try

--	begin catch
--		rollback transaction

--		Declare	@ErrorSeverity int, 
--				@ErrorState int,
--				@ErrorLine int,
--				@ErrorMessage nvarchar(4000),
--				@ErrorProc nvarchar(4000)

--		select @ErrorSeverity = ERROR_SEVERITY(),
--				@ErrorState = ERROR_STATE(),
--				@ErrorLine = ERROR_LINE(),
--				@ErrorMessage = ERROR_MESSAGE(),
--				@ErrorProc = ERROR_PROCEDURE()
--		select @ErrorMessage = coalesce(@ErrorProc, 'spCreateDefaultWorkflow.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
--		raiserror (@ErrorMessage,  @ErrorSeverity, @ErrorState);
--	end catch

--end
--g