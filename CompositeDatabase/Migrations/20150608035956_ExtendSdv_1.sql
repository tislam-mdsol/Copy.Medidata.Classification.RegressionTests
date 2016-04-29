IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'RegistrationName')
	ALTER TABLE StudyDictionaryVersion
	ADD RegistrationName NVARCHAR(100) NOT NULL CONSTRAINT DF_StudyDictionaryVersion_RegistrationName DEFAULT ('')
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
		 AND COLUMN_NAME = 'RegistrationName')
	ALTER TABLE ProjectDictionaryRegistrations
	ADD RegistrationName NVARCHAR(100) NOT NULL CONSTRAINT DF_ProjectDictionaryRegistrations_RegistrationName DEFAULT ('')
GO

DECLARE @dictionaryOid VARCHAR(50)

DECLARE @t TABLE(versionId INT PRIMARY KEY, dictionaryid INT, dictionaryOid VARCHAR(50), versionOid VARCHAR(50))

INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid)
EXECUTE spGetDictionaryAndVersions

UPDATE PR
SET PR.RegistrationName = t.dictionaryOid
FROM ProjectDictionaryRegistrations PR
	JOIN SynonymMigrationMngmt SMM
		ON PR.SynonymManagementID = SMM.SynonymMigrationMngmtID
	JOIN @t t
		ON t.versionId = SMM.DictionaryVersionId
WHERE PR.RegistrationName = ''

UPDATE SDV
SET SDV.RegistrationName = t.dictionaryOid
FROM StudyDictionaryVersion SDV
	JOIN SynonymMigrationMngmt SMM
		ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
	JOIN @t t
		ON t.versionId = SMM.DictionaryVersionId
WHERE SDV.RegistrationName = ''