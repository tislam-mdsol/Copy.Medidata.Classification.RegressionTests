IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationLoadBySegment')
	DROP PROCEDURE spDictionarySegmentConfigurationLoadBySegment
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationLoadBySegment
(
    @SegmentID INT
)
AS

    SELECT *
    FROM DictionarySegmentConfigurations
    WHERE SegmentId = @SegmentID
	
GO 