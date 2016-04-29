IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictVerLocaleStatus'
		 AND COLUMN_NAME = 'ReleaseDate')
	ALTER TABLE MedicalDictVerLocaleStatus
	ADD ReleaseDate Datetime NOT NULL CONSTRAINT DF_MedicalDictVerLocaleStatus_ReleaseDate DEFAULT ((GetUTCDate()))
GO

IF EXISTS
	(SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_MedicalDictVerLocaleStatus_ReleaseDate')
	ALTER TABLE MedicalDictVerLocaleStatus
	DROP CONSTRAINT DF_MedicalDictVerLocaleStatus_ReleaseDate
GO