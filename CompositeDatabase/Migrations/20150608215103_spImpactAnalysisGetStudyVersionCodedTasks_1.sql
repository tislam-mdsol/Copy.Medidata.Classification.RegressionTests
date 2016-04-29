IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'spImpactAnalysisGetStudyVersionCodedTasks')
	DROP PROCEDURE dbo.spImpactAnalysisGetStudyVersionCodedTasks
GO

CREATE PROCEDURE [dbo].[spImpactAnalysisGetStudyVersionCodedTasks]
(
	@sdvID INT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		CE.CodingElementId, 
		CP.CodingPath,
		CP.LevelId AS DictionaryLevelId
	FROM CodingElements CE
		JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternID
			AND SGCP.Active = 1
		JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID		
	WHERE CE.StudyDictionaryVersionId = @sdvID
		AND CE.IsInvalidTask = 0
	ORDER BY VerbatimTerm
 
END
 