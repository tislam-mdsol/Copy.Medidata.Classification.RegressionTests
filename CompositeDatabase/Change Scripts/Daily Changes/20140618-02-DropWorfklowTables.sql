IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowActionItemData')
	DROP TABLE WorkflowActionItemData
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MedicalDictVerSegmentWorkflows')
	DROP TABLE MedicalDictVerSegmentWorkflows
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ObjectSegmentWorkflows')
	DROP TABLE ObjectSegmentWorkflows
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SystemVariables')
	DROP TABLE SystemVariables
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowVariableLookupValues')
	DROP TABLE WorkflowVariableLookupValues
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_WorkflowTaskData_WorkflowVariables')
	ALTER TABLE WorkflowTaskData
	DROP CONSTRAINT FK_WorkflowTaskData_WorkflowVariables
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowVariables')
	DROP TABLE WorkflowVariables
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowActionItems')
	DROP TABLE WorkflowActionItems
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowActionList')
	DROP TABLE WorkflowActionList
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowActionReasons')
	DROP TABLE WorkflowActionReasons
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowStateActions')
	DROP TABLE WorkflowStateActions
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_WorkflowRoleActions_WorkflowAction')
	ALTER TABLE WorkflowRoleActions
	DROP CONSTRAINT FK_WorkflowRoleActions_WorkflowAction
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_WorkflowTaskHistory_WorkflowActionID')
	ALTER TABLE WorkflowTaskHistory
	DROP CONSTRAINT FK_WorkflowTaskHistory_WorkflowActionID
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowActions')
	DROP TABLE WorkflowActions
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowReasons')
	DROP TABLE WorkflowReasons
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_WorkflowStates_IconID')
	ALTER TABLE WorkflowStates
	DROP CONSTRAINT FK_WorkflowStates_IconID
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowStateIcons')
	DROP TABLE WorkflowStateIcons
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowSystemActionR')
	DROP TABLE WorkflowSystemActionR
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_WorkflowTaskHistory_WorkflowStateID')
	ALTER TABLE WorkflowTaskHistory
	DROP CONSTRAINT FK_WorkflowTaskHistory_WorkflowStateID
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WorkflowStates')
	DROP TABLE WorkflowStates
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_AppSourceSystems_WorkflowId')
	ALTER TABLE ApplicationSourceSystems
	DROP CONSTRAINT FK_AppSourceSystems_WorkflowId
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_WorkflowRoles_Workflow')
	ALTER TABLE WorkflowRoles
	DROP CONSTRAINT FK_WorkflowRoles_Workflow
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Workflows')
	DROP TABLE Workflows
GO