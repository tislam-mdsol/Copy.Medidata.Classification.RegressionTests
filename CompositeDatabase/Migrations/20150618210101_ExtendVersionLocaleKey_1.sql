IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		 AND COLUMN_NAME = 'MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE SynonymMigrationMngmt
	ADD MedicalDictionaryVersionLocaleKey NVARCHAR(100) NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_MedicalDictionaryVersionLocaleKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE DictionaryVersionSubscriptions
	ADD MedicalDictionaryVersionLocaleKey NVARCHAR(100) NOT NULL CONSTRAINT DF_DictionaryVersionSubscriptions_MedicalDictionaryVersionLocaleKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 AND COLUMN_NAME = 'MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE CodingPatterns
	ADD MedicalDictionaryVersionLocaleKey NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingPatterns_MedicalDictionaryVersionLocaleKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		 AND COLUMN_NAME = 'MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE DoNotAutoCodeTerms
	ADD MedicalDictionaryVersionLocaleKey NVARCHAR(100) NOT NULL CONSTRAINT DF_DoNotAutoCodeTerms_MedicalDictionaryVersionLocaleKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationBackup'
		 AND COLUMN_NAME = 'MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE StudyMigrationBackup
	ADD MedicalDictionaryVersionLocaleKey NVARCHAR(100) NOT NULL CONSTRAINT DF_StudyMigrationBackup_MedicalDictionaryVersionLocaleKey DEFAULT ('')
END
GO