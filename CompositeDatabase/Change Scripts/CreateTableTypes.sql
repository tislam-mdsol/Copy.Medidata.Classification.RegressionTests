/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

if not exists(select null from sys.table_types where name='TermSearchResultType') begin
	CREATE TYPE dbo.TermSearchResultType AS TABLE 
	( 
		TermId bigint not null -- Primary key
		, LevelId int null
		, RecursionDepth tinyint
		, Rank decimal(10,2) null
		, NodePath VARCHAR(MAX)
	)
end
go
if not exists(select null from sys.table_types where name='SynonymResultType') begin
	CREATE TYPE dbo.SynonymResultType AS TABLE 
	( 
		TermId bigint not null Primary key
		, SynonymTermId bigint null
		, MatchPercent decimal(10,2) null
	)
end
go

IF NOT EXISTS (SELECT NULL FROM sys.table_types WHERE name = 'TermArrayType') BEGIN
	CREATE TYPE dbo.TermArrayType AS TABLE 
	( 
		TermId BIGINT NOT NULL PRIMARY KEY
	)
END
go

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
