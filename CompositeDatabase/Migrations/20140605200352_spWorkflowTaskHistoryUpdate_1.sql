/** $Workfile: spWorkflowTaskHistoryUpdate.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com]
**
** Complete history on bottom of file
**/

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
	@Comment nvarchar(4000),
	@Created datetime
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
		Comment = @Comment,
		Created = Created
	WHERE WorkflowTaskHistoryID = @WorkflowTaskHistoryID
END

GO
