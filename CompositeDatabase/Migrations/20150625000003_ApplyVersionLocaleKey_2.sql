IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnTempMigrateLogic')
	DROP FUNCTION dbo.fnTempMigrateLogic
GO
CREATE FUNCTION dbo.fnTempMigrateLogic
(
	@DictionaryVersionKey NVARCHAR(100),
	@Locale NVARCHAR(100)
) RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN @DictionaryVersionKey+'-'+@Locale
END
GO

DECLARE @t TABLE(
	versionId INT PRIMARY KEY, 
	dictionaryid INT, 
	dictionaryOid VARCHAR(50), 
	versionOid VARCHAR(50), 
	dictionaryKey NVARCHAR(100),
	dictionaryVersionKey NVARCHAR(100))

INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid, dictionaryKey, dictionaryVersionKey)
EXECUTE spGetDictionaryAndVersions

DECLARE @locales TABLE(oldLocale CHAR(3) PRIMARY KEY, newLocale VARCHAR(20))
INSERT INTO @locales (oldLocale, newLocale)
VALUES('eng', 'English'),
	('jpn', 'Japanese')


UPDATE SMM
SET SMM.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryVersionKey, j.newLocale)
FROM SynonymMigrationMngmt SMM
	JOIN @t t
		ON t.versionId = SMM.DictionaryVersionId_Backup
	JOIN @locales j
		on j.oldLocale = SMM.DictionaryLocale_Backup

UPDATE DVS
SET DVS.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryVersionKey, j.newLocale)
FROM DictionaryVersionSubscriptions DVS
	JOIN @t t
		ON t.versionId = DVS.DictionaryVersionId_Backup
	JOIN @locales j
		on j.oldLocale = DVS.DictionaryLocale_Backup

UPDATE CP
SET CP.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryVersionKey, j.newLocale)
FROM CodingPatterns CP
	JOIN @t t
		ON t.versionId = CP.DictionaryVersionId_Backup
	JOIN @locales j
		on j.oldLocale = CP.DictionaryLocale_Backup

UPDATE DNA
SET DNA.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryVersionKey, j.newLocale)
FROM DoNotAutoCodeTerms DNA
	JOIN @t t
		ON t.versionId = DNA.DictionaryVersionId_Backup
	JOIN @locales j
		on j.oldLocale = DNA.DictionaryLocale_Backup

UPDATE SMB
SET SMB.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryVersionKey, j.newLocale)
FROM StudyMigrationBackup SMB
	JOIN @t t
		ON t.versionId = SMB.FromVersionId_Backup
	JOIN StudyDictionaryVersion SDV
		ON SMB.StudyDictionaryVersionID = SDV.StudyDictionaryVersionID
	JOIN SynonymMigrationMngmt SMM
		ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
	JOIN @locales j
		on j.oldLocale = SMM.DictionaryLocale_Backup

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnTempMigrateLogic')
	DROP FUNCTION dbo.fnTempMigrateLogic
GO