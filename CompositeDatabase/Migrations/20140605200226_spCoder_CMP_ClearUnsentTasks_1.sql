/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
//
//
// Purpose is to remove terms from Coder that are going to be re-queued in Rave.
// Only terms that have never had a coding decision sent to Rave are cleared.
// Terms are marked invalid, and a WorkflowTaskHistory comment is added.
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_ClearUnsentTasks')
	DROP PROCEDURE spCoder_CMP_ClearUnsentTasks
GO

-- spCoder_CMP_ClearUnsentTasks N'UNTC', N'TDE-PH-304'
-- spCoder_CMP_ClearUnsentTasks N'CoderDevSegE', N'CoderDevStudyOfE'

CREATE PROCEDURE dbo.spCoder_CMP_ClearUnsentTasks
(
	@SegmentName NVARCHAR(50),
	@StudyName NVARCHAR(50)
)
AS 
BEGIN

	DECLARE @errorString NVARCHAR(1000)
	DECLARE @TaskUpdateChunkSize INT = 200

	-- Get matching segment and study ids
	DECLARE @SegmentID INT
	DECLARE @StudyID BIGINT
	DECLARE @StudyUUID VARCHAR(50)

	SELECT @SegmentID = SegmentID
	FROM Segments
	WHERE SegmentName = @SegmentName
	
	IF (@SegmentID IS NULL)
	BEGIN
		PRINT N'Segment not found: ' + @SegmentName
		RETURN
	END

	SELECT @StudyID = TrackableObjectID, @StudyUUID = ExternalObjectID
	FROM TrackableObjects
	WHERE ExternalObjectName = @StudyName AND SegmentId = @SegmentID

	IF (@StudyID IS NULL)
	BEGIN
		PRINT N'Study not found: ' + @StudyName
		RETURN
	END

	-- Determine tasks that have assignments sent to Rave (rejections are already marked as Invalid)
	DECLARE @TasksToKeep TABLE (CodingElementId INT);

	INSERT INTO @TasksToKeep
	SELECT CA.CodingElementID
	FROM TransmissionQueueItems TQI
		JOIN CodingAssignment CA ON TQI.ObjectID = CA.CodingAssignmentID
	WHERE   TQI.SegmentId = @SegmentID 
		AND StudyOID = @StudyUUID 
		AND ObjectTypeID = 2075 -- CodingAssignment Type


	-- Determine tasks to update
	DECLARE @TasksToUpdate TABLE (CodingElementId INT);

	INSERT INTO @TasksToUpdate
	SELECT CE.CodingElementID
	FROM CodingElements CE
		JOIN StudyDictionaryVersion SDV ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
	WHERE   SDV.SegmentID = @SegmentID 
		AND SDV.StudyID = @StudyID
		AND CE.IsInvalidTask = 0
		AND CE.IsClosed = 0
		AND CE.CodingElementId NOT IN (SELECT CodingElementId FROM @TasksToKeep)

	BEGIN TRY
	BEGIN TRANSACTION		
		
		-- chunk updates
		SET ROWCOUNT @TaskUpdateChunkSize

		UPDATE_TASKS:

			-- Mark all tasks not in TasksToKeep as invalid, and with a future cache version to nullify any pending updates
			UPDATE CE
			SET	IsInvalidTask = 1,
				IsClosed = 1,
				CacheVersion = CacheVersion + 10
			FROM CodingElements CE
				JOIN @TasksToUpdate T ON CE.CodingElementId = T.CodingElementId 
					AND CE.IsInvalidTask = 0 -- not already updated
					AND CE.IsClosed = 0

		IF (@@ROWCOUNT > 0)
			GOTO UPDATE_TASKS	

		SET ROWCOUNT 0

		INSERT INTO WorkflowTaskHistory
			(WorkflowTaskID, WorkflowStateID, WorkflowActionID, WorkflowSystemActionID, UserID, 
			Comment, SegmentId, CodingAssignmentId)
		SELECT CE.CodingElementId, CE.WorkflowStateID, NULL, NULL, -2, 
			'Marked Invalid to requeue from Rave', CE.SegmentId, NULL
		FROM CodingElements CE
			JOIN @TasksToUpdate T ON CE.CodingElementId = T.CodingElementId
	
	COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		SET @errorString = N'ERROR Updating Tasks: ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH

END
