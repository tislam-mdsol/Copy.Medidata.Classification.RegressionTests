DECLARE @levelCorrespondence TABLE(MedDraId INT, MedHistoryId INT, levelKey VARCHAR(50))
DECLARE @medDraDictionaryId INT = 26
DECLARE @medHistoryDictionaryId INT = 28

DECLARE @t TABLE(versionId INT PRIMARY KEY, dictionaryid INT, dictionaryOid VARCHAR(50), versionOid VARCHAR(50))

INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid)
EXECUTE spGetDictionaryAndVersions

INSERT INTO @levelCorrespondence(MedDraId, MedHistoryId, levelKey)
VALUES 
(	80	,	93, 	'MedDRA-PT'),
(	81	,	94, 	'MedDRA-LLT')

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DnacMedDRABackup')	
BEGIN
		CREATE TABLE [dbo].[DnacMedDRABackup](
			Id INT NOT NULL IDENTITY(1, 1),
			
			DnacListName VARCHAR(50), -- in { MedDRA, MedDRAMedHistory }
			VersionOid  VARCHAR(50), 
			Locale CHAR(3),
			MedicalDictionaryLevelKey VARCHAR(50),

			Term NVARCHAR(900),
			
			SegmentId INT,
			UserId INT
		)
END

INSERT INTO DnacMedDRABackup 
	(DnacListName, 
	VersionOid, 
	Locale,
	MedicalDictionaryLevelKey, 
	Term,
	SegmentId, 
	UserId)
SELECT 
	'MedDRAMedHistory',
	T.versionOid,
	DA.Locale,
	LC.levelKey,
	DA.Term,
	DA.SegmentId,
	DA.UserId
FROM DoNotAutoCodeTerms DA
	JOIN @t T
		ON DA.DictionaryVersionId = T.versionId
	JOIN @levelCorrespondence LC
		ON DA.DictionaryLevelId   = LC.MedHistoryId
WHERE T.dictionaryid = @medHistoryDictionaryId
	AND DA.Active = 1

INSERT INTO DnacMedDRABackup 
	(DnacListName, 
	VersionOid, 
	Locale,
	MedicalDictionaryLevelKey, 
	Term,
	SegmentId, 
	UserId)
SELECT 
	'MedDRA',
	T.versionOid,
	DA.Locale,
	LC.levelKey,
	DA.Term,
	DA.SegmentId,
	DA.UserId
FROM DoNotAutoCodeTerms DA
	JOIN @t T
		ON DA.DictionaryVersionId = T.versionId
	JOIN @levelCorrespondence LC
		ON DA.DictionaryLevelId   = LC.MedDraId
WHERE T.dictionaryid = @medDraDictionaryId
	AND DA.Active = 1

