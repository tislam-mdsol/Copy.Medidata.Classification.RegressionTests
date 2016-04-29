IF EXISTS 
	(SELECT NULL FROM sys.foreign_keys WHERE name = 'FK_CodingElements_WorkflowTasks')
	ALTER TABLE CodingElements
	DROP CONSTRAINT FK_CodingElements_WorkflowTasks
GO

IF EXISTS 
	(SELECT NULL FROM sys.foreign_keys WHERE name = 'FK_WorkflowTaskData_WorkflowTaskID')
	ALTER TABLE WorkflowTaskData
	DROP CONSTRAINT FK_WorkflowTaskData_WorkflowTaskID
GO

IF EXISTS 
	(SELECT NULL FROM sys.foreign_keys WHERE name = 'FK_WorkflowTaskHistory_WorkflowTaskID')
	ALTER TABLE WorkflowTaskHistory
	DROP CONSTRAINT FK_WorkflowTaskHistory_WorkflowTaskID
GO

IF EXISTS 
(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowTasks')
	DROP TABLE WorkflowTasks
GO

-- must also correlate all references to workflowtasks

--1. WorkflowTaskData
UPDATE WTD
SET WTD.WorkflowTaskId = CE.CodingElementId
FROM WorkflowTaskData WTD
	JOIN CodingElements CE
		ON CE.WorkflowTaskId = WTD.WorkflowTaskId
		AND CE.WorkflowTaskId <> CE.CodingElementId

--2. WorkflowTaskHistory
UPDATE WTH
SET WTH.WorkflowTaskId = CE.CodingElementId
FROM WorkflowTaskHistory WTH
	JOIN CodingElements CE
		ON CE.WorkflowTaskId = WTH.WorkflowTaskId
		AND CE.WorkflowTaskId <> CE.CodingElementId
