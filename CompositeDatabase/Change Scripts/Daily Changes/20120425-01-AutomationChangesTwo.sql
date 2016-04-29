-- 1. Group text full-text index table
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'GroupVerbatimEng')
BEGIN

	CREATE TABLE [dbo].GroupVerbatimEng(
		GroupVerbatimID INT IDENTITY(1,1) NOT NULL,
        VerbatimText NVARCHAR(450),
		Created DATETIME NOT NULL CONSTRAINT DF_GroupVerbatimEng_Created DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_GroupVerbatimEng] PRIMARY KEY CLUSTERED 
	(
		GroupVerbatimID ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]	
END
GO 

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'GroupVerbatimJpn')
BEGIN

	CREATE TABLE [dbo].GroupVerbatimJpn(
		GroupVerbatimID INT IDENTITY(1,1) NOT NULL,
        VerbatimText NVARCHAR(450),
		Created DATETIME NOT NULL CONSTRAINT DF_GroupVerbatimJpn_Created DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_GroupVerbatimJpn] PRIMARY KEY CLUSTERED 
	(
		GroupVerbatimID ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]	
END
GO 

-- 2. Fulltext catalogue(s)
IF NOT EXISTS (SELECT NULL FROM sys.fulltext_catalogs
	WHERE name = 'VerbatimCat')
	CREATE FULLTEXT CATALOG [VerbatimCat] WITH ACCENT_SENSITIVITY = ON
	AUTHORIZATION [dbo]
GO

IF NOT EXISTS (SELECT NULL FROM sys.fulltext_index_columns
	WHERE object_name(object_id) = 'GroupVerbatimEng')
	CREATE FULLTEXT INDEX ON GroupVerbatimEng
	(
		VerbatimText LANGUAGE English
	)
	KEY INDEX PK_GroupVerbatimEng ON (VerbatimCat, FILEGROUP [PRIMARY])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO

IF NOT EXISTS (SELECT NULL FROM sys.fulltext_index_columns
	WHERE object_name(object_id) = 'GroupVerbatimJpn')
	CREATE FULLTEXT INDEX ON GroupVerbatimJpn
	(
		VerbatimText LANGUAGE Japanese
	)
	KEY INDEX PK_GroupVerbatimJpn ON (VerbatimCat, FILEGROUP [PRIMARY])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO


-- 3. CodingElementGroups (alter)
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingElementGroups'
			AND COLUMN_NAME = 'GroupVerbatimID')
	ALTER TABLE CodingElementGroups
	ADD GroupVerbatimID INT NOT NULL CONSTRAINT DF_CodingElementGroups_GroupVerbatimID DEFAULT (0)
GO

-- 4. add index to GroupVerbatimID
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElementGroups_GroupVerbatimID')
	DROP INDEX CodingElementGroups.IX_CodingElementGroups_GroupVerbatimID

CREATE NONCLUSTERED INDEX IX_CodingElementGroups_GroupVerbatimID
ON [dbo].[CodingElementGroups] 
(GroupVerbatimID)


-- UDTs
IF EXISTS (SELECT NULL FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSourceTermInsertGroupMany')
	DROP PROCEDURE dbo.spCodingSourceTermInsertGroupMany
GO

IF EXISTS (SELECT NULL FROM SYS.TYPES WHERE NAME = 'TaskInsert_UDT')
	DROP TYPE TaskInsert_UDT
GO

CREATE TYPE [dbo].TaskInsert_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    SourceIdentifier NVARCHAR(100) NOT NULL,
    DictionaryLevelId INT NOT NULL,
    TermSearchType INT NOT NULL,
    Priority INT NOT NULL,
    DictionaryLocale VARCHAR(3) NOT NULL,
    IsSynchronousAckNack BIT NOT NULL,
    StartingWorkflowStateId INT NOT NULL,
    SubjectRef NVARCHAR(100) NOT NULL,
    FormRef NVARCHAR(450) NOT NULL,
    FieldRef NVARCHAR(450) NOT NULL,
    HasComponents BIT NOT NULL,
    DictionaryLevelOID VARCHAR(100) NOT NULL,
    GroupVerbatimId INT NOT NULL,
    VerbatimText NVARCHAR(450) NOT NULL
)
GO


-- SynonymMigrationMngmt (alter)
IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_SynonymMigrationMngmt_ListID')
	ALTER TABLE SynonymMigrationMngmt
	DROP CONSTRAINT DF_SynonymMigrationMngmt_ListID

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SynonymMigrationMngmt'
			AND COLUMN_NAME = 'ListID')
	ALTER TABLE SynonymMigrationMngmt
	DROP COLUMN ListID
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SynonymMigrationMngmt'
			AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE SynonymMigrationMngmt
	ADD DictionaryVersionId INT NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_DictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SynonymMigrationMngmt'
			AND COLUMN_NAME = 'FromDictionaryVersionId')
	ALTER TABLE SynonymMigrationMngmt
	ADD FromDictionaryVersionId INT NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_FromDictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SynonymMigrationMngmt'
			AND COLUMN_NAME = 'ListName')
	ALTER TABLE SynonymMigrationMngmt
	ADD ListName NVARCHAR(100) NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_ListName DEFAULT (N'')
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SynonymMigrationMngmt'
			AND COLUMN_NAME = 'Deleted')
	ALTER TABLE SynonymMigrationMngmt
	ADD Deleted BIT NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_Deleted DEFAULT (0)
GO


-- Registrations
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
			AND COLUMN_NAME = 'DictionaryLocale')
	ALTER TABLE ProjectDictionaryRegistrations
	ADD DictionaryLocale CHAR(3) NOT NULL CONSTRAINT DF_ProjectDictionaryRegistrations_DictionaryLocale DEFAULT ('eng')
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
			AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE ProjectDictionaryRegistrations
	ADD DictionaryVersionId INT NOT NULL CONSTRAINT DF_ProjectDictionaryRegistrations_DictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'StudyDictionaryVersion'
			AND COLUMN_NAME = 'DictionaryLocale')
	ALTER TABLE StudyDictionaryVersion
	ADD DictionaryLocale CHAR(3) NOT NULL CONSTRAINT DF_StudyDictionaryVersion_DictionaryLocale DEFAULT ('eng')
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'StudyDictionaryVersion'
			AND COLUMN_NAME = 'SynonymManagementID')
	ALTER TABLE StudyDictionaryVersion
	ADD SynonymManagementID INT NOT NULL CONSTRAINT DF_StudyDictionaryVersion_SynonymManagementID DEFAULT (-1)
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UQ_StudyDictionaryVersion_StudyIDMedDictIDSeg')
	ALTER TABLE StudyDictionaryVersion
	DROP CONSTRAINT UQ_StudyDictionaryVersion_StudyIDMedDictIDSeg

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'StudyDictionaryVersion'
			AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE StudyDictionaryVersion
	ADD DictionaryVersionId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersion_DictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'StudyDictionaryVersion'
			AND COLUMN_NAME = 'InitialDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersion
	ADD InitialDictionaryVersionId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersion_InitialDictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'StudyDictionaryVersion'
			AND COLUMN_NAME = 'InitialDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersion
	ADD InitialDictionaryVersionId INT NOT NULL CONSTRAINT DF_StudyDictionaryVersion_InitialDictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'MedicalDictVerLocaleStatus'
			AND COLUMN_NAME = 'NewVersionId')
	ALTER TABLE MedicalDictVerLocaleStatus
	ADD NewVersionId INT NOT NULL CONSTRAINT DF_MedicalDictVerLocaleStatus_NewVersionId DEFAULT (0)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'MedicalDictVerLocaleStatus'
			AND COLUMN_NAME = 'OldVersionId')
	ALTER TABLE MedicalDictVerLocaleStatus
	ADD OldVersionId INT NOT NULL CONSTRAINT DF_MedicalDictVerLocaleStatus_OldVersionId DEFAULT (0)
GO

