IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'spImpactAnalysisGetTaskDetails')
	DROP PROCEDURE dbo.spImpactAnalysisGetTaskDetails
GO
CREATE PROCEDURE [dbo].[spImpactAnalysisGetTaskDetails]
(
	@CodingElementIds VARCHAR(MAX),
	@Delimiter CHAR(1)	
)
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
	SELECT
		CE.CodingElementId,	CE.VerbatimTerm,
		CP.CodingPath
	FROM CodingElements CE
		JOIN (SELECT CAST(Item AS BIGINT) AS ElementId, Id AS SortId 
				FROM dbo.fnParseDelimitedStringWithID(@CodingElementIds, @Delimiter)
				) IDS 
			ON CE.CodingElementId = IDS.ElementId
		JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
		JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
	ORDER BY IDS.SortId
