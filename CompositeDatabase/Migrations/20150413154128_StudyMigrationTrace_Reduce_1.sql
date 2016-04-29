IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationTraces'
		 AND COLUMN_NAME = 'FromVersionId')
	ALTER TABLE StudyMigrationTraces
	DROP COLUMN FromVersionId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationTraces'
		 AND COLUMN_NAME = 'ToVersionId')
	ALTER TABLE StudyMigrationTraces
	DROP COLUMN ToVersionId
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'FromSynonymListId')
	ALTER TABLE StudyDictionaryVersionHistory
	ADD FromSynonymListId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersionHistory_FromSynonymListId DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'ToSynonymListId')
	ALTER TABLE StudyDictionaryVersionHistory
	ADD ToSynonymListId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersionHistory_ToSynonymListId DEFAULT (0)
GO
