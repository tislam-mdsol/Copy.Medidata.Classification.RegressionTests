-- add new column to change the order coding decision data is displayed in source
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictionaryLevel'
		 AND COLUMN_NAME = 'SourceOrdinal')
	ALTER TABLE MedicalDictionaryLevel
	ADD SourceOrdinal INT NOT NULL CONSTRAINT DF_MedicalDictionaryLevel_SourceOrdinal DEFAULT (0)
GO
 
-- also, for existing levels update the new source ordinal with the ordinal
UPDATE MedicalDictionaryLevel
SET SourceOrdinal = Ordinal