-- Add MedicalDictionaryType to MedicalDictionary
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictionary'
		 AND COLUMN_NAME = 'MedicalDictionaryType')
	ALTER TABLE MedicalDictionary
	ADD MedicalDictionaryType VARCHAR(50)
GO 