-- add verbatim Key
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
		 AND COLUMN_NAME = 'VerbatimKey')
	ALTER TABLE CodingElementGroups
	ADD VerbatimKey NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElementGroups_VerbatimKey DEFAULT (N'')
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElementGroups_Multi')
	DROP INDEX CodingElementGroups.IX_CodingElementGroups_Multi

CREATE NONCLUSTERED INDEX IX_CodingElementGroups_Multi
ON [dbo].[CodingElementGroups] ([VerbatimText], VerbatimKey)
INCLUDE ([CodingElementGroupID],[DictionaryLocale])
GO

-- add assigned term key
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'AssignedTermKey')
	ALTER TABLE CodingElements
	ADD AssignedTermKey NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElements_AssignedTermKey DEFAULT (N'')
GO

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
    VerbatimKey NVARCHAR(100) NOT NULL
)
GO
 
