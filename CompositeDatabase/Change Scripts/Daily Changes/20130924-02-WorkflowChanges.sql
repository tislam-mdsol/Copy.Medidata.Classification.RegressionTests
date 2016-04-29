-- new system action
DECLARE @applicationId INT

SELECT @applicationId = ISNULL(MAX(ApplicationId), 1)
FROM WorkflowSystemActionR
WHERE WorkflowSystemActionId = 1

SET IDENTITY_INSERT dbo.WorkflowSystemActionR ON

IF NOT EXISTS (SELECT NULL FROM WorkflowSystemActionR WHERE ActionName = 'CancelQuery')
	INSERT INTO WorkflowSystemActionR (WorkflowSystemActionId, ActionName, ApplicationId, Active, Created, Updated)
	VALUES(23, 'CancelQuery', @applicationId, 1, GETUTCDATE(), GETUTCDATE())

SET IDENTITY_INSERT dbo.WorkflowSystemActionR OFF

-- create cursor over all Workflows  
DECLARE @workflowId INT, @segmentId INT

DECLARE curWorkflow CURSOR FOR
	SELECT WorkflowID, SegmentId FROM Workflows

OPEN curWorkflow
FETCH curWorkflow INTO @workflowId, @segmentId
WHILE (@@FETCH_STATUS = 0) BEGIN

	EXEC spSetupCancelQueryWorkflowAction @workflowId, @segmentId, @applicationId, 'eng'

	FETCH curWorkflow INTO @workflowId, @segmentId
END -- while

CLOSE curWorkflow
DEALLOCATE curWorkflow






