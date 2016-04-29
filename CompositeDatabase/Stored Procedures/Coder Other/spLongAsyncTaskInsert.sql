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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTaskInsert')
	DROP PROCEDURE spLongAsyncTaskInsert
GO
CREATE PROCEDURE dbo.spLongAsyncTaskInsert
(
	@ReferenceId BIGINT,
	@IsComplete BIT,
	@IsFailed BIT,
	@SegmentId INT,
	@LongAsyncTaskType TINYINT,
	@CommandType TINYINT,
	@OngoingTaskHistoryId BIGINT,
	
	@EarliestAllowedStartTime DATETIME,

	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@TaskId INT OUTPUT
)
AS
BEGIN

	DECLARE @UtcDate DATETIME  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO LongAsyncTasks (  
		ReferenceId,
		IsComplete,
		IsFailed,
		SegmentId,
		LongAsyncTaskType,
		CommandType,
		OngoingTaskHistoryId,
		
		EarliestAllowedStartTime,
				
		Created,
		Updated
	) VALUES (  
		@ReferenceId,
		@IsComplete,
		@IsFailed,
		@SegmentId,
		@LongAsyncTaskType,
		@CommandType,
		@OngoingTaskHistoryId,
		
		@EarliestAllowedStartTime,
	
		@Created,
		@Updated
	)  
	
	SET @TaskId = SCOPE_IDENTITY()  	

END
GO  
    