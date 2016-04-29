
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternSearchEnglish')
	DROP PROCEDURE dbo.spSegmentedGroupCodingPatternSearchEnglish
GO
CREATE PROCEDURE [dbo].spSegmentedGroupCodingPatternSearchEnglish
(	
	@synonymListId INT,
	@statusId INT,
	@SearchString NVARCHAR(500), 
	@NonNormalizedValue NVARCHAR(500),
	@maxNumber INT, 
	@pageSize INT, 
	@pageNumber INT,
	@countOfTotalMatches INT OUTPUT, --Return the total count of matches
	@segmentId INT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT
)
AS
BEGIN

    DECLARE @LCID INT = 1033

	-- BEGIN wildcard search section			
	DECLARE @NonNormalizedStringWords2 TABLE(SourceWord NVARCHAR(450), SourceWordID TINYINT, Exp_Type INT, VariantWord NVARCHAR(450))

	DECLARE @singleWordWeight DECIMAL(10,2)
	DECLARE @lengthInput INT

	SET @lengthInput = LEN(@NonNormalizedValue)

	INSERT INTO @NonNormalizedStringWords2 (SourceWord, Exp_Type, VariantWord)
	SELECT 
		source_term, expansion_type, display_term
	FROM sys.dm_fts_parser(@SearchString, @LCID, 0, 0)
	GROUP BY source_term, expansion_type, display_term

	;WITH XCTE
	AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY SourceWord ASC) AS WordID,
			SourceWord
		FROM @NonNormalizedStringWords2
		WHERE Exp_Type = 0
		GROUP BY SourceWord
	)

	UPDATE NNSW
	SET NNSW.SourceWordID = X.WordID
	FROM @NonNormalizedStringWords2 NNSW
		JOIN XCTE X
			ON NNSW.SourceWord = X.SourceWord

	SELECT @singleWordWeight = 1.0/MAX(SourceWordID)
	FROM @NonNormalizedStringWords2

	DECLARE @results TABLE(Id BIGINT PRIMARY KEY, CountOfTotalMatches INT)
	
	;WITH SQLPaging
	AS
	(
		SELECT TOP (@maxNumber)
			S.SegmentedGroupCodingPatternID, 
			Y.MatchPercent AS Rank
		FROM dbo.fnSynonymGroupVerbatims(@synonymListId,  @statusId, @IsAutoApproval, @ForcePrimaryPath) S
			JOIN GroupVerbatimEng L
				ON L.GroupVerbatimID = S.GroupVerbatimID
			CROSS APPLY
			(
				SELECT MatchPercent = 
					CASE WHEN L.VerbatimText = @NonNormalizedValue
						THEN 1.0
					ELSE
						SUM(X.WordWeights)
						-
						0.02*
						CASE WHEN MAX(X.MatchLen) > @lengthInput 
							THEN MAX(X.MatchLen) / @lengthInput
							ELSE 1.00
						END
						- 0.001
					END
				FROM
				(
				SELECT 
					MAX(Y2.WordWeights) AS WordWeights,
					MAX(Y2.MatchLen) AS MatchLen -- should be constant
				FROM
					(SELECT
						SourceWordID,
						@singleWordWeight * --WordWeight * --X3.NumMultiplier *
						CASE WHEN Y3.MatchLen > 0 THEN
							CASE WHEN Exp_Type = 0 THEN 1.0
								WHEN Exp_Type = 1 THEN 0.5
								WHEN Exp_Type = 2 THEN 0.99
								ELSE 0.9 -- TODO : verify whether other exp_type values are possible
							END
							ELSE 0.0
						END	AS WordWeights,
						Y3.MatchLen
					FROM @NonNormalizedStringWords2
						CROSS APPLY
						(
							SELECT MatchLen = 
								CASE WHEN CHARINDEX(VariantWord, L.VerbatimText) > 0 THEN LEN(L.VerbatimText)
									ELSE 0
								END
							) AS Y3
					) AS Y2
				GROUP BY Y2.SourceWordID, Y2.MatchLen
				) AS X
			) AS Y
		WHERE 
			CONTAINS(L.VerbatimText, @SearchString, LANGUAGE @LCID)
			AND Y.MatchPercent > 0.2
		ORDER BY Y.MatchPercent DESC
	)

	INSERT INTO @results(Id, CountOfTotalMatches)
	SELECT Y.SegmentedGroupCodingPatternID, -1
	FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY TS.Rank DESC) AS Row, TS.* 
			FROM SQLPaging TS
		) AS Y
	WHERE Row BETWEEN @PageNumber * @PageSize + 1 AND (@PageNumber + 1) * @PageSize
	UNION
	SELECT 0, COUNT(1)
	FROM SQLPaging
	OPTION (RECOMPILE)

	SELECT @countOfTotalMatches = CountOfTotalMatches
	FROM @results
	WHERE Id = 0

	SELECT S.*
	FROM @results R
		JOIN SegmentedGroupCodingPatterns S
			ON R.Id = S.SegmentedGroupCodingPatternID
			
END