IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_CheckMidwayStudyMigrations')
	DROP PROCEDURE CMP_CheckMidwayStudyMigrations
GO

CREATE PROCEDURE dbo.CMP_CheckMidwayStudyMigrations

AS
BEGIN

	DECLARE @runningStudyMigrationCount INT

	SELECT @runningStudyMigrationCount = COUNT(1) 
	FROM StudyMigrationTraces SMT
		JOIN LongAsyncTasks LAT
			ON SMT.StudyMigrationTraceId = LAT.ReferenceId
	WHERE SMT.CurrentStage < 10
		AND LAT.IsComplete <> 1
	

	SELECT 'There are ongoing study Migrations : ', @runningStudyMigrationCount

END