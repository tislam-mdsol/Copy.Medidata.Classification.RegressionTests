IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSourceTermInsertGroupMany')
	DROP PROCEDURE dbo.spCodingSourceTermInsertGroupMany
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TaskInsert_UDT')
	DROP TYPE TaskInsert_UDT
GO

CREATE TYPE [dbo].TaskInsert_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    SourceIdentifier NVARCHAR(100) NOT NULL,
    DictionaryLevelId INT NOT NULL,
    VerbatimText NVARCHAR(450),
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
    VerbatimKey NVARCHAR(100) NOT NULL,
    TrimmedVerbatim NVARCHAR(100) NOT NULL
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
    SearchOperator INT NOT NULL,
    TrimmedValue NVARCHAR(450) NOT NULL
)
GO

