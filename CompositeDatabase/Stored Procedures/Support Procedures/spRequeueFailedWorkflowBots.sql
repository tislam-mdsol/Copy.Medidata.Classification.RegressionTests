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

-- exec spRequeueFailedWorkflowBots

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRequeueFailedWorkflowBots')
	DROP PROCEDURE spRequeueFailedWorkflowBots
GO
CREATE PROCEDURE dbo.spRequeueFailedWorkflowBots
(
	@MaxHistory INT = 10,
	@TaskType TINYINT = 6 -- default to workflowBOT
)
AS
BEGIN

	DECLARE @runCommandType TINYINT = 1,
		@rerunCommandType TINYINT = 3

	;WITH failedBOTs 
	AS
	(
		SELECT TaskId, MIN(CommandType) AS MinCommand, MAX(CommandType) AS MaxCommand, MAX(RowNum) AS MaxRow
		FROM
		(
			SELECT
				LAT.TaskId,
				LATH.CommandType,
				ROW_NUMBER() OVER (PARTITION BY LATH.TaskId ORDER BY TaskHistoryId DESC) AS RowNum
			FROM LongAsyncTasks LAT
				CROSS APPLY
				( 
					SELECT TOP (@MaxHistory) *
					FROM LongAsyncTaskHistory LATH_INT
					WHERE LAT.TaskId = LATH_INT.TaskId
					ORDER BY LATH_INT.TaskHistoryId DESC
				) AS LATH
			WHERE LAT.LongAsyncTaskType = @TaskType
				AND LAT.IsFailed = 1
				AND LAT.IsComplete = 0
		) AS InnerSet
		GROUP BY TaskId
	)

	UPDATE LAT
	-- as per Medidata.Coder.AutomationActivities.LongAsyncJobManager.ReQueue()
	SET LAT.CommandType = @rerunCommandType, LAT.IsFailed = 0, LAT.IsComplete = 0
	FROM failedBOTs FB
		JOIN LongAsyncTasks LAT
			ON LAT.TaskId = FB.TaskId
	WHERE FB.MaxRow < @MaxHistory
		-- variance in command type indicates less than @MaxHistory of (Re)Run only attempts
		OR FB.MinCommand <> LAT.CommandType
		OR FB.MaxCommand <> LAT.CommandType

END
GO 

