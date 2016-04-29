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
	WHERE SDV.StudyID = @StudyID 
		AND SynonymManagementID IN (SELECT SynonymManagementID
		FROM SynonymMigrationMngmt SMM
		WHERE SMM.MedicalDictionaryID = @MedicalDictionaryID
			AND SMM.Locale = @DictionaryLocale
			AND SMM.SegmentID = SDV.SegmentID)
