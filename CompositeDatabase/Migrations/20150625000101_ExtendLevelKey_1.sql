IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'MedicalDictionaryLevelKey')
BEGIN
	ALTER TABLE CodingElements
	ADD MedicalDictionaryLevelKey NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElements_MedicalDictionaryLevelKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
		 AND COLUMN_NAME = 'MedicalDictionaryLevelKey')
BEGIN
	ALTER TABLE CodingElementGroups
	ADD MedicalDictionaryLevelKey NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElementGroups_MedicalDictionaryLevelKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 AND COLUMN_NAME = 'MedicalDictionaryLevelKey')
BEGIN
	ALTER TABLE CodingPatterns
	ADD MedicalDictionaryLevelKey NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingPatterns_MedicalDictionaryLevelKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		 AND COLUMN_NAME = 'MedicalDictionaryLevelKey')
BEGIN
	ALTER TABLE DoNotAutoCodeTerms
	ADD MedicalDictionaryLevelKey NVARCHAR(100) NOT NULL CONSTRAINT DF_DoNotAutoCodeTerms_MedicalDictionaryLevelKey DEFAULT ('')
END
GO
