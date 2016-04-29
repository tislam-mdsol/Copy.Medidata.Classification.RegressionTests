IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationGetBySegmentAndDictionary')
	DROP PROCEDURE spDictionarySegmentConfigurationGetBySegmentAndDictionary
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationGetBySegmentAndDictionary
(
    @SegmentID INT,
    @MedicalDictionaryKey NVARCHAR(100)
)
AS

	-- only the last saved configuration should be considered
    SELECT TOP 1 *
    FROM DictionarySegmentConfigurations
    WHERE SegmentId = @SegmentID
        AND MedicalDictionaryKey = @MedicalDictionaryKey
	ORDER BY DictionarySegmentConfigurationId DESC
	
GO 