-- UDTs
-- 2. TaskInsert_UDT
IF EXISTS (SELECT NULL FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSourceTermInsertGroupMany')
	DROP PROCEDURE dbo.spCodingSourceTermInsertGroupMany
GO

IF EXISTS (SELECT NULL FROM SYS.TYPES WHERE NAME = 'TaskInsert_UDT')
	DROP TYPE TaskInsert_UDT
GO

CREATE TYPE [dbo].TaskInsert_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    DictionaryLevelId INT NOT NULL,
    --DictionaryLevelOID VARCHAR(100) NOT NULL,
    DictionaryLocale VARCHAR(3) NOT NULL,
    FieldRef NVARCHAR(450) NOT NULL,
    FormRef NVARCHAR(450) NOT NULL,
    GroupId INT NOT NULL,
    IsSynchronousAckNack BIT NOT NULL,
    Priority INT NOT NULL,
    RawInputString NVARCHAR(450) NOT NULL,
    ReducedInputStringId INT NOT NULL,
    SourceIdentifier NVARCHAR(100) NOT NULL,
    StartingWorkflowStateId INT NOT NULL,
    SubjectRef NVARCHAR(100) NOT NULL,
    TermSearchType INT NOT NULL
)
GO

-- 3. TermComponent_UDT
IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TermComponent_UDT')
	DROP TYPE TermComponent_UDT
GO

CREATE TYPE [dbo].TermComponent_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    Id INT NOT NULL,
    IsSupplement BIT NOT NULL,
    OID NVARCHAR(450) NOT NULL,
    Ordinal INT NOT NULL,
    RawInputString NVARCHAR(450) NOT NULL,
    ReducedInputStringId INT NOT NULL,
    SearchType INT NOT NULL,
    SearchOperator INT NOT NULL,
    TextKey NVARCHAR(450) NOT NULL
)
GO

-- 4. BasicTermComponent_UDT
IF EXISTS (SELECT NULL FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingElementGroupFindExisting')
	DROP PROCEDURE dbo.spCodingElementGroupFindExisting
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'BasicTermComponent_UDT')
	DROP TYPE BasicTermComponent_UDT
GO

CREATE TYPE [dbo].BasicTermComponent_UDT AS TABLE(
    IsSupplement BIT NOT NULL,
	KeyId INT NOT NULL,
    StringId INT NOT NULL
)
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroupComponents'
	AND COLUMN_NAME = 'NameTextID')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	ADD NameTextID INT NOT NULL CONSTRAINT DF_CodingElementGroupComponents_NameTextID DEFAULT(0)
END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroupComponents'
	AND COLUMN_NAME = 'IsSupplement')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	ADD IsSupplement BIT NOT NULL CONSTRAINT DF_CodingElementGroupComponents_IsSupplement DEFAULT(0)
END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
	AND COLUMN_NAME = 'CompSuppCount')
BEGIN
	ALTER TABLE CodingElementGroups
	ADD CompSuppCount INT NOT NULL CONSTRAINT DF_CodingElementGroups_CompSuppCount DEFAULT(0)
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
	AND COLUMN_NAME = 'HasComponents')
BEGIN

	IF EXISTS (SELECT NULL FROM sys.default_constraints WHERE name = 'DF_CodingElementGroups_HasComponents')
		ALTER TABLE CodingElementGroups
		DROP CONSTRAINT DF_CodingElementGroups_HasComponents
	
	ALTER TABLE CodingElementGroups
	DROP COLUMN HasComponents	
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
	AND COLUMN_NAME = 'HasSupplements')
BEGIN

	IF EXISTS (SELECT NULL FROM sys.default_constraints WHERE name = 'DF_CodingElementGroups_HasSupplements')
		ALTER TABLE CodingElementGroups
		DROP CONSTRAINT DF_CodingElementGroups_HasSupplements
	
	ALTER TABLE CodingElementGroups
	DROP COLUMN HasSupplements	
END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'SupplementFieldKeys')
BEGIN
	CREATE TABLE [dbo].[SupplementFieldKeys](
		[SupplementFieldKeyId] [int] IDENTITY(1,1) NOT NULL,

		KeyField NVARCHAR(450) NOT NULL,
	 CONSTRAINT [PK_SupplementFieldKeys] PRIMARY KEY CLUSTERED 
	(
		[SupplementFieldKeyId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)

	CREATE UNIQUE NONCLUSTERED INDEX [UIX_SupplementFieldKeys_UniqueName] ON [dbo].SupplementFieldKeys 
	(
		KeyField
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSourceTermSupplementals'
	AND COLUMN_NAME = 'ValueId')
BEGIN
	ALTER TABLE CodingSourceTermSupplementals
	ADD ValueId INT NOT NULL CONSTRAINT DF_CodingSourceTermSupplementals_ValueId DEFAULT(0)
END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSourceTermSupplementals'
	AND COLUMN_NAME = 'KeyId')
BEGIN
	ALTER TABLE CodingSourceTermSupplementals
	ADD KeyId INT NOT NULL CONSTRAINT DF_CodingSourceTermSupplementals_KeyId DEFAULT(0)
END

-- temp structures needed for group migration

-- New Groups
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'TmpProcessingGroup')
	DROP TABLE [dbo].TmpProcessingGroup
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'TmpProcessingGroup')
BEGIN
	CREATE TABLE [dbo].TmpProcessingGroup(
		Id [int] IDENTITY(1,1) NOT NULL,

		CodingElementGroupID INT NOT NULL,

		KeyField VARCHAR(890) NOT NULL,
		NewGroupId INT NOT NULL,
	 CONSTRAINT [PK_TmpProcessing] PRIMARY KEY CLUSTERED 
	(
		Id ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)

	CREATE UNIQUE NONCLUSTERED INDEX [UIX_TmpProcessing_UniqueName] ON [dbo].TmpProcessingGroup 
	(
		CodingElementGroupID, KeyField
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END
GO

-- Synonym Mapper
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'TmpProcessingSynonym')
BEGIN
	CREATE TABLE [dbo].[TmpProcessingSynonym](
		IdOld [int] NOT NULL,

		IdNew INT NOT NULL,
		TmpId INT NOT NULL
	)

	CREATE UNIQUE CLUSTERED INDEX [IX_TmpProcessingSynonym_IdOld] ON [dbo].TmpProcessingSynonym 
	(
		IdOld, TmpId
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


END
GO	