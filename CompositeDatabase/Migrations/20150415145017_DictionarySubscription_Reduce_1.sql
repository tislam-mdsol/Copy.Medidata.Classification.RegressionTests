IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE DictionaryVersionSubscriptions
	ADD DictionaryVersionId INT NOT NULL CONSTRAINT DF_DictionaryVersionSubscriptions_DictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'DictionaryLocale')
	ALTER TABLE DictionaryVersionSubscriptions
	ADD DictionaryLocale CHAR(3) NOT NULL CONSTRAINT DF_DictionaryVersionSubscriptions_DictionaryLocale DEFAULT ('')
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'SegmentId')
	ALTER TABLE DictionaryVersionSubscriptions
	ADD SegmentId INT NOT NULL CONSTRAINT DF_DictionaryVersionSubscriptions_SegmentId DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'DictionaryLicenceInformationId')
	ALTER TABLE DictionaryVersionSubscriptions
	ADD DictionaryLicenceInformationId INT NOT NULL CONSTRAINT DF_DictionaryVersionSubscriptions_DictionaryLicenceInformationId DEFAULT (0)
GO