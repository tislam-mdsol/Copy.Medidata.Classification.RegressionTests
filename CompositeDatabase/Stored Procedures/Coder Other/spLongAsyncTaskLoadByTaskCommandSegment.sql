/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTaskLoadByTaskCommandSegment')
	DROP PROCEDURE spLongAsyncTaskLoadByTaskCommandSegment
GO
CREATE PROCEDURE dbo.spLongAsyncTaskLoadByTaskCommandSegment
(
	@taskType INT, 
	@commandType INT,
	@pageSize INT, 
	@startRowIndex INT, 
	@countOfTotalMatches INT OUTPUT, --Return the total count of matches
	@segmentId INT
)
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @gridTable TABLE(
		TaskId INT,
		ReferenceId BIGINT,
		IsComplete BIT,
		IsFailed BIT,
		SegmentId INT,
		LongAsyncTaskType TINYINT,
		CommandType TINYINT,
		OngoingTaskHistoryId BIGINT,
		CacheVersion BIGINT,
		EarliestAllowedStartTime DATETIME,
		Created DATETIME,
		Updated DATETIME,
		TotalTasks INT
	)
	
	;WITH SQLPaging
	AS
	(
		SELECT *
		FROM LongAsyncTasks
		WHERE @taskType IN (0, LongAsyncTaskType)
			AND @commandType IN (0, CommandType)
			AND @segmentId IN (0, SegmentId)
			AND (IsComplete = 0 OR IsFailed = 1)
	)
	
	INSERT INTO @gridTable
	(
		TaskId,
		ReferenceId,
		IsComplete,
		IsFailed,
		SegmentId,
		LongAsyncTaskType,
		CommandType,
		OngoingTaskHistoryId,
		CacheVersion,
		EarliestAllowedStartTime,
		Created,
		Updated,
		TotalTasks
	)
	SELECT 
		TaskId,
		ReferenceId,
		IsComplete,
		IsFailed,
		SegmentId,
		LongAsyncTaskType,
		CommandType,
		OngoingTaskHistoryId,
		CacheVersion,
		EarliestAllowedStartTime,
		Created,
		Updated,
		-1	
	FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY TS.TaskId) AS Row, TS.* 
			FROM SQLPaging TS
		) AS Y
	WHERE Row BETWEEN (@startRowIndex + 1) AND (@startRowIndex + @PageSize)
	UNION
	SELECT 
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		COUNT(*)
	FROM SQLPaging
	
	SELECT @countOfTotalMatches = TotalTasks
	FROM @gridTable
	WHERE TotalTasks > -1
	
	SELECT * FROM @gridTable
	WHERE TotalTasks = -1
	
GO  
   