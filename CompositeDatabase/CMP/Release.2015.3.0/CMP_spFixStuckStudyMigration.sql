-- Background :
-- This CMP fixes an issue with study migration "reset" functionality, 
-- Given a study migration which has failed (regardless of cause), there is an option 
-- to reset the study to a not in migration status. Reset is supposed to reset each
-- and every task of the study back to the original version.  The current reset bug
-- however, does not revert the migrated tasks back to the original version - instead those
-- tasks remain to all purposes still migrated.
-- Once the study is requeued again for migration, study migration is unable to process
-- the already migrated tasks - and will therefore fail.
-- This CMP will mark the already migrated tasks as migrated - which will allow study migration
-- to proceed.

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFixStuckStudyMigration')
	DROP PROCEDURE spFixStuckStudyMigration
GO

-- EXEC spFixStuckStudyMigration 1969, 'AZDD-15_1-English', 'AZDD-15_2-English'

CREATE PROCEDURE dbo.spFixStuckStudyMigration
(
    @StudyMigrationTraceID INT,
	@FromVersion NVARCHAR(500),
	@ToVersion NVARCHAR(500)
)
AS
BEGIN

	DECLARE @studyDictionaryVersionId INT,
		@toSynonymListId INT

	SELECT @studyDictionaryVersionId = SMT.StudyDictionaryVersionId,
		@toSynonymListId = SMT.ToSynonymMgmtId
	FROM StudyMigrationTraces SMT
		JOIN SynonymMigrationMngmt SMM_FROM
			ON SMT.FromSynonymMgmtId = SMM_FROM.SynonymMigrationMngmtID
		JOIN SynonymMigrationMngmt SMM_TO
			ON SMT.ToSynonymMgmtId = SMM_TO.SynonymMigrationMngmtID
	WHERE StudyMigrationTraceId = @StudyMigrationTraceID
		AND SMM_FROM.MedicalDictionaryVersionLocaleKey = @FromVersion
		AND SMM_TO.MedicalDictionaryVersionLocaleKey = @ToVersion

	IF (@studyDictionaryVersionId IS NULL)
	BEGIN
		RAISERROR('Cannot find migration', 1, 15)
		RETURN 0
	END

	DECLARE @transmissionMessage NVARCHAR(100) = N'Transmission Queue Number:'
	DECLARE @migrationMessage NVARCHAR(1000) = N'Version Change - From '+@FromVersion+' To '+@ToVersion

	DECLARE @affectedTasks TABLE(CodingElementId BIGINT PRIMARY KEY, isMigratedSynonym BIT, isMigratedAssignment BIT)

	;WITH migratedTasks AS
	(
		SELECT *
		FROM CodingElements CE
			CROSS APPLY
			(
				SELECT TOP 1 WTH.Comment
				FROM WorkflowTaskHistory WTH
				WHERE WTH.WorkflowTaskID = CE.CodingElementId
                    AND CHARINDEX(@transmissionMessage, WTH.Comment) <> 1 -- ignore transmissions
				ORDER BY WorkflowTaskHistoryId DESC
			) AS MLog
		WHERE CE.StudyDictionaryVersionId = @studyDictionaryVersionId
			AND CHARINDEX(@migrationMessage, MLog.Comment) = 1 -- capture all migration comments
	),
	migratedSynonyms AS
	(
		SELECT 
			CASE WHEN ISNULL(SGCP.SynonymManagementID, @toSynonymListId) = @toSynonymListId THEN 1
				ELSE 0
			END AS isMigratedSynonym,
			mt.*
		FROM migratedTasks mt
			LEFT JOIN SegmentedGroupCodingPatterns SGCP
				ON mt.AssignedSegmentedGroupCodingPatternId = SGCP.SegmentedGroupCodingPatternID
	),
	migratedAssignment AS
	(
		SELECT 
			CASE WHEN MLog.CA_SegmentedGroupCodingPatternID = ms.AssignedSegmentedGroupCodingPatternId THEN 1
				ELSE 0
			END AS isMigratedAssignment,
			ms.*
		FROM migratedSynonyms ms
			CROSS APPLY
			(
				SELECT ISNULL(MAX(SegmentedGroupCodingPatternID), -1) AS CA_SegmentedGroupCodingPatternID
				FROM
				(
					SELECT TOP 1 CA.SegmentedGroupCodingPatternID
					FROM CodingAssignment CA
					WHERE CA.CodingElementId = ms.CodingElementId
						AND ms.AssignedSegmentedGroupCodingPatternId > 0
					ORDER BY CodingAssignmentId DESC
				) AS M
			) AS MLog
	)

	INSERT INTO @affectedTasks(CodingElementId, isMigratedSynonym, isMigratedAssignment)
	SELECT 
		MA.CodingElementId,
		MA.isMigratedSynonym,
		MA.isMigratedAssignment
	FROM migratedAssignment MA

	-- if there's inconsistencies in migration - abort this procedure!
	IF EXISTS (SELECT NULL
		FROM @affectedTasks
		WHERE isMigratedSynonym = 0
			OR isMigratedAssignment = 0)
	BEGIN
		RAISERROR('Inconsistencies in migration data - cannot proceed with this simple procedure!', 1, 15)
		RETURN 0
	END

	UPDATE SMB
	SET SMB.MigrationChangeType = 1 -- unable to ascertain the correct change type
	FROM @affectedTasks MA
		JOIN StudyMigrationBackup SMB
			ON SMB.CodingElementID = MA.CodingElementId
			AND SMB.StudyDictionaryVersionId = @studyDictionaryVersionId
	WHERE SMB.MigrationChangeType = -1

END 
