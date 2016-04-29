IF EXISTS 
	(SELECT NULL FROM sys.default_constraints WHERE NAME = 'DF_CodingElementGroups_MedicalDictionaryKey')
BEGIN
	ALTER TABLE CodingElementGroups
	DROP CONSTRAINT DF_CodingElementGroups_MedicalDictionaryKey
END
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
		 AND COLUMN_NAME = 'MedicalDictionaryKey')
BEGIN
	ALTER TABLE CodingElementGroups
	DROP COLUMN MedicalDictionaryKey
END
GO