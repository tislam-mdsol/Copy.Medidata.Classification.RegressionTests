/*
  Delete table and procedures related to WorkflowRunnerServiceHeartBeat
 */

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowRunnerServiceHeartBeatFetch')
	DROP PROCEDURE spWorkflowRunnerServiceHeartBeatFetch
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowRunnerServiceHeartBeatInsert')
	DROP PROCEDURE spWorkflowRunnerServiceHeartBeatInsert
GO

IF EXISTS
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowRunnerServiceHeartBeat')
	DROP TABLE WorkflowRunnerServiceHeartBeat
GO
