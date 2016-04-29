/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Dan Dapper (ddapper@mdsol.com) 06 oct 2014
//
// By altering the verbatim, the script enables terms to be resent from Rave, get processed, and returned to Coder
// For use in the various scenarios where Coder disregards a coding request because nothing has apparently changed
// since the last coding request.
//

// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_AlterVerbatimTermToForceProcessingAfterRaveRequeue')
	DROP PROCEDURE CMP_AlterVerbatimTermToForceProcessingAfterRaveRequeue
GO


CREATE PROCEDURE dbo.CMP_AlterVerbatimTermToForceProcessingAfterRaveRequeue
(
	@segmentID int,
	@uuID nvarchar(100),
	@comment nvarchar(2000) 
)


AS
BEGIN

DECLARE @codingElementID int


DECLARE @taskIds TABLE(CodingElementId BIGINT PRIMARY KEY, CodingElementGroupID BIGINT, WorkflowStateId INT)


SELECT @codingElementId = CodingElementId FROM CodingElements WHERE SegmentId = @segmentId AND UUID = @uuid 
IF (@codingElementId IS NULL)
	BEGIN
		RAISERROR('CodingElement does not exist!', 16, 1)
		RETURN
	END
 
BEGIN TRY

	BEGIN TRANSACTION

		UPDATE CE
		SET CE.VerbatimTerm = CE.VerbatimTerm + '_'
		OUTPUT inserted.CodingElementId, inserted.CodingElementGroupID, inserted.WorkflowStateId INTO @taskIds(CodingElementId, CodingElementGroupID, WorkflowStateId)
		FROM CodingElements CE
		WHERE CE.CodingElementId = @codingElementId

		INSERT INTO WorkflowTaskHistory (WorkflowTaskID, WorkflowStateID, WorkflowActionID, WorkflowSystemActionID, UserID, Comment, SegmentId, CodingAssignmentId, CodingElementGroupId, QueryId)
		SELECT T.CodingElementId, T.WorkflowStateId, NULL, NULL, -2, @comment, @segmentId, -1, T.CodingElementGroupID, 0
		FROM @taskIds T

		COMMIT TRANSACTION

END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(4000) = N'CMP ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH	

END
