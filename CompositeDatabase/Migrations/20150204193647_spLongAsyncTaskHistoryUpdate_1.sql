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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTaskHistoryUpdate')
	DROP PROCEDURE spLongAsyncTaskHistoryUpdate
GO
CREATE PROCEDURE dbo.spLongAsyncTaskHistoryUpdate
(
	@TaskHistoryId INT,
	@TaskId BIGINT,
	@IsFailed BIT,
	@SegmentId INT,
	@CommandType TINYINT,
	
	@TaskLog NVARCHAR(1000),

	@Created DATETIME,
	@Updated DATETIME OUTPUT
)
AS
BEGIN

	SELECT @Updated = GetUtcDate()  

	UPDATE LongAsyncTaskHistory
	SET
		TaskId = @TaskId,
		IsFailed = @IsFailed,
		SegmentId = @SegmentId,
		CommandType = @CommandType,
		
		TaskLog = @TaskLog,
				
		Updated = @Updated
	WHERE TaskHistoryId = @TaskHistoryId
	
END
GO  
      