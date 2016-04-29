IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternLoadByCodingPatternAndList')
	DROP PROCEDURE spSegmentedGroupCodingPatternLoadByCodingPatternAndList
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternLoadByCodingPatternAndList
(
	@CodingPatternID BIGINT,
	@SynonymManagementID INT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT,
	@SegmentID INT
)  
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @IsEnglish BIT
	
	IF EXISTS (SELECT NULL
		FROM SynonymMigrationMngmt 
		WHERE SynonymMigrationMngmtID = @SynonymManagementID
			AND CHARINDEX('English', MedicalDictionaryVersionLocaleKey) > 0) -- TODO : AV feed this as parameter - remove the logic from here
		SET @IsEnglish = 1
	ELSE
		SET @IsEnglish = 0
	
    DECLARE @codingPathCount INT

    SELECT @codingPathCount = PathCount
    FROM CodingPatterns
    WHERE CodingPatternID = @CodingPatternID

	IF (@IsEnglish = 1)
	BEGIN	

		;WITH synonyms AS (
			SELECT S.*
			FROM SegmentedGroupCodingPatterns S
			WHERE S.CodingPatternID = @CodingPatternID
				AND SynonymManagementID = @SynonymManagementID
		)

		SELECT *, X.Literal
		FROM synonyms S
			CROSS APPLY
			(
				SELECT Literal = L.VerbatimText
				FROM CodingElementGroups G
					JOIN GroupVerbatimEng L 
						ON L.GroupVerbatimID = G.GroupVerbatimID
				WHERE G.CodingElementGroupID = S.CodingElementGroupID
			) AS X
		WHERE S.SegmentID = @SegmentID
			AND S.Active = 1
			AND dbo.fnIsValidForAutoCodeIncludingProvisional(@IsAutoApproval, @ForcePrimaryPath, S.IsExactMatch, S.SynonymStatus, @codingPathCount) = 1

	END
	ELSE
	BEGIN

		;WITH synonyms AS (
			SELECT S.*
			FROM SegmentedGroupCodingPatterns S
			WHERE S.CodingPatternID = @CodingPatternID
				AND SynonymManagementID = @SynonymManagementID
		)

		SELECT *, X.Literal
		FROM synonyms S
			CROSS APPLY
			(
				SELECT Literal = L.VerbatimText
				FROM CodingElementGroups G
					JOIN GroupVerbatimJpn L 
						ON L.GroupVerbatimID = G.GroupVerbatimID
				WHERE G.CodingElementGroupID = S.CodingElementGroupID
			) AS X
		WHERE S.SegmentID = @SegmentID
			AND S.Active = 1
			AND dbo.fnIsValidForAutoCodeIncludingProvisional(@IsAutoApproval, @ForcePrimaryPath, S.IsExactMatch, S.SynonymStatus, @codingPathCount) = 1
	END

END

GO   
