/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

-- spLongAsyncTaskLoadZombies 50, 30, '6,1'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTaskLoadZombies')
	DROP PROCEDURE spLongAsyncTaskLoadZombies
GO
CREATE PROCEDURE dbo.spLongAsyncTaskLoadZombies
(
	@MaxItems INT,
	@HourThreshold INT,
	@taskTypes VARCHAR(MAX)
)
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @allowedTypes TABLE(TypeId TINYINT PRIMARY KEY)
	
	INSERT INTO @allowedTypes
	SELECT * FROM dbo.fnParseDelimitedString(@taskTypes, ',')

	-- put a long interval here so as not to interrupt/mess a task which is occurring
	DECLARE @thresholdTime DATETIME = DATEADD(HOUR, -@HourThreshold, GETUTCDATE())

	SELECT TOP (@MaxItems) LAT.*
	FROM LongAsyncTasks LAT
		CROSS APPLY
		(
			SELECT Id = MAX(TaskHistoryId)
			FROM LongAsyncTaskHistory
			WHERE TaskId = LAT.TaskId
		) AS LastHistory
	WHERE 
		-- only allowed types
		LongAsyncTaskType IN (SELECT * FROM @allowedTypes)
		-- make sure it's not complete or failed
		AND IsComplete = 0 AND IsFailed = 0
		-- make sure there has been absolutely NO activity after the threshold time
		AND LAT.Updated < @thresholdTime
	ORDER BY LAT.TaskId ASC

END
GO