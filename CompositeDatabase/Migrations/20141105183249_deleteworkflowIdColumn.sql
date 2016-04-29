 
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_WorkflowRoles_WorkflowId')
	DROP INDEX WorkflowRoles.IX_WorkflowRoles_WorkflowId

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'WorkflowRoles'
   AND COLUMN_NAME = 'WorkflowId')
BEGIN 
ALTER TABLE WorkflowRoles
DROP COLUMN WorkflowId

END