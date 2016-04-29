DECLARE @dbName NVARCHAR(128)

SELECT @dbName = db_name()

EXEC('ALTER DATABASE '+@dbName+' SET RECOVERY SIMPLE')

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MedDictTermVerUpdates')
	DROP TABLE MedDictTermVerUpdates
GO

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MedDictTermRelUpdates')
	DROP TABLE MedDictTermRelUpdates
GO

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MedDictTermRelVerUpdates')
	DROP TABLE MedDictTermRelVerUpdates
GO

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MedDictComponentVerUpdates')
	DROP TABLE MedDictComponentVerUpdates
GO

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MedDictLevelCmpntVerUpdates')
	DROP TABLE MedDictLevelCmpntVerUpdates
GO

TRUNCATE TABLE MedDictComponentUpdates
TRUNCATE TABLE MedDictLevelCmpntUpdates

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictVerTerm'
		 AND COLUMN_NAME = 'IsConsecutive')
	ALTER TABLE MedicalDictVerTerm
	ADD IsConsecutive BIT NOT NULL DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictVerTerm'
		 AND COLUMN_NAME = 'FinalTermID')
	ALTER TABLE MedicalDictVerTerm
	ADD FinalTermID INT NOT NULL DEFAULT (-1)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictVerTermRel'
		 AND COLUMN_NAME = 'IsConsecutive')
	ALTER TABLE MedicalDictVerTermRel
	ADD IsConsecutive BIT NOT NULL DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictVerTermRel'
		 AND COLUMN_NAME = 'FinalTermRelID')
	ALTER TABLE MedicalDictVerTermRel
	ADD FinalTermRelID INT NOT NULL DEFAULT (-1)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictionaryTermRel'
		 AND COLUMN_NAME = 'ProgrammaticAuxiliary')
	ALTER TABLE MedicalDictionaryTermRel
	ADD ProgrammaticAuxiliary INT NOT NULL DEFAULT (-1)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedDictVerTermComponents'
		 AND COLUMN_NAME = 'IsConsecutive')
	ALTER TABLE MedDictVerTermComponents
	ADD IsConsecutive BIT NOT NULL DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedDictVerTermComponents'
		 AND COLUMN_NAME = 'FinalComponentTermID')
	ALTER TABLE MedDictVerTermComponents
	ADD FinalComponentTermID INT NOT NULL DEFAULT (-1)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictTermComponents'
		 AND COLUMN_NAME = 'ProgrammaticAuxiliary')
	ALTER TABLE MedicalDictTermComponents
	ADD ProgrammaticAuxiliary INT NOT NULL DEFAULT (-1)
GO


IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedDictVerLvlComponents'
		 AND COLUMN_NAME = 'IsConsecutive')
	ALTER TABLE MedDictVerLvlComponents
	ADD IsConsecutive BIT NOT NULL DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedDictVerLvlComponents'
		 AND COLUMN_NAME = 'FinalLevelComponentTermID')
	ALTER TABLE MedDictVerLvlComponents
	ADD FinalLevelComponentTermID INT NOT NULL DEFAULT (-1)
GO


IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictLevelComponents'
		 AND COLUMN_NAME = 'ProgrammaticAuxiliary')
	ALTER TABLE MedicalDictLevelComponents
	ADD ProgrammaticAuxiliary INT NOT NULL DEFAULT (-1)
GO


-- update indices
-- 1. MedDictTermUpdates
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictTermUpdates_InitialTermId')
	DROP INDEX MedDictTermUpdates.IX_MedDictTermUpdates_InitialTermId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictTermUpdates_MedicalDictionaryID')
	DROP INDEX MedDictTermUpdates.IX_MedDictTermUpdates_MedicalDictionaryID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'Ix_MedDictTermUpdates_Prior')
	DROP INDEX MedDictTermUpdates.Ix_MedDictTermUpdates_Prior
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictTermUpdates_VersionTermId')
	DROP INDEX MedDictTermUpdates.IX_MedDictTermUpdates_VersionTermId

DROP INDEX MedDictTermUpdates.IX_MedDictTermUpdates_PostProcessingIndex

CREATE NONCLUSTERED INDEX IX_MedDictTermUpdates_PostProcessingIndex
ON [dbo].[MedDictTermUpdates] ([MedicalDictionaryID],[FromVersionOrdinal],[ToVersionOrdinal],[Locale])
INCLUDE ([VersionTermId], [FinalTermId], ImpactAnalysisChangeTypeId, ChangeTypeId)
GO

-- 2. MedicalDictVerTerm
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictVTerm_levelcode')
	DROP INDEX MedicalDictVerTerm.ix_MedDictVTerm_levelcode
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictVTerm_ordinals')
	DROP INDEX MedicalDictVerTerm.ix_MedDictVTerm_ordinals
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTerm_DictionaryLevelId')
	DROP INDEX MedicalDictVerTerm.IX_MedicalDictVerTerm_DictionaryLevelId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTerm_MedicalDictionaryID')
	DROP INDEX MedicalDictVerTerm.IX_MedicalDictVerTerm_MedicalDictionaryID		
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTerm_Mixed')
	DROP INDEX MedicalDictVerTerm.IX_MedicalDictVerTerm_Mixed
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTerm_Mixed2')
	DROP INDEX MedicalDictVerTerm.IX_MedicalDictVerTerm_Mixed2	

CREATE NONCLUSTERED INDEX IX_MedicalDictVerTerm_Mixed
ON [dbo].MedicalDictVerTerm ([MedicalDictionaryID], [DictionaryVersionOrdinal], DictionaryLevelId)
INCLUDE (Code, FinalTermId)
GO

CREATE NONCLUSTERED INDEX IX_MedicalDictVerTerm_Mixed2
ON [dbo].[MedicalDictVerTerm] ([MedicalDictionaryID],[DictionaryVersionOrdinal],[NodepathDepth],[FinalTermID])
INCLUDE ([TermId],[DictionaryLevelId],[TermStatus],[Code],[Term_ENG],[Term_JPN],[Term_LOC],[IsCurrent],[Nodepath],[LevelRecursiveDepth],[IsConsecutive])
GO

-- 3. MedDictVerTermComponents
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictVerTermComponents_ComponentTypeID')
	DROP INDEX MedDictVerTermComponents.IX_MedDictVerTermComponents_ComponentTypeID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictVerTermComponents_MedicalDictionaryID')
	DROP INDEX MedDictVerTermComponents.IX_MedDictVerTermComponents_MedicalDictionaryID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictVerTermComponents_TermID')
	DROP INDEX MedDictVerTermComponents.IX_MedDictVerTermComponents_TermID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictVTermCmpt_ordinals')
	DROP INDEX MedDictVerTermComponents.ix_MedDictVTermCmpt_ordinals		
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictVTermCmpt_typeterm')
	DROP INDEX MedDictVerTermComponents.ix_MedDictVTermCmpt_typeterm		
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictVerTermComponents_Mixed')
	DROP INDEX MedDictVerTermComponents.IX_MedDictVerTermComponents_Mixed	

CREATE NONCLUSTERED INDEX IX_MedDictVerTermComponents_Mixed
ON [dbo].MedDictVerTermComponents ([MedicalDictionaryID], [DictionaryVersionOrdinal], ComponentTypeID, TermID)
GO

-- 4. MedicalDictVerTermRel
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_DictVerFrom_MedicalDictVerTermRel')
	DROP INDEX MedicalDictVerTermRel.IX_DictVerFrom_MedicalDictVerTermRel
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_DictVerTo_MedicalDictVerTermRel')
	DROP INDEX MedicalDictVerTermRel.IX_DictVerTo_MedicalDictVerTermRel
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_FromTo_MedicalDictVerTermRel')
	DROP INDEX MedicalDictVerTermRel.IX_FromTo_MedicalDictVerTermRel
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictVTermRel_fromto')
	DROP INDEX MedicalDictVerTermRel.ix_MedDictVTermRel_fromto		
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictVTermRel_ordinals')
	DROP INDEX MedicalDictVerTermRel.ix_MedDictVTermRel_ordinals		

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTermRel_FromTermId')
	DROP INDEX MedicalDictVerTermRel.IX_MedicalDictVerTermRel_FromTermId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTermRel_LevelMappingId')
	DROP INDEX MedicalDictVerTermRel.IX_MedicalDictVerTermRel_LevelMappingId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTermRel_MedicalDictionaryID')
	DROP INDEX MedicalDictVerTermRel.IX_MedicalDictVerTermRel_MedicalDictionaryID		
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTermRel_ToTermId')
	DROP INDEX MedicalDictVerTermRel.IX_MedicalDictVerTermRel_ToTermId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictVerTermRel_Mixed')
	DROP INDEX MedicalDictVerTermRel.IX_MedicalDictVerTermRel_Mixed

CREATE NONCLUSTERED INDEX IX_MedicalDictVerTermRel_Mixed
ON [dbo].MedicalDictVerTermRel ([MedicalDictionaryID], [DictionaryVersionOrdinal], FromTermId, ToTermId)
GO

-- 5. MedicalDictionaryTerm
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictTerm_DictVersion')
	DROP INDEX MedicalDictionaryTerm.IX_MedDictTerm_DictVersion
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictTerm_levelcode')
	DROP INDEX MedicalDictionaryTerm.ix_MedDictTerm_levelcode
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictTerm_MasterSegment')
	DROP INDEX MedicalDictionaryTerm.IX_MedDictTerm_MasterSegment		
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTerm_DictionaryLevelId')
	DROP INDEX MedicalDictionaryTerm.IX_MedicalDictionaryTerm_DictionaryLevelId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTerm_Mixed')
	DROP INDEX MedicalDictionaryTerm.IX_MedicalDictionaryTerm_Mixed

CREATE NONCLUSTERED INDEX IX_MedicalDictionaryTerm_Mixed
ON [dbo].MedicalDictionaryTerm (MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, DictionaryLevelId, SegmentId)
INCLUDE (Code, MasterTermId, IsCurrent, TermId, TermType, TermStatus)
GO

-- 6. MedicalDictTermComponents
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictTermCmpt_ordinals')
	DROP INDEX MedicalDictTermComponents.ix_MedDictTermCmpt_ordinals
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictTermComponents_ComponentTypeID')
	DROP INDEX MedicalDictTermComponents.IX_MedicalDictTermComponents_ComponentTypeID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictTermComponents_TermID')
	DROP INDEX MedicalDictTermComponents.IX_MedicalDictTermComponents_TermID		
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictTermComponents_Mixed')
	DROP INDEX MedicalDictTermComponents.IX_MedicalDictTermComponents_Mixed

CREATE NONCLUSTERED INDEX IX_MedicalDictTermComponents_Mixed
ON [dbo].MedicalDictTermComponents (MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, ComponentTypeID, TermID)
GO

-- 7. MedicalDictionaryTermRel
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IDX_MedicalDictionaryTermRel_FromTermID')
	DROP INDEX MedicalDictionaryTermRel.IDX_MedicalDictionaryTermRel_FromTermID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IDX_MedicalDictionaryTermRel_ToTermID')
	DROP INDEX MedicalDictionaryTermRel.IDX_MedicalDictionaryTermRel_ToTermID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictTermRel_fromto')
	DROP INDEX MedicalDictionaryTermRel.ix_MedDictTermRel_fromto

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'ix_MedDictTermRel_ordinals')
	DROP INDEX MedicalDictionaryTermRel.ix_MedDictTermRel_ordinals
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTermRel_FromTermId')
	DROP INDEX MedicalDictionaryTermRel.IX_MedicalDictionaryTermRel_FromTermId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTermRel_LevelMappingId')
	DROP INDEX MedicalDictionaryTermRel.IX_MedicalDictionaryTermRel_LevelMappingId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTermRel_ToTermId')
	DROP INDEX MedicalDictionaryTermRel.IX_MedicalDictionaryTermRel_ToTermId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTermRel_Mixed')
	DROP INDEX MedicalDictionaryTermRel.IX_MedicalDictionaryTermRel_Mixed

CREATE NONCLUSTERED INDEX IX_MedicalDictionaryTermRel_Mixed
ON [dbo].MedicalDictionaryTermRel (MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, LevelMappingId)
GO

UPDATE V
SET V.FinalTermID = T.TermId
FROM MedicalDictVerTerm V
	JOIN MedicalDictionaryTerm T
		ON V.Code = T.Code
		AND V.Term_ENG = T.Term_ENG
		AND V.DictionaryLevelId = T.DictionaryLevelId
		AND V.DictionaryVersionOrdinal BETWEEN T.FromVersionOrdinal AND T.ToVersionOrdinal
		AND V.MedicalDictionaryID = T.MedicalDictionaryID
		AND V.IsCurrent = T.IsCurrent

UPDATE V
SET V.IsConsecutive = 1
FROM MedicalDictVerTerm V
	LEFT JOIN MedDictTermUpdates U
		ON V.TermId = U.VersionTermId
		AND V.DictionaryVersionOrdinal = U.ToVersionOrdinal
		AND U.FromVersionOrdinal = U.ToVersionOrdinal - 1
		AND V.MedicalDictionaryID = U.MedicalDictionaryID
		AND U.Locale = 1
WHERE U.TermUpdateID IS NULL

DECLARE @dbName NVARCHAR(128)

SELECT @dbName = db_name()
-- SHRINK DB fully here
EXECUTE spShrinkDB 0

EXEC('ALTER DATABASE '+@dbName+' SET RECOVERY FULL') 