;WITH CompletedMigrationTraces AS
(
	SELECT 
		MAX(SMT.StudyMigrationTraceId) AS LastTraceId, 
		SMT.StudyDictionaryVersionId,
		SMM_From.DictionaryVersionId AS FromVersionId,
		SMM_To.DictionaryVersionId AS ToVersionId
	FROM StudyMigrationTraces SMT
		JOIN SynonymMigrationMngmt SMM_From
			ON SMM_From.SynonymMigrationMngmtID = SMT.FromSynonymMgmtId
		JOIN SynonymMigrationMngmt SMM_To
			ON SMM_To.SynonymMigrationMngmtID = SMT.ToSynonymMgmtId
	WHERE SMT.CurrentStage = 10
	GROUP BY SMT.StudyDictionaryVersionId,
		SMM_From.DictionaryVersionId,
		SMM_To.DictionaryVersionId
)

UPDATE SDVH
SET SDVH.FromSynonymListId = SMT.FromSynonymMgmtId,
	SDVH.ToSynonymListId = SMT.ToSynonymMgmtId
FROM CompletedMigrationTraces CMT
	JOIN StudyMigrationTraces SMT
		ON CMT.LastTraceId = SMT.StudyMigrationTraceId
	JOIN StudyDictionaryVersionHistory SDVH
		ON SDVH.FromDictionaryVersionId = CMT.FromVersionId
		AND SDVH.ToDictionaryVersionId = CMT.ToVersionId
		AND SDVH.StudyDictionaryVersionId = CMT.StudyDictionaryVersionId

-- delete unresolvable histories
DELETE StudyDictionaryVersionHistory
WHERE FromSynonymListId = 0

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersionHistory_FromDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP CONSTRAINT DF_StudyDictionaryVersionHistory_FromDictionaryVersionId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'FromDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP COLUMN FromDictionaryVersionId
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersionHistory_ToDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP CONSTRAINT DF_StudyDictionaryVersionHistory_ToDictionaryVersionId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'ToDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP COLUMN ToDictionaryVersionId
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_StudyDictionaryVersionHistory_MedicalDictionaryID')
	DROP INDEX StudyDictionaryVersionHistory.IX_StudyDictionaryVersionHistory_MedicalDictionaryID

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'MedicalDictionaryId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP COLUMN MedicalDictionaryId
GO

