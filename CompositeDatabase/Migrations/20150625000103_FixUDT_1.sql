IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternCrossSearch')
	DROP PROCEDURE dbo.spSegmentedGroupCodingPatternCrossSearch
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternExist')
	DROP PROCEDURE dbo.spSegmentedGroupCodingPatternExist
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'TermBase_UDT')
	DROP TYPE TermBase_UDT
GO

CREATE TYPE [dbo].TermBase_UDT AS TABLE(
    MedicalDictionaryLevelKey NVARCHAR(100),
    MatchPercent DECIMAL NOT NULL,
    TermId VARCHAR(50) PRIMARY KEY NOT NULL
)
GO 