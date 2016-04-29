DECLARE @t TABLE(
	levelId INT PRIMARY KEY, 
	levelKey NVARCHAR(100))

INSERT INTO @t (levelId, levelKey)
EXECUTE spGetDictionaryAndLevels

UPDATE CE
SET CE.MedicalDictionaryLevelKey = t.levelKey
FROM CodingElements CE
	JOIN @t t
		ON t.levelId = CE.DictionaryLevelId

UPDATE CP
SET CP.MedicalDictionaryLevelKey = t.levelKey
FROM CodingPatterns CP
	JOIN @t t
		ON t.levelId = CP.LevelId

UPDATE CEG
SET CEG.MedicalDictionaryLevelKey = t.levelKey
FROM CodingElementGroups CEG
	JOIN @t t
		ON t.levelId = CEG.DictionaryLevelId

UPDATE DNA
SET DNA.MedicalDictionaryLevelKey = t.levelKey
FROM DoNotAutoCodeTerms DNA
	JOIN @t t
		ON t.levelId = DNA.DictionaryLevelId

EXEC sys.sp_rename 
		@objname = N'dbo.CodingElements.DictionaryLevelId', 
		@newname = 'DictionaryLevelId_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.CodingPatterns.LevelId',
		@newname = 'DictionaryLevelId_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.CodingElementGroups.DictionaryLevelId', 
		@newname = 'DictionaryLevelId_Backup', 
		@objtype = 'COLUMN'

EXEC sys.sp_rename 
		@objname = N'dbo.DoNotAutoCodeTerms.DictionaryLevelId',
		@newname = 'DictionaryLevelId_Backup', 
		@objtype = 'COLUMN'
