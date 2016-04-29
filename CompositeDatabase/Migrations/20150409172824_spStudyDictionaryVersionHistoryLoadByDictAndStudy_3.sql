IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryVersionHistoryLoadByDictAndStudy')
	DROP PROCEDURE dbo.spStudyDictionaryVersionHistoryLoadByDictAndStudy
GO
Create PROCEDURE [dbo].[spStudyDictionaryVersionHistoryLoadByDictAndStudy]
(
	@MedicalDictionaryID INT,
	@StudyID INT
)
AS

	SELECT SDVH.*
	FROM StudyDictionaryVersionHistory SDVH
		JOIN StudyDictionaryVersion SDV
			ON SDVH.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
		JOIN SynonymMigrationMngmt SMM
			ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
		JOIN DictionaryVersionRef DVR
			ON DVR.DictionaryVersionRefID = SMM.DictionaryVersionId
	WHERE DVR.DictionaryRefID = @MedicalDictionaryID
		AND SDV.StudyID = @StudyID
	ORDER BY SDVH.StudyDictionaryVersionHistoryId ASC