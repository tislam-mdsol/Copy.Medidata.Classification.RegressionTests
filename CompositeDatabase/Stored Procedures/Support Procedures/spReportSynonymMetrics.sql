IF EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spReportSynonymMetrics')
	DROP PROCEDURE dbo.spReportSynonymMetrics
GO

-- EXEC spReportSynonymMetrics 'HD_DDE_B2', NULL

CREATE PROCEDURE [dbo].[spReportSynonymMetrics]
(
	@dictionaryOID VARCHAR(50),
	@startDate DATETIME -- SET NULL to compute from the beginning
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @dictionaryID INT

	-- resolve OID into ID
	SELECT @dictionaryID = DictionaryRefId
	FROM DictionaryRef
	WHERE OID = @dictionaryOID

	IF (@dictionaryID IS NULL)
	BEGIN
		PRINT 'Dictionary NOT FOUND'
		RETURN 0
	END

	-- compute monthly ranges
	DECLARE @startIntervalDate DATETIME = ISNULL(@startDate, '2012-04-02 13:59:03.666'),
		@nextIntervalDate DATETIME
	DECLARE @dateRange TABLE(ID INT IDENTITY(1, 1), MinDate DATETIME, MaxDate DATETIME)
	
	WHILE (@startIntervalDate < GETUTCDATE())
	BEGIN

		SET @nextIntervalDate = DATEADD(month, 1, @startIntervalDate)
		INSERT INTO @dateRange (MinDate, MaxDate)
		VALUES(@startIntervalDate, @nextIntervalDate)

		SET @startIntervalDate = @nextIntervalDate
	END

	;WITH 
		rawdata AS
		(
			SELECT 
				COUNT(*) AS CC,
				SGCP.SynonymManagementID, 
				SGCP.IsExactMatch,
				SGCP.SynonymStatus,
				DR.ID AS DateRangeId,
				x.inUse
			FROM SynonymMigrationMngmt smm
				JOIN SegmentedGroupCodingPatterns SGCP
					ON smm.SynonymMigrationMngmtID = SGCP.SynonymManagementID
					AND smm.MedicalDictionaryID = @dictionaryID
				JOIN @dateRange DR
					ON SGCP.Updated >= DR.MinDate 
					AND SGCP.Updated < DR.MaxDate
				CROSS APPLY
				(
					SELECT inUse = CASE WHEN ISNULL( COUNT(*), 0) > 0 THEN 1 ELSE 0 END
					FROM CodingElements CE
					WHERE CE.AssignedSegmentedGroupCodingPatternId = SGCP.SegmentedGroupCodingPatternID
				) AS X
			GROUP BY 
				SGCP.SynonymManagementID, 
				SGCP.IsExactMatch,
				SGCP.SynonymStatus,
				DR.ID,
				x.inUse
		)


	SELECT 'SynonymsUpdated' AS SynonymsUpdated,
			smm.ListName, s.SegmentName,
			DR.MinDate, DR.MaxDate,
			DVR.OID AS DictionaryVersion,
			CASE WHEN g.SynonymStatus = 0 
				THEN 'NotSynonym'
				WHEN g.SynonymStatus = 1
				THEN 'ProvisionalSynonyms'
				ELSE 'Synonym'
			END AS SynonymStatus,
			g.inUse,
			g.CC AS TOTALCOUNT
	FROM rawdata g
		JOIN SynonymMigrationMngmt smm
			ON smm.SynonymMigrationMngmtID = g.SynonymManagementID
		JOIN DictionaryVersionRef DVR
			ON smm.DictionaryVersionId = DVR.DictionaryVersionRefID
		JOIN @dateRange DR
			ON DR.ID = g.DateRangeId
		JOIN segments s
			ON s.SegmentId = smm.SegmentID
	ORDER BY S.SegmentName, smm.ListName, DVR.OID
 
END

