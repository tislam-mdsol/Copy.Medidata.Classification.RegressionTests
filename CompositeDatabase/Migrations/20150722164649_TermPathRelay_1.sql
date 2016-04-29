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
    LevelKey NVARCHAR(100),
    TermPath NVARCHAR(500),
	Ordinal INT
)
GO 