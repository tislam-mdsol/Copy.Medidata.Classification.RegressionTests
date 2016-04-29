IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_StudyDictionaryVersion_MedicalDictionaryID')
	DROP INDEX StudyDictionaryVersion.IX_StudyDictionaryVersion_MedicalDictionaryID 
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'MedicalDictionaryID')
	ALTER TABLE StudyDictionaryVersion
	DROP COLUMN MedicalDictionaryID
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersion_DictionaryLocale')
	ALTER TABLE StudyDictionaryVersion
	DROP CONSTRAINT DF_StudyDictionaryVersion_DictionaryLocale
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'DictionaryLocale')
	ALTER TABLE StudyDictionaryVersion
	DROP COLUMN DictionaryLocale
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersion_DictionaryVersionId')
	ALTER TABLE StudyDictionaryVersion
	DROP CONSTRAINT DF_StudyDictionaryVersion_DictionaryVersionId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE StudyDictionaryVersion
	DROP COLUMN DictionaryVersionId
GO
