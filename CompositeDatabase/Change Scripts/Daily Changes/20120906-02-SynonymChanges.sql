IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'UIX_SegmentedGroupCodingPatterns_Multi')
	DROP INDEX [SegmentedGroupCodingPatterns].[UIX_SegmentedGroupCodingPatterns_Multi]

CREATE UNIQUE NONCLUSTERED INDEX [UIX_SegmentedGroupCodingPatterns_Multi] ON [dbo].[SegmentedGroupCodingPatterns] 
(
	[CodingElementGroupID] ASC,
	[CodingPatternID] ASC,
	[DictionaryVersionID] ASC,
	[SynonymManagementID] ASC,
	[SegmentID] ASC
)
WHERE ([Active]=(1))
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO 

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'UIX_SegmentedGroupCodingPatterns_SinglePerGroup')
	DROP INDEX [SegmentedGroupCodingPatterns].[UIX_SegmentedGroupCodingPatterns_SinglePerGroup]

CREATE UNIQUE NONCLUSTERED INDEX [UIX_SegmentedGroupCodingPatterns_SinglePerGroup] ON [dbo].[SegmentedGroupCodingPatterns] 
(
	[CodingElementGroupID] ASC,
	[DictionaryVersionID] ASC,
	[SynonymManagementID] ASC,
	[SegmentID] ASC
)
WHERE ([Active]=(1) AND [IsValidForAutoCode]=(1))
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TermBase_UDT')
	DROP TYPE TermBase_UDT
GO

CREATE TYPE [dbo].TermBase_UDT AS TABLE(
    LevelId INT,
    MatchPercent DECIMAL NOT NULL,
    Term VARCHAR(50) PRIMARY KEY NOT NULL
)
GO 

-- Synonym Staging
IF EXISTS 
	(SELECT NULL FROM sys.default_constraints WHERE name = 'DF_SynonymLoadStaging_MasterTermID')
	ALTER TABLE SynonymLoadStaging
	DROP CONSTRAINT DF_SynonymLoadStaging_MasterTermID
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'MasterTermID')
	ALTER TABLE SynonymLoadStaging
	DROP COLUMN MasterTermID
GO 

IF EXISTS
	(SELECT NULL FROM sys.indexes WHERE name = 'IX_SynonymLoadStaging_SynonymManagementID')
	DROP INDEX SynonymLoadStaging.IX_SynonymLoadStaging_SynonymManagementID

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'Code')
	ALTER TABLE SynonymLoadStaging
	DROP COLUMN Code
GO

IF EXISTS 
	(SELECT NULL FROM sys.default_constraints WHERE name = 'DF_SynonymLoadStaging_UsePrimary')
	ALTER TABLE SynonymLoadStaging
	DROP CONSTRAINT DF_SynonymLoadStaging_UsePrimary
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'UsePrimary')
	ALTER TABLE SynonymLoadStaging
	DROP COLUMN UsePrimary
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'Components')
	ALTER TABLE SynonymLoadStaging
	ADD Components VARCHAR(MAX)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'Supplements')
	ALTER TABLE SynonymLoadStaging
	ADD Supplements VARCHAR(MAX)
GO

-- RESET ALL SYNONYM LIST(s) that are in mid-process
DECLARE @errorString NVARCHAR(1000)

BEGIN TRY
BEGIN TRANSACTION

	DECLARE @synId TABLE(SynId INT PRIMARY KEY)

	INSERT INTO @synId
	SELECT SynonymMigrationMngmtID FROM SynonymMigrationMngmt
	WHERE SynonymMigrationStatusRID NOT IN (1, 6)

	-- have to clear in migration data as well
	-- 1. suggestions
	DELETE FROM SynonymMigrationSuggestions
	WHERE SynonymMigrationEntryID IN (SELECT SynonymMigrationEntryID FROM SynonymMigrationEntries
		WHERE SynonymMigrationMngmtID IN (SELECT SynId FROM @synId))

	-- 2. entries
	DELETE FROM SynonymMigrationEntries
	WHERE SynonymMigrationMngmtID IN (SELECT SynId FROM @synId)

    -- have to clear corresponding synonyms in SegmentedGroupCodingPatterns 
    -- 3. actual corresponding synonyms
    DELETE FROM SegmentedGroupCodingPatterns
    WHERE SynonymManagementID IN (SELECT SynId FROM @synId)
    
	-- 4. actual reset
	UPDATE S
	SET S.FromSynonymListID = -1,
		S.NumberOfSynonyms = 0,
		S.IsSynonymListLoadedFromFile = 0,
		S.SynonymMigrationStatusRID = 1
	FROM SynonymMigrationMngmt S
		JOIN @synId SS
			ON SS.SynId = S.SynonymMigrationMngmtID

COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	SET @errorString = N'ERROR Synonym List reset: Transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH