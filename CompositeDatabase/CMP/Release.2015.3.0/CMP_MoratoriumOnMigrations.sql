/* ------------------------------------------------------------------------------------------------------
// Place a block on the following long running tasks:
//
// Study Migration    : LongAsyncType = 1
// Synonym Migration  : LongAsyncType = 2
// Synonym Load       : LongAsyncType = 4
// 
// Once executed, no new tasks (listed above) can be queued.  Existing ones will be allowed
// to proceed to conclusion, or reset back.
// Again this only blocks new tasks from being queued - it does not affect existing (already queued)
// tasks
//
// This is done by dis-allowing new LongAsyncTasks from being created for the listed task types
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

	DECLARE @studyMigrationType   INT = 1
	DECLARE @synonymMigrationType INT = 2
	DECLARE @synonymLoadType      INT = 4

	IF (@LongAsyncTaskType IN (@studyMigrationType, @synonymMigrationType, @synonymLoadType))
	BEGIN
		-- Error here
		DECLARE @errorMessage NVARCHAR(500) =
			N'Due to the upcoming new Coder Release, the following features are not available until after the release is deployed:
			1) Study Migration
			2) Synonym Migration
			3) Synonym Load'

		RAISERROR(@errorMessage, 16, 1)
		RETURN 1
	END

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
    
