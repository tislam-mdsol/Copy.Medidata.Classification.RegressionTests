IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermInsertGroupMany')
	DROP PROCEDURE spCodingSourceTermInsertGroupMany
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TermComponent_UDT')
	DROP TYPE TermComponent_UDT
GO

/****** Object:  UserDefinedTableType [dbo].[TermComponent_UDT]    Script Date: 12/10/2015 2:01:28 PM ******/
CREATE TYPE [dbo].[TermComponent_UDT] AS TABLE(
	[CodingRequestItemDataOrdinal] [int] NOT NULL,
	[Id] [int] NOT NULL,
	[IsSupplement] [bit] NOT NULL,
	[OID] [nvarchar](450) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[RawInputString] [nvarchar](450) NOT NULL,
	[ReducedInputStringId] [int] NOT NULL,
	[TextKey] [nvarchar](450) NOT NULL
)
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi2')
BEGIN
	
	DROP INDEX CodingElements.IX_CodingElements_Multi2

	CREATE NONCLUSTERED INDEX IX_CodingElements_Multi2
	ON [dbo].[CodingElements] ([SegmentId], [StudyDictionaryVersionId], [IsClosed],[IsStillInService],[IsInvalidTask])
	INCLUDE ([CodingElementId],[MedicalDictionaryLevelKey],[VerbatimTerm],[WorkflowStateID],[AssignedSegmentedGroupCodingPatternId],[AssignedTermText],[AssignedTermCode],[AssignedCodingPath],[SourceSubject])

END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElements'
		AND COLUMN_NAME = 'DictionaryLevelId_Backup')
BEGIN
	ALTER TABLE CodingElements
	DROP COLUMN DictionaryLevelId_Backup
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_CodingElements_SearchType')
BEGIN
	ALTER TABLE CodingElements
	DROP CONSTRAINT DF_CodingElements_SearchType
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElements'
		AND COLUMN_NAME = 'SearchType')
BEGIN
	ALTER TABLE CodingElements
	DROP COLUMN SearchType
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingSourceTermSupplementals'
		AND COLUMN_NAME = 'SearchOperator')
BEGIN
	ALTER TABLE CodingSourceTermSupplementals
	DROP COLUMN SearchOperator
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroups'
		AND COLUMN_NAME = 'DictionaryId_Backup')
BEGIN
	ALTER TABLE CodingElementGroups
	DROP COLUMN DictionaryId_Backup
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroups'
		AND COLUMN_NAME = 'DictionaryLevelId_Backup')
BEGIN
	ALTER TABLE CodingElementGroups
	DROP COLUMN DictionaryLevelId_Backup
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		AND COLUMN_NAME = 'DictionaryLocale_Backup')
BEGIN
	ALTER TABLE SynonymMigrationMngmt
	DROP COLUMN DictionaryLocale_Backup
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_SynonymMigrationMngmt_DictionaryVersionId')
BEGIN
	ALTER TABLE SynonymMigrationMngmt
	DROP CONSTRAINT DF_SynonymMigrationMngmt_DictionaryVersionId
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		AND COLUMN_NAME = 'DictionaryVersionId_Backup')
BEGIN
	ALTER TABLE SynonymMigrationMngmt
	DROP COLUMN DictionaryVersionId_Backup
END

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_DoNotAutoCodeTerms_Multi')
BEGIN
	
	DROP INDEX DoNotAutoCodeTerms.IX_DoNotAutoCodeTerms_Multi

	CREATE NONCLUSTERED INDEX [IX_DoNotAutoCodeTerms_Multi] ON [dbo].[DoNotAutoCodeTerms] 
	(
		SegmentId,
        [MedicalDictionaryLevelKey],
        [ListId], 
		Active
	)
	INCLUDE
	( Term )
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		AND COLUMN_NAME = 'DictionaryLocale_Backup')
BEGIN
	ALTER TABLE DoNotAutoCodeTerms
	DROP COLUMN DictionaryLocale_Backup
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		AND COLUMN_NAME = 'DictionaryVersionId_Backup')
BEGIN
	ALTER TABLE DoNotAutoCodeTerms
	DROP COLUMN DictionaryVersionId_Backup
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		AND COLUMN_NAME = 'DictionaryLevelId_Backup')
BEGIN
	ALTER TABLE DoNotAutoCodeTerms
	DROP COLUMN DictionaryLevelId_Backup
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_DoNotAutoCodeTerms_MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE DoNotAutoCodeTerms
	DROP CONSTRAINT DF_DoNotAutoCodeTerms_MedicalDictionaryVersionLocaleKey
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		AND COLUMN_NAME = 'MedicalDictionaryVersionLocaleKey')
BEGIN
	ALTER TABLE DoNotAutoCodeTerms
	DROP COLUMN MedicalDictionaryVersionLocaleKey
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_DictionarySegmentConfigurations_DictionaryId')
BEGIN
	ALTER TABLE DictionarySegmentConfigurations
	DROP CONSTRAINT DF_DictionarySegmentConfigurations_DictionaryId
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DictionarySegmentConfigurations'
		AND COLUMN_NAME = 'DictionaryId_Backup')
BEGIN
	ALTER TABLE DictionarySegmentConfigurations
	DROP COLUMN DictionaryId_Backup
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_DictionarySegmentConfigurations_Active')
BEGIN
	ALTER TABLE DictionarySegmentConfigurations
	DROP CONSTRAINT DF_DictionarySegmentConfigurations_Active
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DictionarySegmentConfigurations'
		AND COLUMN_NAME = 'Active')
BEGIN
	ALTER TABLE DictionarySegmentConfigurations
	DROP COLUMN Active
END

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_DictionaryLicenceInformations_MedicalDictionaryID')
BEGIN
	
	DROP INDEX DictionaryLicenceInformations.IX_DictionaryLicenceInformations_MedicalDictionaryID

	CREATE NONCLUSTERED INDEX [IX_DictionaryLicenceInformations_MedicalDictionaryID] ON [dbo].[DictionaryLicenceInformations] 
	(
		MedicalDictionaryKey ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DictionaryLicenceInformations'
		AND COLUMN_NAME = 'DictionaryId_Backup')
BEGIN
	ALTER TABLE DictionaryLicenceInformations
	DROP COLUMN DictionaryId_Backup
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'StudyMigrationBackup'
		AND COLUMN_NAME = 'FromVersionId_Backup')
BEGIN
	ALTER TABLE StudyMigrationBackup
	DROP COLUMN FromVersionId_Backup
END

-- tables to drop entirely!
IF EXISTS (SELECT * FROM sys.tables
	WHERE name = 'CronActions')
	DROP TABLE CronActions

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DataMigrationDetails')
	DROP TABLE DataMigrationDetails

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DataMigrationRuns')
	DROP TABLE DataMigrationRuns

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DataMigrations')
	DROP TABLE DataMigrations

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DictionaryComponentTypeRef_Backup')
	DROP TABLE DictionaryComponentTypeRef_Backup

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DictionaryLevelRef_Backup')
	DROP TABLE DictionaryLevelRef_Backup

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DictionaryRef_Backup')
	DROP TABLE DictionaryRef_Backup

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DictionaryVersionDiffDepth_Backup')
	DROP TABLE DictionaryVersionDiffDepth_Backup

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DictionaryVersionLocaleRef_Backup')
	DROP TABLE DictionaryVersionLocaleRef_Backup

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DictionaryVersionRef_Backup')
	DROP TABLE DictionaryVersionRef_Backup

IF EXISTS (SELECT NULL FROM sys.tables
	WHERE name = 'DictionaryVersionSubscriptions')
	DROP TABLE DictionaryVersionSubscriptions




