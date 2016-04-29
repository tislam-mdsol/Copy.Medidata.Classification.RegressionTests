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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTasksDequeueMax')
	DROP PROCEDURE spLongAsyncTasksDequeueMax
GO
CREATE PROCEDURE dbo.spLongAsyncTasksDequeueMax
(
	@maxTasks INT,
	@taskTypes VARCHAR(MAX)
)
AS

	DECLARE @timeNow DATETIME = GETUTCDATE()

	DECLARE @allowedTypes TABLE(TypeId TINYINT PRIMARY KEY)
	
	INSERT INTO @allowedTypes
	SELECT * FROM dbo.fnParseDelimitedString(@taskTypes, ',')
	
	SELECT TOP (@maxTasks) *
	FROM LongAsyncTasks
	WHERE LongAsyncTaskType IN (SELECT * FROM @allowedTypes)
		-- is not done & startable
		AND IsComplete = 0 AND IsFailed = 0
		AND ISNULL(EarliestAllowedStartTime, @timeNow) <= @timeNow
		AND OngoingTaskHistoryId < 1
	ORDER BY TaskId ASC
	
GO  
