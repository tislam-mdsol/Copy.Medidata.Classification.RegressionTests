IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_PurgeMidwaySynonymMigrations')
	DROP PROCEDURE CMP_PurgeMidwaySynonymMigrations
GO

CREATE PROCEDURE dbo.CMP_PurgeMidwaySynonymMigrations
(
	@userConfirmation VARCHAR(10) = 'NotOK'
)
AS
BEGIN
	
	-- Verify users confirms
	IF (@userConfirmation <> 'OK')
	BEGIN
		RAISERROR('Failed confirmation', 16, 1)
		RETURN 1
	END

	-- purge the following tables
	TRUNCATE TABLE SynonymMigrationSuggestions

	IF EXISTS (SELECT NULL FROM sys.foreign_keys 
	WHERE object_id = OBJECT_ID(N'FK_SynonymMigrationSuggestions_SynonymMigrationEntries'))
	BEGIN
		ALTER TABLE SynonymMigrationSuggestions
		DROP CONSTRAINT FK_SynonymMigrationSuggestions_SynonymMigrationEntries
	END

	TRUNCATE TABLE SynonymMigrationEntries

	DECLARE @synonymListIds TABLE(Id INT)

	INSERT INTO @synonymListIds
	SELECT SynonymMigrationMngmtID
	FROM SynonymMigrationMngmt
	WHERE SynonymMigrationStatusRID IN (2, 3, 4, 5)

	DECLARE @ongoingTasks TABLE(Id INT, SegmentId INT)

	INSERT INTO @ongoingTasks (Id, SegmentId)
	SELECT LAT.TaskId, LAT.SegmentId
	FROM LongAsyncTasks LAT
		JOIN @synonymListIds S
			ON LAT.ReferenceId = S.Id
	WHERE LAT.LongAsyncTaskType IN (2, 3)
		AND LAT.IsComplete = 0

	-- complete these tasks
	INSERT INTO LongAsyncTaskHistory (TaskId, IsFailed, TaskLog, SegmentId, CommandType, Created, Updated)
	SELECT Id, 1, 'Resetting Synonym Migrations due to Coder Release', SegmentId, 1, GETUTCDATE(), GETUTCDATE()
	FROM @ongoingTasks T

	UPDATE LAT
	SET LAT.IsComplete           = 1,
		LAT.IsFailed             = 1,
		LAT.OngoingTaskHistoryId = 1,
		LAT.CacheVersion         = LAT.CacheVersion + 2
	FROM LongAsyncTasks LAT
		JOIN @ongoingTasks T
			ON LAT.TaskId        = T.Id
 
	-- reset the synonym lists back to not started
	UPDATE SMM
	SET 
		SynonymMigrationStatusRID          = 1,
		IsSynonymListLoadedFromFile        = 0,
		MigrationUserId                    = 0,
		ActivationUserId                   = 0,
		MigrationOrLoadStartDate           = NULL,
		MigrationOrLoadEndDate             = NULL,
		ActivationDate                     = NULL,
		FromSynonymListId                  = -1,
		MigratingToIds                     = ''
	FROM SynonymMigrationMngmt SMM
		JOIN @synonymListIds S
			ON SMM.SynonymMigrationMngmtID = S.Id
	
END 

