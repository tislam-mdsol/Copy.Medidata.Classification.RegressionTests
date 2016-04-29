IF object_id('fnGetHistoricalVersionIdForTaskHistory') IS NOT NULL
	DROP FUNCTION dbo.fnGetHistoricalVersionIdForTaskHistory
GO

CREATE FUNCTION [dbo].fnGetHistoricalVersionIdForTaskHistory
(
    @CodingElementId BIGINT,
	@HistoryTimeStamp DATETIME
)
RETURNS TABLE
AS
	RETURN 
		SELECT ISNULL(DVR.DictionaryVersionRefID, SMM.DictionaryVersionId) AS DictionaryVersionId
		FROM StudyDictionaryVersion SDV
			JOIN SynonymMigrationMngmt SMM
				ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
			CROSS APPLY
			(
				SELECT MAX(DVR.DictionaryVersionRefID) AS DictionaryVersionRefID
				FROM DictionaryVersionRef DVR
					CROSS APPLY
					(  
						SELECT MAX(FromVersionOrdinal) AS FromVersionOrdinal
						FROM StudyDictionaryVersionHistory SDVH
							JOIN StudyDictionaryVersion SDV2
								ON SDVH.StudyDictionaryVersionId = SDV2.StudyDictionaryVersionId
							JOIN SynonymMigrationMngmt SMM2
								ON SMM2.SynonymMigrationMngmtID = SDV2.SynonymManagementID
						WHERE SMM2.MedicalDictionaryID = SDVH.MedicalDictionaryID
							AND SDV2.SegmentID = SDVH.SegmentID
							AND SDVH.Updated <= @HistoryTimeStamp
					) AS SDVH
				WHERE DVR.DictionaryRefID = SMM.MedicalDictionaryID
					AND DVR.Ordinal = SDVH.FromVersionOrdinal
			) AS DVR
		WHERE SDV.StudyDictionaryVersionID = 
			(
				SELECT StudyDictionaryVersionID FROM CodingElements 
				WHERE CodingElementId = @CodingElementId
			)