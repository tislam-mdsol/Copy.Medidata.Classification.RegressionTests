IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'StudyDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	ADD StudyDictionaryVersionId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersionHistory_StudyDictionaryVersionId DEFAULT (0)
GO