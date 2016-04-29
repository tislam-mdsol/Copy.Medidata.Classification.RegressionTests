IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spImpactAnalysisGetStudyDictTerms')
	DROP PROCEDURE dbo.spImpactAnalysisGetStudyDictTerms
GO

-- exec spImpactAnalysisGetStudyDictTerms 5, 12, 1

CREATE PROCEDURE [dbo].[spImpactAnalysisGetStudyDictTerms]
(
	@TrackableObjectID BIGINT,
	@SynonymListId INT,
	@ShowAll BIT
)
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @sdvs TABLE(StudyDictionaryVersionID INT, KeepCurrentVersion BIT)

	INSERT INTO @sdvs(StudyDictionaryVersionID, KeepCurrentVersion)
	SELECT StudyDictionaryVersionID, KeepCurrentVersion
	FROM StudyDictionaryVersion 
	WHERE StudyID = @TrackableObjectID
		AND (KeepCurrentVersion = 0 OR @ShowAll = 1)
		AND SynonymManagementID = @SynonymListId

	SELECT 
		sdv.StudyDictionaryVersionID, 
		sdv.KeepCurrentVersion,
		CP.CodingPath,
		COUNT(*) AS TaskCount
	FROM @sdvs sdv
		JOIN CodingElements CE
			ON sdv.StudyDictionaryVersionID = CE.StudyDictionaryVersionId
		LEFT JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternID
			AND SGCP.Active = 1
		LEFT JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
	WHERE CE.IsInvalidTask = 0
	GROUP BY sdv.StudyDictionaryVersionID, sdv.KeepCurrentVersion, CodingPath
