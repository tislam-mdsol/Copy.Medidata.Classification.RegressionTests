IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingPatterns'
		AND COLUMN_NAME = 'OldCodingPatternId')
BEGIN
	ALTER TABLE CodingPatterns
	DROP COLUMN OldCodingPatternId
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_NewCodingPatterns_VersionId')
BEGIN
	ALTER TABLE CodingPatterns
	DROP CONSTRAINT DF_NewCodingPatterns_VersionId
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingPatterns'
		AND COLUMN_NAME = 'DictionaryVersionId_Backup')
BEGIN
	ALTER TABLE CodingPatterns
	DROP COLUMN DictionaryVersionId_Backup
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_NewCodingPatterns_Locale')
BEGIN
	ALTER TABLE CodingPatterns
	DROP CONSTRAINT DF_NewCodingPatterns_Locale
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingPatterns'
		AND COLUMN_NAME = 'DictionaryLocale_Backup')
BEGIN
	ALTER TABLE CodingPatterns
	DROP COLUMN DictionaryLocale_Backup
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_NewCodingPatterns_LevelId')
BEGIN
	ALTER TABLE CodingPatterns
	DROP CONSTRAINT DF_NewCodingPatterns_LevelId
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingPatterns'
		AND COLUMN_NAME = 'DictionaryLevelId_Backup')
BEGIN
	ALTER TABLE CodingPatterns
	DROP COLUMN DictionaryLevelId_Backup
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_CodingPatterns_MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE CodingPatterns
	DROP CONSTRAINT DF_CodingPatterns_MedicalDictionaryVersionLocaleKey
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingPatterns'
		AND COLUMN_NAME = 'MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE CodingPatterns
	DROP COLUMN MedicalDictionaryVersionLocaleKey
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_CodingPatterns_MedicalDictionaryLevelKey')
BEGIN
	ALTER TABLE CodingPatterns
	DROP CONSTRAINT DF_CodingPatterns_MedicalDictionaryLevelKey
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingPatterns'
		AND COLUMN_NAME = 'MedicalDictionaryLevelKey')
BEGIN
	ALTER TABLE CodingPatterns
	DROP COLUMN MedicalDictionaryLevelKey
END

IF NOT EXISTS (SELECT * FROM sys.indexes
	WHERE NAME = 'UIX_NewCodingPatterns_Multi')
BEGIN
		CREATE UNIQUE NONCLUSTERED INDEX [UIX_NewCodingPatterns_Multi] ON [dbo].[CodingPatterns] 
		(
			CodingPath ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END