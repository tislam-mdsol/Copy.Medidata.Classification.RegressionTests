IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'UUID')
	ALTER TABLE CodingElements
	ADD UUID NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElements_UUID DEFAULT (N'')
GO 

IF EXISTS (SELECT NULL FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSourceTermInsertGroupMany')
	DROP PROCEDURE dbo.spCodingSourceTermInsertGroupMany
GO

IF EXISTS (SELECT NULL FROM SYS.TYPES WHERE NAME = 'TaskInsert_UDT')
	DROP TYPE TaskInsert_UDT
GO

CREATE TYPE [dbo].TaskInsert_UDT AS TABLE(
    CodingRequestItemDataOrdinal INT NOT NULL,
    DictionaryLevelId INT NOT NULL,
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
    TermSearchType INT NOT NULL,
	UUID NVARCHAR(100) NOT NULL
)
GO