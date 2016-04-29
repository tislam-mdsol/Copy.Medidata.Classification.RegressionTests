IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionarySegmentConfigurations'
		 AND COLUMN_NAME = 'MedicalDictionaryKey')
BEGIN
	ALTER TABLE DictionarySegmentConfigurations
	ADD MedicalDictionaryKey NVARCHAR(100) NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_MedicalDictionaryKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryLicenceInformations'
		 AND COLUMN_NAME = 'MedicalDictionaryKey')
BEGIN
	ALTER TABLE DictionaryLicenceInformations
	ADD MedicalDictionaryKey NVARCHAR(100) NOT NULL CONSTRAINT DF_DictionaryLicenceInformations_MedicalDictionaryKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
		 AND COLUMN_NAME = 'MedicalDictionaryKey')
BEGIN
	ALTER TABLE CodingElementGroups
	ADD MedicalDictionaryKey NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElementGroups_MedicalDictionaryKey DEFAULT ('')
END
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserObjectRole'
		 AND COLUMN_NAME = 'GrantOnObjectKey')
BEGIN
	ALTER TABLE UserObjectRole
	ADD GrantOnObjectKey NVARCHAR(100) NOT NULL CONSTRAINT DF_UserObjectRole_GrantOnObjectKey DEFAULT ('')
END
GO
