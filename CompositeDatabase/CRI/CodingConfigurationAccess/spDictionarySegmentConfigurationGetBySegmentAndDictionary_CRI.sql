IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationGetBySegmentAndDictionary_CRI')
	DROP PROCEDURE spDictionarySegmentConfigurationGetBySegmentAndDictionary_CRI
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationGetBySegmentAndDictionary_CRI
(
    @SegmentID INT,
    @MedicalDictionaryKey NVARCHAR(100)
)
AS

	-- only the last saved configuration should be considered
    SELECT TOP 1 SegmentId, UserId, MedicalDictionaryKey,IsAutoAddSynonym, IsAutoApproval
    FROM DictionarySegmentConfigurations
    WHERE SegmentId = @SegmentID
        AND MedicalDictionaryKey = @MedicalDictionaryKey
	ORDER BY DictionarySegmentConfigurationId DESC
	
GO 