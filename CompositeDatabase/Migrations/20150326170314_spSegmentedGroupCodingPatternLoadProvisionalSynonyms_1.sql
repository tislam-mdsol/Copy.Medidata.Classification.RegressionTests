IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternLoadProvisionalSynonyms')
	DROP PROCEDURE spSegmentedGroupCodingPatternLoadProvisionalSynonyms
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternLoadProvisionalSynonyms
(
	@StartDate datetime,
	@EndDate datetime,
	@medicalDictionaryIds VARCHAR(MAX),
	@synonymManagementId INT,
	@studyId INT,
	@delimiterChar CHAR(1),
	@Locale CHAR(3),
	@searchString NVARCHAR(200),
	@maxSearch INT, 
	@pageSize INT,
	@pageNumber	INT,
	@totalCount INT OUTPUT,
	@segmentId INT
)
AS

	IF (@StartDate IS NULL) SET @StartDate = '1/1/1753'
	IF (@EndDate IS NULL) SET @EndDate = '12/31/9999 23:59:59'
	
	DECLARE @searchFT BIT
	
	IF (LEN(@searchString) = 0)
	BEGIN
		SET @searchFT = 0
		SET @searchString = '""'
	END
	ELSE
		SET @searchFT = 1

	DECLARE @dictionaryIDs TABLE (MedicalDictionaryID INT)
	
	INSERT INTO @dictionaryIDs
	SELECT * FROM dbo.fnParseDelimitedString(@medicalDictionaryIds, @delimiterChar)
	
	DECLARE @startRowNumber INT, @endRowNumber INT
	SET @startRowNumber = (@pageNumber * @PageSize) + 1
	SET @endRowNumber = @startRowNumber + @PageSize - 1

	DECLARE @applySynonymListFilter BIT = 1
	DECLARE @synonymListFilter TABLE(SynonymListId INT)

	IF (@synonymManagementId > 0)
	BEGIN
		INSERT INTO @synonymListFilter
		VALUES(@synonymManagementId)
	END
	ELSE IF (@studyId > 0)
	BEGIN
		INSERT INTO @synonymListFilter
		SELECT SynonymManagementID 
		FROM StudyDictionaryVersion
		WHERE StudyId = @studyId
	END
	ELSE
		SET @applySynonymListFilter = 0
	
	DECLARE @Ids TABLE(RowNUM INT IDENTITY(1,1) PRIMARY KEY, ID BIGINT)

	INSERT INTO @Ids(ID)
	SELECT TOP (@maxSearch) SGCP.SegmentedGroupCodingPatternID
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN CodingElementGroups CEG
			ON SGCP.CodingElementGroupID = CEG.CodingElementGroupID
			AND SGCP.SegmentID = @segmentId
			AND SGCP.Updated BETWEEN @StartDate AND @EndDate
			AND CEG.MedicalDictionaryID IN (SELECT * FROM @dictionaryIDs)
			AND SGCP.SynonymStatus = 1
			-- list check
			AND (@applySynonymListFilter = 0 OR
				SGCP.SynonymManagementID IN (SELECT SynonymListId FROM @synonymListFilter))
			AND
			( 
				@searchFT = 0
				OR
				(
					(
						CEG.DictionaryLocale = 'eng'
						AND
						EXISTS (SELECT NULL FROM GroupVerbatimEng GVE
								WHERE GVE.GroupVerbatimID = CEG.GroupVerbatimID
									AND CONTAINS(GVE.VerbatimText, @searchString, LANGUAGE 1033)
								)
					)
					OR
					(
						CEG.DictionaryLocale = 'jpn'
						AND
						EXISTS (SELECT NULL FROM GroupVerbatimJpn GVJ
								WHERE GVJ.GroupVerbatimID = CEG.GroupVerbatimID
									AND CONTAINS(GVJ.VerbatimText, @searchString, LANGUAGE 1041)
								)
					)
				)
			)
	ORDER BY SGCP.SynonymManagementID
	
	SELECT @totalCOUNT = COUNT(*)
	FROM @Ids
	
	SELECT S.*
	FROM @Ids I
		JOIN SegmentedGroupCodingPatterns S
			ON I.ID = S.SegmentedGroupCodingPatternID
	WHERE I.RowNUM BETWEEN @startRowNumber AND @endRowNumber
	
GO 

