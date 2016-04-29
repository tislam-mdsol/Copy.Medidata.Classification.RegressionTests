SET NOCOUNT ON 
go

CREATE TABLE #HelpContext
(
	id              int IDENTITY,
	Tag 			varchar(50) NOT NULL,
	Link		 	Nvarchar(400) NOT NULL,
	Action		    varchar(15) NOT NULL	
)

-- DO NOT WRITE ABOVE THIS LINE
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('TableOfContents', N'CoderOnlineHelp.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CustomerSupport', N'http://tollfree.mdsol.com/', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_CodingConfiguration', N'Coder/Coder_Configuration/Coding_Configuration_Parameters.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_DictionaryAdmin', N'Coder/Coder_Configuration/Dictionary_Administration.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_DictionaryVersionAdmin', N'Coder/Coder_Configuration/Dictionary_Version_Administration.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_CodingReclassification', N'Coder/Coding_Reclassification/Coding_Reclassification.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_CodingTaskReport', N'Coder/Coding_Reports/Coding_Decisions_Report.htm', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_StudyVersionHistory', N'Coder/Coding_Reports/Study_Report.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_CodingHistoryReport', N'Coder/Coding_Reports/Coding_History_Report.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_CodingTaskPage', N'Coder/Coding_Tasks/Coding_Tasks.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingTaskPagePropertyTab', N'Coder/Coding_Tasks/Task_Properties.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingTaskPageSourceTermTab', N'Coder/Coding_Tasks/Source_Terms.htm', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingTaskPageAssignmentTab', N'Coder/Coding_Tasks/Task_Assignments.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingTaskPageHistoryTab', N'Coder/Coding_Tasks/Coding_History.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingTaskPageQueryTab', N'Coder/Coding_Tasks/Coding_Query.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_CodingBrowserTab', N'Coder/Dictionary_Browser/Dictionary_Browse_and_Search.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingBrowserTermSearchTab', N'Coder/Dictionary_Browser/Dictionary_Browse_and_Search.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingBrowserPageSuggestionsTab', N'Coder/Dictionary_Browser/Browser_Term_Suggestions.htm', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingBrowserPagePropertyTab', N'Coder/Dictionary_Browser/Browser_Term_Properties.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingBrowserPageHistoryTab', N'Coder/Dictionary_Browser/Browser_Term_History.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_SynonymAdmin', N'Coder/Synonym_Management/Synonym_Administration.htm', '-DELETE-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_Synonym', N'Coder/Synonym_Management/Synonym_Administration.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_SynonymDetails', N'Coder/Synonym_Management/View_Synonym_Details_for_a_Completed_Synonym_Migration.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_SynonymLoading', N'Coder/Synonym_Management/Upload_a_Synonym_List.htm', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_SynonymMigrationReconcile', N'Coder/Synonym_Management/Reconcile_Synonym_Migration.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_SynonymApproval', N'Coder/Synonym_Management/Synonym_Approval.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_WorkflowRoleActionsPage', N'Coder/Security_Administration/Create_Workflow_Role.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_UserObjectWorkflowRolesPage', N'Coder/Security_Administration/Assign_Workflow_Role.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_RoleManagement', N'Coder/Security_Administration/Create_General_Role.htm', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_UserRoleManagement', N'Coder/Security_Administration/Assign_General_Role.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_MedidataAdminConsole', N'Coder/Security_Administration/Medidata_Administration_Console.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_TransmitCodingResponse', N'Coder/Security_Administration/Transmit_Coding_Response.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_ViewWorkflowAdmin', N'Coder/Workflow_Administration/Workflow_Administration.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ViewWorkflowAdminTabWorkflowState', N'Coder/Workflow_Administration/Workflow_States.htm', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ViewWorkflowAdminTabWorkflowAction', N'Coder/Workflow_Administration/Workflow_Actions.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ViewWorkflowAdminTabWorkflowReason', N'Coder/Workflow_Administration/Workflow_Reason.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ViewWorkflowAdminTabWorkflowVariable', N'Coder/Workflow_Administration/Workflow_Variable.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ViewWorkflowAdminTabStateAction', N'Coder/Workflow_Administration/Workflow_State_Action.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ViewWorkflowAdminTabActionReason', N'Coder/Workflow_Administration/Workflow_Action_Reason.htm', '-INSERT-')

INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ViewWorkflowAdminTabActionCondition', N'Coder/Workflow_Administration/Workflow_Action_Condition.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_ImpactAnalysis', N'Coder/Study_Impact_Analysis/Study_Impact_Analysis.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_TransmissionQueue', N'Coder/Transmission_Queue/Transmission_Queue.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_ProjectRegistration', N'Coder/Project_Registration/Project_Registration.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_DoNotAutoCodeTerms', N'Coder/Do_Not_Auto_Code/Do_Not_Auto_Code.htm', '-INSERT-')
INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('ScreenHelp_IngredientReport', N'Coder/Coding_Reports/Ingredient_Report.htm', '-INSERT-')

-- TODO : pending URL from tech-comm team
--INSERT INTO #HelpContext ([Tag], Link, [Action]) VALUES('CodingBrowserPageTextBox', N'Coder/Getting_Started/Getting_Started.htm', '-INSERT-')

-- DO NOT WRITE BELOW THIS LINE

IF EXISTS(
	SELECT Tag
	FROM #HelpContext
	GROUP BY Tag
	HAVING COUNT(*) > 1
)
BEGIN
	-- will return duplicate entries
	SELECT * FROM #HelpContext
	WHERE Tag IN
	(
		SELECT Tag
		FROM #HelpContext
		GROUP BY Tag
		HAVING COUNT(*) > 1
	)
	ORDER BY Tag

	RAISERROR ('The script contains duplicate entries (see the recordset). Remove duplicates and re-run the script. Script aborted', 16, 1)
END
ELSE
BEGIN


	-- Insert into HelpContexts those entries 
	-- from #HelpContext that are missing from HelpContexts
	INSERT INTO [HelpContexts](
				[HelpContext]
			   ,[HelpPage]
			   ,[IsWindowsMedia]
			   ,[WindowsMediaSource]
			   ,[CaptivateIndex]
			   ,[CaptivatePlaylist]
			   ,[Created]
			   ,[Updated])
	SELECT tmp.Tag, tmp.Link, 0
			   ,null
			   ,null -- video filename on  (demo.swf)
			   ,null
			   ,GETUTCDATE()
			   ,GETUTCDATE()
	FROM #HelpContext tmp
		LEFT JOIN HelpContexts H ON
			tmp.Tag = H.HelpContext
	WHERE H.HelpContext IS NULL
	
	-- Update those records in HelpContexts that exists in
	-- #HelpContext and are marked with with Action = '-UPDATE-'
	UPDATE HelpContexts
	SET 
		[HelpPage] = tmp.Link,
		Updated = GETUTCDATE()
	FROM #HelpContext tmp
		LEFT JOIN HelpContexts H ON
			tmp.Tag = H.HelpContext
	WHERE H.HelpContext IS NOT NULL
		AND UPPER(tmp.Action) IN ('-INSERT-','-UPDATE-')
	
	-- Delete those records in HelpContexts that exists in
	-- #HelpContext and are marked with Action = '-DELETE-'
	DELETE HelpContexts
	FROM #HelpContext tmp
		LEFT JOIN HelpContexts H ON
			tmp.Tag = H.HelpContext
	WHERE H.HelpContext IS NOT NULL
	AND UPPER(tmp.Action) = '-DELETE-'
END
DROP TABLE #HelpContext  
