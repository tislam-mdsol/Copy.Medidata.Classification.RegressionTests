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
      