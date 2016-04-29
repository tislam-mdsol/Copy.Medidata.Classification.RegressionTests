/* --------------------------------------------------------------------------------------------------
// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author:		Bonnie Pan
// Created:		26 Jun 2014 
// Updated by:	Dan Dapper
// Update date:	17 Feb 2015
//
//
//  Invalidate task(s) by UUID.  @comment argument should be '(WR #)'
// 
-----------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'CMP_InValidateTasksByUUID')
DROP PROCEDURE dbo.CMP_InValidateTasksByUUID
GO


CREATE PROCEDURE dbo.CMP_InValidateTasksByUUID
(
	@segmentName VARCHAR(250),
	@comment NVARCHAR(MAX),
	@commaDelimitedUUIDs NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE  
		@segmentId INT,
		@startId INT,
		@errorString NVARCHAR(MAX)

	SET @comment = 	'TaskInvalidation ' + ISNULL(@Comment, '')

	SELECT @segmentId = SegmentId 
	FROM Segments
	WHERE SegmentName = @segmentName

	IF (@segmentId IS NULL)
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END

	DECLARE @TasksToUpdate TABLE (UUID NVARCHAR(100) PRIMARY KEY, SegmentID INT, CodingElementId INT)
	
	INSERT INTO @TasksToUpdate 
	(
		UUID,
		SegmentId,
		CodingElementId
	)
	SELECT
		item,
		-1,
		-1
	FROM dbo.fnParseDelimitedString(@commaDelimitedUUIDs,',')

	UPDATE
		@TasksToUpdate
	SET
		SegmentId = CE.SegmentId,
		CodingElementId = CE.CodingElementId
	FROM
		@TasksToUpdate t
	INNER JOIN
		CodingElements CE
	ON
		CE.SegmentId = @SegmentId and CE.UUID  = t.UUID

		
	IF EXISTS (SELECT NULL FROM @TasksToUpdate WHERE SegmentId <> @SegmentID)
	BEGIN
		SET @errorString = N'ERROR: UUIDs are not in segment or do not exist!'
		SELECT * FROM @TasksToUpdate WHERE SegmentId <> @SegmentID
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	
	

	DECLARE @UtcTime DATETIME=GETUTCDATE()

	UPDATE CE
	SET	IsInvalidTask = 1,
		IsClosed = 1,
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
	
	PRINT 'Invalidate tasks succeeded!'

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