-- Add CacheVersion column to entities that need locking on update
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'CacheVersion')
	ALTER TABLE CodingElements ADD CacheVersion BIGINT NOT NULL CONSTRAINT DF_CodingElements_CacheVersion DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		 AND COLUMN_NAME = 'CacheVersion')
	ALTER TABLE SegmentedGroupCodingPatterns ADD CacheVersion BIGINT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_CacheVersion DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		 AND COLUMN_NAME = 'CacheVersion')
	ALTER TABLE SynonymMigrationMngmt ADD CacheVersion BIGINT NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_CacheVersion DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Configuration'
		 AND COLUMN_NAME = 'CacheVersion')
	ALTER TABLE Configuration ADD CacheVersion BIGINT NOT NULL CONSTRAINT DF_Configuration_CacheVersion DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'CacheVersion')
	ALTER TABLE StudyDictionaryVersion ADD CacheVersion BIGINT NOT NULL CONSTRAINT DF_StudyDictionaryVersion_CacheVersion DEFAULT (0)
GO

-- Immutables - only insert checks/ never updates
--CodingElementGroups
--CodingPatterns
--DictionaryLevelRef
--DictionaryVersionLocaleRef
--DictionaryVersionRef
--DictionaryRef


-- add lock Table
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'RuntimeLocks'))
BEGIN
		-- Create client db reference table
		CREATE TABLE [dbo].[RuntimeLocks](	
			-- note size constraints, index can't handle bigger keys!
			[LockString] VARCHAR(900) NOT NULL,	
			[Created] DATETIME NOT NULL,
			[ExpiresOn] DATETIME NOT NULL
		CONSTRAINT [PK_RuntimeLocks] PRIMARY KEY CLUSTERED 
		(
			[LockString] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

END

