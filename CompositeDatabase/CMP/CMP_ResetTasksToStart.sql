/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_ResetTasksToStart')
	DROP PROCEDURE CMP_ResetTasksToStart
GO

CREATE PROCEDURE dbo.CMP_ResetTasksToStart
(
	@dictionaryOID VARCHAR(100),
	@versionOID VARCHAR(100),
	@listName VARCHAR(250),
	@segmentName VARCHAR(250),
	@comment VARCHAR(500)
)
AS
BEGIN

	DECLARE @dictionaryID INT,
		@dictionaryVersionID INT,
		@listId INT,
		@segmentId INT,
		@startId INT,
		@waitingManualCodeId INT

	SELECT @segmentId = SegmentId 
	FROM Segments
	WHERE SegmentName = @segmentName

	IF (@segmentId IS NULL)
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END

	SELECT @dictionaryID = DictionaryRefID
	FROM DictionaryRef
	WHERE OID = @dictionaryOID

	IF (@dictionaryID IS NULL)
	BEGIN
		SELECT 'Cannot find dictionary'
		RETURN 0
	END

	SELECT @dictionaryVersionID = DictionaryVersionRefID
	FROM DictionaryVersionRef
	WHERE OID = @versionOID
		AND DictionaryRefID = @dictionaryID

	IF (@dictionaryVersionID IS NULL)
	BEGIN
		SELECT 'Cannot find dictionary version'
		RETURN 0
	END

	SELECT @listId = SynonymMigrationMngmtID
	FROM SynonymMigrationMngmt
	WHERE SegmentID = @segmentId
		AND ListName = @listName
		AND DictionaryVersionId = @dictionaryVersionID
		AND Deleted = 0

	IF (@listId IS NULL)
	BEGIN
		SELECT 'Cannot find synonym list'
		RETURN 0
	END

	SELECT @startId = WorkflowStateID
	FROM WorkflowStates
	WHERE SegmentId = @segmentId
		AND dbo.fnLDS(WorkflowStateNameID, 'eng') = 'Start'

	IF (@startId IS NULL)
	BEGIN
		SELECT 'Cannot find start state'
		RETURN 0
	END

	SELECT @waitingManualCodeId = WorkflowStateID
	FROM WorkflowStates
	WHERE SegmentId = @segmentId
		AND dbo.fnLDS(WorkflowStateNameID, 'eng') = 'Waiting Manual Code'

	IF (@waitingManualCodeId IS NULL)
	BEGIN
		SELECT 'Cannot find waiting manual code state'
		RETURN 0
	END

	DECLARE @taskIds TABLE(CodingElementId BIGINT PRIMARY KEY, CodingElementGroupID BIGINT)

	BEGIN TRY
	BEGIN TRANSACTION

		UPDATE CE
		SET CE.WorkflowStateId = @startId,
			CE.CacheVersion = CE.CacheVersion + 2
		OUTPUT inserted.CodingElementId, inserted.CodingElementGroupID INTO @taskIds(CodingElementId, CodingElementGroupID)
		FROM StudyDictionaryVersion SDV
			JOIN CodingElements CE
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
				AND SDV.SynonymManagementID = @listId
				AND SDV.SegmentID = @segmentId
		WHERE CE.SegmentId = @segmentId
			AND CE.WorkflowStateID = @waitingManualCodeId
			AND CE.IsStillInService = 0
			AND CE.IsInvalidTask = 0

		INSERT INTO WorkflowTaskHistory (WorkflowTaskID, WorkflowStateID, WorkflowActionID, WorkflowSystemActionID, UserID, Comment, SegmentId, CodingAssignmentId, CodingElementGroupId, QueryId)
		SELECT T.CodingElementId, @startId, NULL, NULL, -2, @comment, @segmentId, -1, T.CodingElementGroupID, 0
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

