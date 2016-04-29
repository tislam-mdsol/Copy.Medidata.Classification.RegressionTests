IF NOT EXISTS (SELECT NULL FROM SYS.TYPES WHERE NAME ='WorkflowStateIds_UDT')
CREATE TYPE dbo.WorkflowStateIds_UDT AS TABLE
(
  WorkflowStateID INT Primary Key
); 
GO