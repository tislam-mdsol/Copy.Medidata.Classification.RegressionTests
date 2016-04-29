
IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
		 AND COLUMN_NAME = 'DictionaryID')
	ALTER TABLE ProjectDictionaryRegistrations
	DROP COLUMN DictionaryID
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_ProjectDictionaryRegistrations_DictionaryLocale')
	ALTER TABLE ProjectDictionaryRegistrations
	DROP CONSTRAINT DF_ProjectDictionaryRegistrations_DictionaryLocale
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
		 AND COLUMN_NAME = 'DictionaryLocale')
	ALTER TABLE ProjectDictionaryRegistrations
	DROP COLUMN DictionaryLocale
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_ProjectDictionaryRegistrations_DictionaryVersionId')
	ALTER TABLE ProjectDictionaryRegistrations
	DROP CONSTRAINT DF_ProjectDictionaryRegistrations_DictionaryVersionId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE ProjectDictionaryRegistrations
	DROP COLUMN DictionaryVersionId
