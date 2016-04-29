IF EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSFailStuckStudyMigration')
	DROP PROCEDURE dbo.spPSFailStuckStudyMigration
GO

-- EXEC spPSFailStuckStudyMigration 'Declare','552'

CREATE PROCEDURE [dbo].[spPSFailStuckStudyMigration]
(
	@SegmentOid NVARCHAR(400),
	@AsyncTaskReferenceId BIGINT
)
AS
BEGIN

	DECLARE @AsyncTaskId BIGINT

	SELECT TOP 1 @AsyncTaskId = t.TaskId 
		FROM LongAsyncTasks t
		JOIN Segments s ON 
			t.SegmentId = s.SegmentId
			AND s.OID = @SegmentOid
		WHERE 
			t.IsComplete = 0
			AND t.IsFailed = 0
			AND t.ReferenceId = @AsyncTaskReferenceId
		ORDER BY t.TaskId DESC

	IF (@AsyncTaskId IS NULL)
	BEGIN
		PRINT 'Async Task not found for segment oid'
		RETURN 0
	END


	DECLARE @LastTaskHistoryId BIGINT

	SELECT TOP (1) @LastTaskHistoryId = TaskHistoryId
	FROM LongAsyncTaskHistory
	WHERE TaskId = @AsyncTaskId
	ORDER BY TaskHistoryId DESC

	IF (@LastTaskHistoryId IS NULL)
	BEGIN
		PRINT 'Last task history record NOT FOUND'
		RETURN 0
	END

	UPDATE LongAsyncTasks
	SET OngoingTaskHistoryId = -1,
		IsFailed = 1
	WHERE TaskID = @AsyncTaskId

	UPDATE LongAsyncTaskHistory
	SET TaskLog = 'Manualy marked as failed via [spPSFailStuckStudyMigration]',
		IsFailed = 1
	WHERE TaskHistoryId = @LastTaskHistoryId
 
END