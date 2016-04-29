IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternCrossSearch')
	DROP PROCEDURE dbo.spSegmentedGroupCodingPatternCrossSearch
GO
CREATE PROCEDURE [dbo].spSegmentedGroupCodingPatternCrossSearch
(	
	@synonymListId INT,
	@statusId INT,
	@maxNumber INT, 
	@pageSize INT, 
	@pageNumber INT,
	@terms dbo.TermBase_UDT READONLY,
	@countOfTotalMatches INT OUTPUT, --Return the total count of matches
	@segmentId INT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT
)
AS
BEGIN

	DECLARE @Results TABLE(Id INT IDENTITY(1,1), CodingRuleId INT PRIMARY KEY, CodingPath VARCHAR(300))

	-- keep the order as indicated in @terms

	INSERT INTO @Results (CodingRuleId, CodingPath)
	SELECT TOP (@maxNumber)
		S.SegmentedGroupCodingPatternID, CD.CodingPath
	FROM @terms T
		JOIN CodingPatterns CD
			ON T.TermPath = CD.CodingPath
		JOIN SegmentedGroupCodingPatterns S
			ON CD.CodingPatternID = S.CodingPatternID
			AND S.SynonymManagementID = @synonymListId
			AND (
					(@statusId in (-1, 0) AND S.SynonymStatus = 1)
				OR
					(@statusId in (-1, 1) AND S.SynonymStatus = 2)
				)
			AND (
				    (@IsAutoApproval = 1 AND CD.PathCount <> 1 AND @ForcePrimaryPath=0 )
					OR 
					@IsAutoApproval=0
					OR 
					S.IsExactMatch = 0
			   )
	ORDER BY T.Ordinal ASC

	-- get the totals	
	SELECT @countOfTotalMatches = COUNT(*)
	FROM @Results

	SELECT
		S.*,
		F.CodingPath
	FROM @Results F
		JOIN SegmentedGroupCodingPatterns S
			ON F.CodingRuleId = S.SegmentedGroupCodingPatternID
	WHERE F.Id BETWEEN @PageNumber * @PageSize + 1 AND (@PageNumber + 1) * @PageSize


END