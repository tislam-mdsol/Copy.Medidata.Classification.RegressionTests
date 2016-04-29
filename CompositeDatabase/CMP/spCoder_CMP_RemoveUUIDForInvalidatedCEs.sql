/* --------------------------------------------------------------------------------------------------
// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author:		Darshan Mehta
// Created:		26 Jan 2016
// Updated by:	 
// Update date:	 
//
//
//  UUID Removal by CodingElementIds.  @comment argument should be '(WR #)'
// 
-----------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spCoder_CMP_RemoveUUIDForInvalidatedCEs')
DROP PROCEDURE dbo.spCoder_CMP_RemoveUUIDForInvalidatedCEs
GO


CREATE PROCEDURE dbo.spCoder_CMP_RemoveUUIDForInvalidatedCEs
(
	@segmentName VARCHAR(250),
	@comment NVARCHAR(MAX),
	@commaDelimitedCEs NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE  
		@segmentId INT,
		@startId INT,
		@errorString NVARCHAR(MAX)

	SET @comment = 	'UUID Removed for Invalidated task' + ISNULL(@Comment, '')

	SELECT @segmentId = SegmentId 
	FROM Segments
	WHERE SegmentName = @segmentName

	IF (@segmentId IS NULL)
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END

	DECLARE @TasksToUpdate TABLE (CodingElementId INT PRIMARY KEY, SegmentID INT, IsInvalidTask bit )
	
	INSERT INTO @TasksToUpdate 
	(
		CodingElementId,
		SegmentId,
		IsInvalidTask		
	)
	SELECT
		item,
		-1,
		0
	FROM dbo.fnParseDelimitedString(@commaDelimitedCEs,',')

	UPDATE
		@TasksToUpdate
	SET
		SegmentId = CE.SegmentId
	FROM
		@TasksToUpdate t
	INNER JOIN
		CodingElements CE
	ON
		CE.SegmentId = @SegmentId and CE.CodingElementId  = t.CodingElementId

		
	IF EXISTS (SELECT NULL FROM @TasksToUpdate WHERE SegmentId <> @SegmentID)
	BEGIN
		SET @errorString = N'ERROR: CodingElements are not in segment or do not exist!'
		SELECT * FROM @TasksToUpdate WHERE SegmentId <> @SegmentID
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	

	UPDATE
		@TasksToUpdate
	SET
		IsInvalidTask = CE.IsInvalidTask
	FROM
		@TasksToUpdate t
	INNER JOIN
		CodingElements CE
	ON
		CE.SegmentId = @SegmentId and CE.CodingElementId  = t.CodingElementId and ce.IsInvalidTask = 1 and ce.IsClosed = 1

	
	IF EXISTS (SELECT NULL FROM @TasksToUpdate WHERE IsInvalidTask <> 1)
	BEGIN
		SET @errorString = N'ERROR: CodingElements are not Invalidated!'
		SELECT * FROM @TasksToUpdate WHERE IsInvalidTask <> 1
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	DECLARE @UtcTime DATETIME=GETUTCDATE()

	UPDATE CE
	SET	UUID = '',
		Updated = @UtcTime,
		CacheVersion = CacheVersion + 10
	FROM @TasksToUpdate T
		JOIN CodingElements CE 
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
          CodingElementGroupId,
          QueryId
        )
   SELECT CE.CodingElementId, 
		CE.WorkflowStateID, NULL, NULL, -2, NULL, 
		@Comment,
		@UtcTime, 
		CE.SegmentId, 
		NULL,
		CE.CodingElementGroupID,
		0
	FROM @TasksToUpdate T
		JOIN CodingElements CE ON CE.CodingElementId = T.CodingElementId
	
	PRINT 'UUID removal tasks succeeded!'

	SELECT CE.* 
	FROM @TasksToUpdate T
	JOIN CodingElements CE 
	ON CE.CodingElementId = T.CodingElementId
	ORDER BY CE.CodingElementId

	SELECT WFH.*
	FROM @TasksToUpdate T
	JOIN WorkflowTaskHistory WFH on WFH.WorkflowTaskId = T.CodingElementId
	WHERE WFH.Created = @UtcTime
	ORDER BY WFH.WorkflowTaskId
END

