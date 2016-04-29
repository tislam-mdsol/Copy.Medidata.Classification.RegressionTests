IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionarySegmentConfigurations'
		 AND COLUMN_NAME = 'DefaultSuggestThreshold')
BEGIN
	ALTER TABLE DictionarySegmentConfigurations
	DROP CONSTRAINT DF_DictionarySegmentConfigurations_DefaultSuggestThreshold
	ALTER TABLE DictionarySegmentConfigurations
	DROP COLUMN DefaultSuggestThreshold
END
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionarySegmentConfigurations'
		 AND COLUMN_NAME = 'DefaultSelectThreshold')
BEGIN
    ALTER TABLE DictionarySegmentConfigurations
	DROP CONSTRAINT DF_DictionarySegmentConfigurations_DefaultSelectThreshold
	ALTER TABLE DictionarySegmentConfigurations
	DROP COLUMN DefaultSelectThreshold
END
GO