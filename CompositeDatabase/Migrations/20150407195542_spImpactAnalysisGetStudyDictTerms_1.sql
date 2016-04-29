IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spImpactAnalysisGetStudyDictTerms')
	DROP PROCEDURE dbo.spImpactAnalysisGetStudyDictTerms
GO
CREATE PROCEDURE [dbo].[spImpactAnalysisGetStudyDictTerms]
(
	@TrackableObjectID BIGINT,
	@MedicalDictionaryID INT,
	@FromVersionID INT,
	@Locale CHAR(3),
	@ShowAll BIT
)
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	;WITH SDV AS
	(
		SELECT StudyDictionaryVersionID, KeepCurrentVersion
		FROM StudyDictionaryVersion 
		WHERE StudyID = @TrackableObjectID
			AND (KeepCurrentVersion = 0 OR @ShowAll = 1)
			AND SynonymManagementID IN (SELECT SynonymManagementID
				FROM SynonymMigrationMngmt
				WHERE DictionaryVersionId = @FromVersionID
					AND Locale = @Locale
					AND MedicalDictionaryID = @MedicalDictionaryID)
	)

	SELECT 
		SDV.StudyDictionaryVersionID, 
		SDV.KeepCurrentVersion,
		CP.CodingPath,
		CP.DictionaryLevelID,
		COUNT(*) AS TaskCount,
		@FromVersionID AS DictionaryVersionId
	FROM SDV
		JOIN CodingElements CE
			ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
			AND CE.IsInvalidTask = 0
		LEFT JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternID
			AND SGCP.Active = 1
		LEFT JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
	GROUP BY SDV.StudyDictionaryVersionID, KeepCurrentVersion, CodingPath, CP.DictionaryLevelId
	ORDER BY SDV.StudyDictionaryVersionID
 
 