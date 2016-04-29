IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SynonymMigrationMngmt_MedicalDictionaryID')
	DROP INDEX SynonymMigrationMngmt.IX_SynonymMigrationMngmt_MedicalDictionaryID 
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		 AND COLUMN_NAME = 'MedicalDictionaryID')
	ALTER TABLE SynonymMigrationMngmt
	DROP COLUMN MedicalDictionaryID
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersion_InitialDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersion
	DROP CONSTRAINT DF_StudyDictionaryVersion_InitialDictionaryVersionId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'InitialDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersion
	DROP COLUMN InitialDictionaryVersionId
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'FromDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	ADD FromDictionaryVersionId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersionHistory_FromDictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'ToDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	ADD ToDictionaryVersionId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersionHistory_ToDictionaryVersionId DEFAULT (0)
GO