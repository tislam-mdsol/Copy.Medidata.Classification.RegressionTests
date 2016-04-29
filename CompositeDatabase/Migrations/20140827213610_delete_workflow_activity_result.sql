/*
  Delete table and procedures related to WorkflowActivityResult
 */

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowActivityResultFetch')
	DROP PROCEDURE spWorkflowActivityResultFetch
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowActivityResultInsert')
	DROP PROCEDURE spWorkflowActivityResultInsert
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowActivityResultUpdate')
	DROP PROCEDURE spWorkflowActivityResultUpdate
GO

IF EXISTS
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowActivityresult')
	DROP TABLE WorkflowActivityresult
GO
