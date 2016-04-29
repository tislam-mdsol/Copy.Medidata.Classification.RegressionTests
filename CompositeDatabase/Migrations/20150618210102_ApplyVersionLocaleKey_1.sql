IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnTempMigrateLogic')
	DROP FUNCTION dbo.fnTempMigrateLogic
GO
CREATE FUNCTION dbo.fnTempMigrateLogic
(
	@Dictionary NVARCHAR(100),
	@Version NVARCHAR(100),
	@Locale NVARCHAR(100)
) RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN @Dictionary+'-'+@Version+'-'+@Locale
END
GO

DECLARE @t TABLE(versionId INT PRIMARY KEY, dictionaryid INT, dictionaryOid VARCHAR(50), versionOid VARCHAR(50))

INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid)
EXECUTE spGetDictionaryAndVersions

DECLARE @locales TABLE(oldLocale CHAR(3) PRIMARY KEY, newLocale VARCHAR(20))
INSERT INTO @locales (oldLocale, newLocale)
VALUES('eng', 'English'),
	('jpn', 'Japanese')

UPDATE SMM
SET SMM.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryOid, t.versionOid, j.newLocale)
FROM SynonymMigrationMngmt SMM
	JOIN @t t
		ON t.versionId = SMM.DictionaryVersionId
	JOIN @locales j
		on j.oldLocale = SMM.Locale

UPDATE DVS
SET DVS.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryOid, t.versionOid, j.newLocale)
FROM DictionaryVersionSubscriptions DVS
	JOIN @t t
		ON t.versionId = DVS.DictionaryVersionId
	JOIN @locales j
		on j.oldLocale = DVS.DictionaryLocale

UPDATE CP
SET CP.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryOid, t.versionOid, j.newLocale)
FROM CodingPatterns CP
	JOIN @t t
		ON t.versionId = CP.VersionId
	JOIN @locales j
		on j.oldLocale = CP.Locale

UPDATE DNA
SET DNA.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryOid, t.versionOid, j.newLocale)
FROM DoNotAutoCodeTerms DNA
	JOIN @t t
		ON t.versionId = DNA.DictionaryVersionId
	JOIN @locales j
		on j.oldLocale = DNA.Locale

UPDATE SMB
SET SMB.MedicalDictionaryVersionLocaleKey = dbo.fnTempMigrateLogic(t.dictionaryOid, t.versionOid, j.newLocale)
FROM StudyMigrationBackup SMB
	JOIN @t t
		ON t.versionId = SMB.FromVersionId
	JOIN StudyDictionaryVersion SDV
		ON SMB.StudyDictionaryVersionID = SDV.StudyDictionaryVersionID
	JOIN SynonymMigrationMngmt SMM
		ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
	JOIN @locales j
		on j.oldLocale = SMM.Locale

EXEC sys.sp_rename 
		@objname = N'dbo.SynonymMigrationMngmt.DictionaryVersionId', 
		@newname = 'DictionaryVersionId_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.SynonymMigrationMngmt.Locale',
		@newname = 'DictionaryLocale_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.DictionaryVersionSubscriptions.DictionaryVersionId', 
		@newname = 'DictionaryVersionId_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.DictionaryVersionSubscriptions.DictionaryLocale',
		@newname = 'DictionaryLocale_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.CodingPatterns.VersionId', 
		@newname = 'DictionaryVersionId_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.CodingPatterns.Locale',
		@newname = 'DictionaryLocale_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.DoNotAutoCodeTerms.DictionaryVersionId', 
		@newname = 'DictionaryVersionId_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.DoNotAutoCodeTerms.Locale',
		@newname = 'DictionaryLocale_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.StudyMigrationBackup.FromVersionId',
		@newname = 'FromVersionId_Backup', 
		@objtype = 'COLUMN'