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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTaskUpdate')
	DROP PROCEDURE spLongAsyncTaskUpdate
GO
CREATE PROCEDURE dbo.spLongAsyncTaskUpdate
(
	@TaskId INT,
	@ReferenceId BIGINT,
	@IsComplete BIT,
	@IsFailed BIT,
	@SegmentId INT,
	@LongAsyncTaskType TINYINT,
	@CommandType TINYINT,
	@OngoingTaskHistoryId BIGINT,
	@EarliestAllowedStartTime DATETIME,

	@Created DATETIME,
	@Updated DATETIME OUTPUT
)
AS
BEGIN

	SELECT @Updated = GetUtcDate()  

	UPDATE LongAsyncTasks
	SET
		ReferenceId = @ReferenceId,
		IsComplete = @IsComplete,
		IsFailed = @IsFailed,
		SegmentId = @SegmentId,
		LongAsyncTaskType = @LongAsyncTaskType,
		CommandType = @CommandType,
		OngoingTaskHistoryId = @OngoingTaskHistoryId,

		EarliestAllowedStartTime = @EarliestAllowedStartTime,
				
		Updated = @Updated
	WHERE TaskId = @TaskId
		
	
END
GO  
     