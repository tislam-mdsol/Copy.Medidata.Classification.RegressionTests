IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternLoadProvisionalSynonyms')
	DROP PROCEDURE spSegmentedGroupCodingPatternLoadProvisionalSynonyms
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternLoadProvisionalSynonyms
(
	@StartDate datetime,
	@EndDate datetime,
	@synonymManagementIds VARCHAR(MAX),
	@delimiterChar CHAR(1),
	@searchString NVARCHAR(200),
	@maxSearch INT, 
	@pageSize INT,
	@pageNumber	INT,
    @segmentId INT,
	@totalCount INT OUTPUT
)
AS

	IF (@startDate IS NULL) SET @startDate = '1/1/1753'
    IF (@endDate IS NULL) SET @endDate = '12/31/9999 23:59:59'

    IF (LEN(@searchString) = 0)
    BEGIN
	    SET @searchString = '""'
    END

    DECLARE @startRowNumber INT, @endRowNumber INT
    SET @startRowNumber = (@pageNumber * @pageSize) + 1
    SET @endRowNumber = @startRowNumber + @pageSize - 1

    DECLARE @synonymListFilter TABLE(SynonymListId INT)
    INSERT INTO @synonymListFilter
        SELECT * FROM dbo.fnParseDelimitedString(@synonymManagementIds, @delimiterChar)

    ;WITH VerbatimSearchFilter (CodingElementGroupId)
    AS (
        SELECT
            CodingElementGroupId
            FROM (
                SELECT CEG.CodingElementGroupId
                    FROM GroupVerbatimEng GVE
                        INNER JOIN CodingElementGroups CEG
                            ON GVE.GroupVerbatimID = CEG.GroupVerbatimID
                                AND CEG.DictionaryLocale = 'eng'
                        INNER JOIN SegmentedGroupCodingPatterns SGCP
                            ON CEG.CodingElementGroupID = SGCP.CodingElementGroupID
                    WHERE SGCP.SynonymStatus = 1
                        AND CEG.SegmentID = @segmentId
                        AND CONTAINS(GVE.VerbatimText, @searchString, LANGUAGE 1033)
        
                UNION ALL
                SELECT CEG.CodingElementGroupId
                    FROM GroupVerbatimJpn GVJ
                        INNER JOIN CodingElementGroups CEG
                            ON GVJ.GroupVerbatimID = CEG.GroupVerbatimID
                                AND CEG.DictionaryLocale = 'jpn'
                        INNER JOIN SegmentedGroupCodingPatterns SGCP
                            ON CEG.CodingElementGroupID = SGCP.CodingElementGroupID
                    WHERE SGCP.SynonymStatus = 1
                        AND CEG.SegmentID = @segmentId
                        AND CONTAINS(GVJ.VerbatimText, @searchString, LANGUAGE 1041)
        
                UNION ALL
                SELECT d.CodingElementGroupId
                    FROM (SELECT CEG.CodingElementGroupId
                                FROM GroupVerbatimEng GVE
                                    INNER JOIN CodingElementGroups CEG
                                        ON GVE.GroupVerbatimID = CEG.GroupVerbatimID
                                            AND CEG.DictionaryLocale = 'eng'
                                WHERE @searchString = '""'
                                    AND CEG.SegmentID = @segmentId
                            UNION ALL
                            SELECT CEG.CodingElementGroupId
                                FROM GroupVerbatimJpn GVJ
                                    INNER JOIN CodingElementGroups CEG
                                        ON GVJ.GroupVerbatimID = CEG.GroupVerbatimID
                                            AND CEG.DictionaryLocale = 'jpn'
                                WHERE @searchString = '""'
                                    AND CEG.SegmentID = @segmentId
                        ) AS d
                        INNER JOIN SegmentedGroupCodingPatterns SGCP
                            ON d.CodingElementGroupID = SGCP.CodingElementGroupID
                    WHERE SGCP.SynonymStatus = 1
            ) AS data
        GROUP BY CodingElementGroupId
    )

    SELECT TOP (@maxSearch)
        ROW_NUMBER() OVER (ORDER BY SGCP.SynonymManagementID) AS RowNUM,
        SGCP.*
        INTO #Results
        FROM VerbatimSearchFilter VSF
            INNER JOIN SegmentedGroupCodingPatterns SGCP
                ON VSF.CodingElementGroupID = SGCP.CodingElementGroupID
        WHERE SGCP.SynonymManagementID IN (SELECT SynonymListId FROM @synonymListFilter)
            AND SGCP.Updated BETWEEN @startDate AND @endDate
        ORDER BY SGCP.SynonymManagementID

    SELECT @totalCount = COUNT(1) FROM #Results

    SELECT * 
        FROM #Results
        WHERE RowNUM BETWEEN @startRowNumber AND @endRowNumber

    DROP TABLE #Results
	
GO 