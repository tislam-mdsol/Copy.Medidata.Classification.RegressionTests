IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskHistoryUpdate')
	DROP PROCEDURE dbo.spWorkflowTaskHistoryUpdate
GO

CREATE PROCEDURE dbo.spWorkflowTaskHistoryUpdate (
	@WorkflowTaskHistoryID bigint,
	@WorkflowTaskID bigint,
	@WorkflowStateID int,
	@WorkflowActionID int,
	@WorkflowSystemActionID int,
	@UserID int,
	@CodingElementGroupId BIGINT,
	@QueryId INT,
	@CodingAssignmentId BIGINT,
	@Comment nvarchar(4000)
)
AS

BEGIN

	UPDATE dbo.WorkflowTaskHistory SET
		WorkflowTaskID = @WorkflowTaskID,
		WorkflowStateID = @WorkflowStateID,
		WorkflowActionID = @WorkflowActionID,
		WorkflowSystemActionID = @WorkflowSystemActionID,
		UserID = @UserID,
		CodingElementGroupId = @CodingElementGroupId,
		QueryId = @QueryId,
		CodingAssignmentId = @CodingAssignmentId,
		Comment = @Comment
	WHERE WorkflowTaskHistoryID = @WorkflowTaskHistoryID
END

GO
