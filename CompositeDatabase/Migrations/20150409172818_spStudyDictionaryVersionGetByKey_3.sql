IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryVersionGetByKey')
	DROP PROCEDURE dbo.spStudyDictionaryVersionGetByKey
GO

CREATE PROCEDURE [dbo].spStudyDictionaryVersionGetByKey
(
	@MedicalDictionaryID INT,
	@StudyID INT,
	@DictionaryLocale CHAR(3)
)
AS

	SELECT SDV.* 
	FROM StudyDictionaryVersion SDV
		JOIN SynonymMigrationMngmt SMM
			ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
		JOIN DictionaryVersionRef DVR
			ON DVR.DictionaryVersionRefID = SMM.DictionaryVersionId
	WHERE SDV.StudyID = @StudyID 
		AND DVR.DictionaryRefID = @MedicalDictionaryID
		AND SMM.Locale = @DictionaryLocale
		AND SMM.SegmentID = SDV.SegmentID