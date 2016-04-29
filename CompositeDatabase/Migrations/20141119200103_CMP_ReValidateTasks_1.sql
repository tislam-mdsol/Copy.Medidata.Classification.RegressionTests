/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan@mdsol.com
//
//
//This CMP is to validate tasks whose workflow status is not 'Completed' and were invalidated by system
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_ReValidateTasks')
	DROP PROCEDURE spCoder_CMP_ReValidateTasks
GO

CREATE PROCEDURE dbo.spCoder_CMP_ReValidateTasks
(
	@SegmentName NVARCHAR(50),
	@StudyName NVARCHAR(50)
)
AS 
BEGIN

	DECLARE @errorString NVARCHAR(1000)
	
	DECLARE @SegmentId INT
	DECLARE @StudyID BIGINT

	SELECT @SegmentId = SegmentID
	FROM Segments
	WHERE SegmentName = @SegmentName
	
	IF (@SegmentID IS NULL)
	BEGIN
		PRINT N'Segment not found: ' + @SegmentName
		RETURN 1
	END

	SELECT @StudyID = TrackableObjectID
	FROM TrackableObjects
	WHERE ExternalObjectName = @StudyName AND SegmentId = @SegmentID

	IF (@StudyID IS NULL)
	BEGIN
		PRINT N'Study not found: ' + @StudyName
		RETURN 1
	END

	-- Determine tasks to update
	DECLARE @TasksToUpdate TABLE (CodingElementId INT)

	DECLARE @CompletedStatusId INT = (SELECT WorkflowStateID FROM dbo.WorkflowStates WHERE SegmentId=@SegmentId AND IsTerminalState=1)
	
	;WITH InvalidateTasks
	AS(
	SELECT CE.CodingElementId,
	ROW_NUMBER() OVER (PARTITION BY CodingElementId ORDER BY WorkflowTaskHistoryID DESC) AS rownum
	FROM dbo.CodingElements CE
	JOIN WorkflowTaskHistory WFT
		ON WFT.WorkflowTaskID = CE.CodingElementId
	WHERE StudyDictionaryVersionId IN (SELECT StudyDictionaryVersionId FROM dbo.StudyDictionaryVersion WHERE StudyID=@StudyID )
		AND CE.IsInvalidTask=1
		AND CE.WorkflowStateID <> @CompletedStatusId
	)
	INSERT INTO @TasksToUpdate
	SELECT CodingElementId
	FROM InvalidateTasks
	WHERE rownum=1

	BEGIN TRY
	BEGIN TRANSACTION		
	DECLARE @UtcTime DATETIME=GETUTCDATE()
	UPDATE CE
	SET	IsInvalidTask =0,
		IsClosed = 0,
		Updated =@UtcTime,
		CacheVersion = CacheVersion + 10
	FROM CodingElements CE
		JOIN @TasksToUpdate T 
		ON CE.CodingElementId = T.CodingElementId		
		

	INSERT INTO dbo.WorkflowTaskHistory
        ( WorkflowTaskID ,
          WorkflowStateID ,
          WorkflowActionID ,
          WorkflowSystemActionID ,
          UserID ,
          WorkflowReasonID ,
          Comment ,
          Created ,
          SegmentId ,
          CodingAssignmentId ,
          CodingElementGroupId ,
          QueryId
        )
   SELECT CE.CodingElementId, CE.WorkflowStateID, NULL, NULL, -2, NULL, 
		'Re-validate tasks per CMP 05/21/2014', @UtcTime, CE.SegmentId, NULL,CE.CodingElementGroupID,0
	FROM CodingElements CE
		JOIN @TasksToUpdate T ON CE.CodingElementId = T.CodingElementId
	
	PRINT N'Re-Validate tasks succeeded!'
	COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		SET @errorString = N'ERROR Updating Tasks: ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH

	
END