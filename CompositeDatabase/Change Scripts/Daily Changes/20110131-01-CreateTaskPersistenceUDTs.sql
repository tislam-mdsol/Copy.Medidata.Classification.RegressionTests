IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'SourceIdentifier')
	ALTER TABLE CodingElements
	ADD SourceIdentifier NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElements_SourceIdentifier DEFAULT ('')
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TaskInsert_UDT')
	DROP TYPE TaskInsert_UDT
GO

CREATE TYPE [dbo].TaskInsert_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    SourceIdentifier NVARCHAR(100) NOT NULL,
    WorkflowId INT NOT NULL,
    DictionaryLevelId INT NOT NULL,
    VerbatimText NVARCHAR(450),
    TermSearchType INT NOT NULL,
    Priority INT NOT NULL,
    DictionaryLocale VARCHAR(3) NOT NULL,
    IsSynchronousAckNack BIT NOT NULL
)
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TermComponent_UDT')
	DROP TYPE TermComponent_UDT
GO

CREATE TYPE [dbo].TermComponent_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    Ordinal INT NOT NULL,
    Id INT NOT NULL,
    OID NVARCHAR(450) NOT NULL,
    TextKey NVARCHAR(450) NOT NULL,
    IsSupplement BIT NOT NULL,
    Value NVARCHAR(450) NOT NULL,
    SearchType INT NOT NULL,
    SearchOperator INT NOT NULL
)
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TermReference_UDT')
	DROP TYPE TermReference_UDT
GO

CREATE TYPE [dbo].TermReference_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    ReferenceKey NVARCHAR(450) NOT NULL,
    Value NVARCHAR(450) NOT NULL
)
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'WorkflowVariable_UDT')
	DROP TYPE WorkflowVariable_UDT
GO

CREATE TYPE [dbo].WorkflowVariable_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    Id INT NOT NULL,
    Name NVARCHAR(450) NOT NULL,
    Value NVARCHAR(450) NOT NULL
)
GO