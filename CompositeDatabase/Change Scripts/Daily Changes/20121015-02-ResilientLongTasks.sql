IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_SynonymLoadStaging_ActivatedStatus')
	ALTER TABLE SynonymLoadStaging
	DROP CONSTRAINT DF_SynonymLoadStaging_ActivatedStatus
GO

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SynonymLoadStaging' AND COLUMN_NAME = 'ActivatedStatus')
	ALTER TABLE SynonymLoadStaging
	DROP COLUMN ActivatedStatus
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SynonymLoadStaging' AND COLUMN_NAME = 'ActivatedStatus')
	ALTER TABLE SynonymLoadStaging
	ADD ActivatedStatus BIT NOT NULL CONSTRAINT DF_SynonymLoadStaging_ActivatedStatus DEFAULT (0)
GO

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
    StudyDictionaryVersionId INT NOT NULL,
    SubjectRef NVARCHAR(100) NOT NULL,
    TermSearchType INT NOT NULL
)
GO