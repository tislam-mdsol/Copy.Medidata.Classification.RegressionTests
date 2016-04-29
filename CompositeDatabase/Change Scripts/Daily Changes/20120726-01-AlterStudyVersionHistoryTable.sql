
-- Add new columns to keep track of new study migration categories

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'FutureVersionAutomation')
	ALTER TABLE StudyDictionaryVersionHistory
	ADD FutureVersionAutomation INT NOT NULL DEFAULT 0
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'BetterDictionaryMatch')
	ALTER TABLE StudyDictionaryVersionHistory
	ADD BetterDictionaryMatch INT NOT NULL DEFAULT 0
GO
