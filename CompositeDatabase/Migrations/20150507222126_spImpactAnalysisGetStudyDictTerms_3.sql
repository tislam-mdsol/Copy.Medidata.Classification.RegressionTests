IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spImpactAnalysisGetStudyDictTerms')
	DROP PROCEDURE dbo.spImpactAnalysisGetStudyDictTerms
GO

-- exec spImpactAnalysisGetStudyDictTerms 5, 26, 333, 'eng', 1

CREATE PROCEDURE [dbo].[spImpactAnalysisGetStudyDictTerms]
(
	@TrackableObjectID BIGINT,
	@FromVersionID INT,
	@Locale CHAR(3),
	@ShowAll BIT
)
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @sdvID INT, @keepCurrentVersion BIT

	SELECT @sdvID = StudyDictionaryVersionID,	
		@keepCurrentVersion = KeepCurrentVersion
	FROM StudyDictionaryVersion 
	WHERE StudyID = @TrackableObjectID
		AND (KeepCurrentVersion = 0 OR @ShowAll = 1)
		AND SynonymManagementID IN (SELECT SMM.SynonymMigrationMngmtID
			FROM SynonymMigrationMngmt SMM
			WHERE SMM.DictionaryVersionId = @FromVersionID
				AND SMM.Locale = @Locale)

	SELECT 
		@sdvID AS StudyDictionaryVersionID, 
		@keepCurrentVersion AS KeepCurrentVersion,
		CP.CodingPath,
		CP.DictionaryLevelID,
		COUNT(*) AS TaskCount,
		@FromVersionID AS DictionaryVersionId
	FROM CodingElements CE
		LEFT JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternID
			AND SGCP.Active = 1
		LEFT JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
	WHERE @sdvID = CE.StudyDictionaryVersionId
		AND CE.IsInvalidTask = 0
	GROUP BY CodingPath, CP.DictionaryLevelId
