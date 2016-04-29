﻿--/* ------------------------------------------------------------------------------------------------------
--// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
--//
--// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
--// this file may not be disclosed to third parties, copied or duplicated in 
--// any form, in whole or in part, without the prior written permission of
--// Medidata Solutions Worldwide.
--//
--// Author: Jalal Uddin juddin@mdsol.com
--// ------------------------------------------------------------------------------------------------------*/
----------------------------------------------------------------------------------------------------------------- 
---- Coder Main Helps: expecting help/video files on the amazon aws
---- Note: For screen help the context should be ScreenHelp_<Page Name> i.e. ScreenHelp_CodingTaskPage
-----------------------------------------------------------------------------------------------------------------

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'TableOfContents') begin
--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('TableOfContents'
--           ,N'CoderOnlineHelp.htm' -- \\coder-webhelp\WebHelp\Main.htm  -- HelpContentsIndex.htm
--           ,0
--           ,null
--           ,N'demo.swf'	-- video filename on  
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CustomerSupport') begin

--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CustomerSupport'
--           ,N'http://tollfree.mdsol.com/' -- http://tollfree.mdsol.com/ -- CustomerService.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end

---- Coding Task Page Helps
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingTaskPageSourceTermTab') begin

--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingTaskPageSourceTermTab'
--           ,N'Coder/Coding_Tasks/Task_Source_Terms.htm' -- \\coder-webhelp\WebHelp\Coder\Coding_Tasks\Task_Source_Terms.htm -- HelpSourceTermFrame.htm
--           ,0
--           ,null
--           ,null -- video filename 
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingTaskPagePropertyTab') begin

--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingTaskPagePropertyTab'
--           ,N'Coder/Coding_Tasks/Task_Properties.htm' -- \\coder-webhelp\WebHelp\Coder\Coding_Tasks\Task_Properties.htm -- HelpPropertyFrame.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingTaskPageAssignmentTab') begin
--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingTaskPageAssignmentTab'
--           ,N'Coder/Coding_Tasks/Task_Assignments.htm' --\\coder-webhelp\WebHelp\Coder\Coding_Tasks\Task_Assignments.htm -- HelpAssignmentFrame.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingTaskPageHistoryTab') begin

--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingTaskPageHistoryTab'
--           ,N'Coder/Coding_Tasks/Coding_History.htm' -- \\coder-webhelp\WebHelp\Coder\Coding_Tasks\Coding_History.htm -- HelpHistoryFrame
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end

---- Browser Page Helps
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingBrowserPageSuggestionTab') begin

--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingBrowserPageSuggestionTab'
--           ,N'Coder/Dictionary_Browser/Browser_Term_Suggestions.htm' -- \\coder-webhelp\WebHelp\Coder\Dictionary_Browser\Browser_Term_Suggestions.htm -- HelpSuggestion.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingBrowserPageTermSearchTab') begin

--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingBrowserPageTermSearchTab'
--           ,N'Coder/Dictionary_Browser/Dictionary_Browser.htm' -- \\coder-webhelp\WebHelp\Coder\Dictionary_Browser\Dictionary_Browser.htm -- HelpTermSearch.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())       
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingBrowserPagePropertyTab') begin
           
--	INSERT INTO  [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingBrowserPagePropertyTab'
--           ,N'Coder/Dictionary_Browser/Browser_Term_Properties.htm' -- \\coder-webhelp\WebHelp\Coder\Dictionary_Browser\Browser_Term_Properties.htm -- HelpPropertyFrame.htm
--           ,0
--           ,null
--           ,null
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())
--end



--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingBrowserPageHistoryTab') begin

--	INSERT INTO [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('CodingBrowserPageHistoryTab'
--           ,N'Coder/Dictionary_Browser/Browser_Term_History.htm' --\\coder-webhelp\WebHelp\Coder\Dictionary_Browser\Browser_Term_History.htm -- HelpHistoryFrame.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())                                 
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_CodingTaskPage') begin
--	INSERT INTO [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('ScreenHelp_CodingTaskPage'
--           ,N'Coder/Coding_Tasks/Coding_Tasks.htm' -- \\coder-webhelp\WebHelp\Coder\Coding_Tasks\Coding_Tasks.htm -- HelpCodingTaskPage.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())  
--end           
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_CodingBrowserTab') begin           
--	INSERT INTO [dbo].[HelpContexts]
--           ([HelpContext]
--           ,[HelpPage]
--           ,[IsWindowsMedia]
--           ,[WindowsMediaSource]
--           ,[CaptivateIndex]
--           ,[CaptivatePlaylist]
--           ,[Created]
--           ,[Updated])
--     VALUES
--           ('ScreenHelp_CodingBrowserTab'
--           ,N'Coder/Dictionary_Browser/Dictionary_Browser.htm' --\\coder-webhelp\WebHelp\Coder\Dictionary_Browser\Dictionary_Browser.htm -- HelpCodingBrowserTab.htm
--           ,0
--           ,null
--           ,null -- video filename on  (demo.swf)
--           ,null
--           ,GETUTCDATE()
--           ,GETUTCDATE())  
           
--end

---- other pages
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_CodingTaskReport') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_CodingTaskReport'
--			   ,N'Coder/Coding_Reports/Coding_Decisions_Report.htm' -- \\coder-webhelp\WebHelp\Coder\Coding_Reports\Coding_Decisions_Report.htm --HelpCodingTaskReport.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

---- coding pages
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_CodingConfiguration') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_CodingConfiguration'
--			   ,N'Coder/Coder_Configuration/Coding_Configuration_Parameters.htm' -- \\coder-webhelp\WebHelp\Coder\Coder_Configuration\Set_coding_configuration_parameters.htm -- HelpCodingConfiguration.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_UserObjectWorkflowRolesPage') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_UserObjectWorkflowRolesPage'
--			   ,N'Coder/Security_Administration/User_Workflow_Role_Management.htm' --\\coder-webhelp\WebHelp\Coder\Security_Administration\User_Workflow_Role_Management.htm -- HelpUserObjectWorkflowRolesPage.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_WorkflowRoleActionsPage') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_WorkflowRoleActionsPage'
--			   ,N'Coder/Security_Administration/Workflow_Role_Management.htm' --\\coder-webhelp\WebHelp\Coder\Security_Administration\Workflow_Role_Management.htm -- HelpWorkflowRoleActionsPage.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
---- Synonym Admin

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SynonymAdmin') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SynonymAdmin'
--			   ,N'Coder/Synonym_Administration/Synonym_Administration.htm' -- \\coder-webhelp\WebHelp\Coder\Synonym_Administration\Synonym_Administration.htm -- HelpSynonymAdmin.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SynonymDetails') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SynonymDetails'
--			   ,N'Coder/Synonym_Administration/View_Synonym_Details_for_a_Completed_Synonym_Migration.htm' -- \\coder-webhelp\WebHelp\Coder\Synonym_Administration\View_Synonym_Details_for_a_Completed_Synonym_Migration.htm -- HelpSynonymDetails.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SynonymMigrationReconcile') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SynonymMigrationReconcile'
--			   ,N'Coder/Synonym_Administration/Reconcile_Synonym_Migration.htm' --\\coder-webhelp\WebHelp\Coder\Synonym_Administration\Reconcile_Synonym_Migration.htm -- HelpSynonymMigrationReconcile.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
----Admin Pages


--/*
---- Moved to Configuration Tab

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_DictionaryAdmin') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_DictionaryAdmin'
--			   ,N'Coder/Coder_Configuration/Dictionary_Administration.htm' --\\coder-webhelp\WebHelp\Coder\Coder_Configuration\Dictionary_Administration.htm -- HelpDictionaryAdmin.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

----Moved to Configuration Tab
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_DictionaryVersionAdmin') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_DictionaryVersionAdmin'
--			   ,N'Coder/Coder_Configuration/Dictionary_Version_Administration.htm' -- \\coder-webhelp\WebHelp\Coder\Coder_Configuration\Dictionary_Version_Administration.htm -- HelpDictionaryVersionAdmin.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--*/

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_ImpactAnalysis') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_ImpactAnalysis'
--			   ,N'Coder/Study_Impact_Analysis/Study_Impact_Analysis.htm' -- \\coder-webhelp\WebHelp\Coder\Study_Impact_Analysis\Study_Impact_Analysis.htm -- HelpImpactAnalysis.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_StudyVersionHistory') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_StudyVersionHistory'
--			   ,N'Coder/Coding_Reports/Study_Report.htm' -- \\coder-webhelp\WebHelp\Coder\Coding_Reports\Study_Report.htm --HelpStudyVersionHistory.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


---- additional pages to cover help contexts -------------------------------------------------------------------
----Synonym Loading page
----Synonym Approval page
----Coding History Report
----Role Management page
----User Role Management page
----------------------------------------------------------------------------------------------------------------

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SynonymLoadingPage') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SynonymLoadingPage'
--			   ,N'Coder/Synonym_Administration/Upload_a_Synonym_List.htm' -- \\coder-webhelp\WebHelp\Coder\Synonym_Administration\Upload_a_Synonym_List.htm -- HelpSynonymLoadingPage.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SynonymApprovalPage') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SynonymApprovalPage'
--			   ,N'Coder/Synonym_Administration/Synonym_Approval.htm' -- \\coder-webhelp\WebHelp\Coder\Synonym_Administration\Synonym_Approval.htm -- HelpSynonymApprovalPage.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_CodingHistoryReport') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_CodingHistoryReport'
--			   ,N'Coder/Coding_Reports/Coding_History_Report.htm' --\\coder-webhelp\WebHelp\Coder\Coding_Reports\Coding_History_Report.htm -- HelpCodingHistoryReport.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


---- coding configuration Page tabs
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingConfigurationCodingTab') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('CodingConfigurationCodingTab'
--			   ,N'Coder/Coder_Configuration/Set_coding_configuration_parameters.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingConfigurationDictionaryTab') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('CodingConfigurationDictionaryTab'
--			   ,N'Coder/Coder_Configuration/Dictionary_Administration.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'CodingConfigurationDictionaryVersionTab') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('CodingConfigurationDictionaryVersionTab'
--			   ,N'Coder/Coder_Configuration/Dictionary_Version_Administration.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_CodingReclassification') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_CodingReclassification'
--			   ,N'Coder/Coding_Reclassification/Coding_Reclassification.htm' -- \\coder-webhelp\WebHelp\Coder\Coder_Reclassification\Coding_Reclassification.htm -- HelpCodingReclassification.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

---- MedidataAdminConsole
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_MedidataAdminConsole') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_MedidataAdminConsole'
--			   ,N'Coder/Security_Administration/Medidata_Admin_Console.htm' 
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_TransmitCodingResponse') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_TransmitCodingResponse'
--			   ,N'Coder/Security_Administration/Transmit_Coding_Response.htm' 
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_UserRoleManagement') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_UserRoleManagement'
--			   ,N'Coder/Security_Administration/User_Role_Management.htm' --\\coder-webhelp\WebHelp\Coder\Security_Administration\User_Role_Management.htm -- HelpUserRoleManagementPage.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_RoleManagement') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_RoleManagement'
--			   ,N'Coder/Security_Administration/Role_Management.htm' --\\coder-webhelp\WebHelp\Coder\Security_Administration\Role_Management.htm -- HelpRoleManagementPage.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


---- workflow admin pages
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_ViewWorkflowAdmin') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_ViewWorkflowAdmin'
--			   ,N'Coder/Workflow_Administration/Workflow_Administration.htm' --\\coder-webhelp\WebHelp\Coder\Workflow_Administration\Workflow_Administration.htm -- HelpViewWorkflowAdmin.htm
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
 
 
---- workflow admin page tabs

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ViewWorkflowAdminTabWorkflowState') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ViewWorkflowAdminTabWorkflowState'
--			   ,N'Coder/Workflow_Administration/Workflow_States.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ViewWorkflowAdminTabWorkflowAction') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ViewWorkflowAdminTabWorkflowAction'
--			   ,N'Coder/Workflow_Administration/Workflow_Actions.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ViewWorkflowAdminTabWorkflowReason') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ViewWorkflowAdminTabWorkflowReason'
--			   ,N'Coder/Workflow_Administration/Workflow_Reason.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ViewWorkflowAdminTabWorkflowVariable') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ViewWorkflowAdminTabWorkflowVariable'
--			   ,N'Coder/Workflow_Administration/Workflow_Variable.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ViewWorkflowAdminTabStateAction') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ViewWorkflowAdminTabStateAction'
--			   ,N'Coder/Workflow_Administration/Workflow_State_Action.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ViewWorkflowAdminTabActionReason') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ViewWorkflowAdminTabActionReason'
--			   ,N'Coder/Workflow_Administration/Workflow_Action_Reason.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ViewWorkflowAdminTabActionCondition') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ViewWorkflowAdminTabActionCondition'
--			   ,N'Coder/Workflow_Administration/Workflow_Action_Condition.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end


--go


---- ScreenHelp_CodingReclassification		Coder/Coder_Reclassification/Coding_Reclassification.htm
---- ScreenHelp_MedidataAdminConsole			Coder/Security_Administration/MedidataAdminConsole.htm
---- ScreenHelp_TransmitCodingResponse		Coder/Security_Administration/TransmitCodingResponse.htm
---- ScreenHelp_UserRoleManagement			Coder/Security_Administration/User_Role_Management.htm
---- ScreenHelp_RoleManagement				Coder/Security_Administration/Role_Management.htm



--/*
---- security pages
--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SecurityGroupsPage') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SecurityGroupsPage'
--			   ,N'HelpSecurityGroupsPage.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SecurityGroupUsers') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SecurityGroupUsers'
--			   ,N'HelpSecurityGroupUsers.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_SecurityGroupObjectWorkflowRoles') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_SecurityGroupObjectWorkflowRoles'
--			   ,N'HelpSecurityGroupObjectWorkflowRoles.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

---- Root Level Pages

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_MyProfile') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_MyProfile'
--			   ,N'HelpMyProfile.htm' 
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end

--if not exists (select null from [dbo].[HelpContexts] where HelpContext = 'ScreenHelp_Version') begin
--	INSERT INTO [dbo].[HelpContexts]
--			   ([HelpContext]
--			   ,[HelpPage]
--			   ,[IsWindowsMedia]
--			   ,[WindowsMediaSource]
--			   ,[CaptivateIndex]
--			   ,[CaptivatePlaylist]
--			   ,[Created]
--			   ,[Updated])
--		 VALUES
--			   ('ScreenHelp_Version'
--			   ,N'HelpVersion.htm'
--			   ,0
--			   ,null
--			   ,null -- video filename on  (demo.swf)
--			   ,null
--			   ,GETUTCDATE()
--			   ,GETUTCDATE())  
--end
--*/
