-- drop logic
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAsyncTaskNodeFetch')
	DROP PROCEDURE spAsyncTaskNodeFetch
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAsyncTaskNodeInsert')
	DROP PROCEDURE spAsyncTaskNodeInsert
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAsyncTaskNodeReportFetch')
	DROP PROCEDURE spAsyncTaskNodeReportFetch
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAsyncTaskNodeReportInsert')
	DROP PROCEDURE spAsyncTaskNodeReportInsert

-- drop tables
IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'AsyncTaskNodeReports'))
	DROP TABLE AsyncTaskNodeReports

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'AsyncTaskNodes'))
	DROP TABLE AsyncTaskNodes
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints WHERE name = 'DF_LongAsyncTaskHistory_AsyncTaskNodeId')
	ALTER TABLE LongAsyncTaskHistory
	DROP CONSTRAINT DF_LongAsyncTaskHistory_AsyncTaskNodeId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LongAsyncTaskHistory'
		 AND COLUMN_NAME = 'AsyncTaskNodeId')
	ALTER TABLE LongAsyncTaskHistory
	DROP COLUMN AsyncTaskNodeId
GO