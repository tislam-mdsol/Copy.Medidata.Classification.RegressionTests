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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTaskHistoryInsert')
	DROP PROCEDURE spLongAsyncTaskHistoryInsert
GO
CREATE PROCEDURE dbo.spLongAsyncTaskHistoryInsert
(
	@TaskId BIGINT,
	@IsFailed BIT,
	@SegmentId INT,
	@CommandType TINYINT,
	
	@TaskLog NVARCHAR(1000),

	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@TaskHistoryId INT OUTPUT
)
AS
BEGIN

	DECLARE @UtcDate DATETIME  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO LongAsyncTaskHistory (  
		TaskId,
		IsFailed,
		SegmentId,
		CommandType,
		
		TaskLog,
				
		Created,
		Updated
	) VALUES (  
		@TaskId,
		@IsFailed,
		@SegmentId,
		@CommandType,
		
		@TaskLog,
	
		@Created,
		@Updated
	)  
	
	SET @TaskHistoryId = SCOPE_IDENTITY()  	

END
GO  
    