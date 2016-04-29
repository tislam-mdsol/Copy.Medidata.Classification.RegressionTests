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
	@Updated DATETIME OUTPUT
)
AS
BEGIN

    DECLARE @resetCommantType TINYINT = 2
    IF (@CommandType = @resetCommantType)
    BEGIN
        RAISERROR('Reset is no longer supported.', 16, 1)
        RETURN 0
    END

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
     