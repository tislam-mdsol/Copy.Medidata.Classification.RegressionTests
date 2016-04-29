/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskHistoryInsert')
	DROP PROCEDURE spWorkflowTaskHistoryInsert
GO

CREATE PROCEDURE dbo.spWorkflowTaskHistoryInsert 
(
	@WorkflowTaskID bigint,
	@WorkflowStateID int,
	@WorkflowActionID int,
	@WorkflowSystemActionID int,
	@UserID int,
	@CodingAssignmentId bigint,
	@Comment nvarchar(4000),
	@SegmentId INT,
	@CodingElementGroupId BIGINT,
	@QueryId INT,
	@Created datetime output,
	@WorkflowTaskHistoryID bigint output
)
AS

BEGIN

	SELECT @Created = GetUtcDate()

	INSERT INTO dbo.WorkflowTaskHistory (
		WorkflowTaskID,
		WorkflowStateID,
		WorkflowActionID,
		WorkflowSystemActionID,
		UserID,
		CodingAssignmentId,
		Comment,
		Created,
		SegmentID,
		CodingElementGroupId,
		QueryId
	) VALUES (
		@WorkflowTaskID,
		@WorkflowStateID,
		@WorkflowActionID,
		@WorkflowSystemActionID,
		@UserID,
		@CodingAssignmentId,
		@Comment,
		@Created,
		@SegmentId,
		@CodingElementGroupId,
		@QueryId
	)
	SET @WorkflowTaskHistoryID = SCOPE_IDENTITY()
END
GO
 