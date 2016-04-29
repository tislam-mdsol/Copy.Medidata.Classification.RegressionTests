IF EXISTS 
	(SELECT NULL FROM sys.default_constraints WHERE name = 'DF_SynonymLoadStaging_CodingElementGroupID')
	ALTER TABLE SynonymLoadStaging
	DROP CONSTRAINT DF_SynonymLoadStaging_CodingElementGroupID
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'CodingElementGroupID')
	ALTER TABLE SynonymLoadStaging
	DROP COLUMN CodingElementGroupID
GO 


-- SynonymMigrationEntries
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'SelectedSuggestionId')
	ALTER TABLE SynonymMigrationEntries
	ADD SelectedSuggestionId BIGINT NOT NULL CONSTRAINT DF_SynonymMigrationEntries_SelectedSuggestionId DEFAULT (-1)
GO

-- Migration
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'NewNodepath')
BEGIN
	-- trick to bypass the sql compile check that throws on subsequent runs once the old column has been dropped
	DECLARE @dynSQL1 VARCHAR(MAX) = '
		UPDATE SME
		SET SME.SelectedSuggestionId = SMS.SynonymMigrationSuggestionID
		FROM SynonymMigrationEntries SME
			JOIN SynonymMigrationSuggestions SMS
				ON SME.SynonymMigrationEntryId = SMS.SynonymMigrationEntryId
				AND SME.NewNodepath = SMS.SuggestedNodePath'
				
	EXEC(@dynSQL1)
END
GO	

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'NewNodepath')
	ALTER TABLE SynonymMigrationEntries
	DROP COLUMN NewNodepath
GO 

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SynonymMigrationEntries_Status')
	DROP INDEX SynonymMigrationEntries.IX_SynonymMigrationEntries_Status

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SynonymMigrationEntries_TermID')
	DROP INDEX SynonymMigrationEntries.IX_SynonymMigrationEntries_TermID

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'TermID')
	ALTER TABLE SynonymMigrationEntries
	DROP COLUMN TermID
GO 

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'FinalTermID')
	ALTER TABLE SynonymMigrationEntries
	DROP COLUMN FinalTermID
GO 

DECLARE @dynSQL VARCHAR(MAX), @csName VARCHAR(100)

SELECT @csName = name
FROM sys.default_constraints
WHERE parent_object_id = object_id('SynonymMigrationEntries')
	AND parent_column_id = 
		(SELECT column_id FROM sys.columns
			WHERE object_id = object_id('SynonymMigrationEntries')
			AND name = 'FinalMasterTermID')
			
SET @dynSQL = 'ALTER TABLE SynonymMigrationEntries DROP CONSTRAINT ' + @csName

IF EXISTS    
(SELECT NULL FROM sys.default_constraints WHERE name = @csName) 
	EXEC(@dynSQL)

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SynonymMigrationEntries_FinalMasterTermID')
	DROP INDEX SynonymMigrationEntries.IX_SynonymMigrationEntries_FinalMasterTermID

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'FinalMasterTermID')
	ALTER TABLE SynonymMigrationEntries
	DROP COLUMN FinalMasterTermID
GO 

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SynonymMigrationSuggestions_TermID')
	DROP INDEX SynonymMigrationSuggestions.IX_SynonymMigrationSuggestions_TermID

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationSuggestions'
		 AND COLUMN_NAME = 'TermID')
	ALTER TABLE SynonymMigrationSuggestions
	DROP COLUMN TermID
GO 

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_SynonymMigrationMngmt_FromDictionaryVersionId')
	ALTER TABLE SynonymMigrationMngmt
	DROP CONSTRAINT DF_SynonymMigrationMngmt_FromDictionaryVersionId

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		 AND COLUMN_NAME = 'FromDictionaryVersionId')
	ALTER TABLE SynonymMigrationMngmt
	DROP COLUMN FromDictionaryVersionId
GO 

-- add new columns
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'SegmentedGroupCodingPatternID')
	ALTER TABLE SynonymMigrationEntries
	ADD SegmentedGroupCodingPatternID BIGINT NOT NULL CONSTRAINT DF_SynonymMigrationEntries_SegmentedGroupCodingPatternID DEFAULT (-1)
GO 

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
		 AND COLUMN_NAME = 'PriorTermIdsAndText')
	ALTER TABLE SynonymMigrationEntries
	ADD PriorTermIdsAndText VARCHAR(MAX)
GO 

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationSuggestions'
		 AND COLUMN_NAME = 'NextTermIdsAndText')
	ALTER TABLE SynonymMigrationSuggestions
	ADD NextTermIdsAndText VARCHAR(MAX)
GO 

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		 AND COLUMN_NAME = 'FromSynonymListID')
	ALTER TABLE SynonymMigrationMngmt
	ADD FromSynonymListID BIGINT NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_FromSynonymListID DEFAULT (-1)
GO 
