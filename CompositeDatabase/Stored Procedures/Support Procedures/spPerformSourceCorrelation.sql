/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

-- EXEC spPerformSourceCorrelation 'UNTC'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spPerformSourceCorrelation')
	DROP PROCEDURE spPerformSourceCorrelation
GO
CREATE PROCEDURE dbo.spPerformSourceCorrelation
(
	-- Requirement 1 - Mandatory Scoped in Segment
	@SegmentName NVARCHAR(255)
)
AS
BEGIN

	SET NOCOUNT ON

	
	CREATE TABLE #CodingElementSourceKeys(
		CodingElementSourceKeyId INT NOT NULL IDENTITY(1,1),
		SourceSystemId INT NOT NULL,

		SourceKey VARBINARY(896) NOT NULL,
		IsTruncated BIT NOT NULL,

		CONSTRAINT [PK_CodingElementSourceKeys] PRIMARY KEY CLUSTERED 
	(
		CodingElementSourceKeyId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)


	
	CREATE UNIQUE INDEX UIX_CodingElementSourceKeys_One ON #CodingElementSourceKeys
	(
		SourceKey, 
		SourceSystemId
	)
	

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- verify params	
	DECLARE @SegmentId INT,
		@studyID INT

	SELECT @SegmentId = SegmentId
	FROM Segments
	WHERE SegmentName = @SegmentName

	IF (@SegmentId IS NULL)
	BEGIN
		RAISERROR(N'ERROR: No such Segment!', 16, 1)
		RETURN 0
	END

	DECLARE @minIDPresent INT

	SELECT @minIDPresent = ISNULL(MAX(CodingElementSourcePropertyId), -1)
	FROM #CodingElementSourceProperties

	-- Requirement 3 - Harvest all Rave sourcing identifiers
	;WITH xCTE
	AS
	(
		SELECT
			-- 1.c finally cast to xml
			-- http://social.msdn.microsoft.com/Forums/sqlserver/en-US/2625ec6c-d384-4417-a04f-0d68888fb5b3/slow-xml-shredding-problem-still-exists-in-2008-sp2-or-2008-r2-any-resolution-in-sight
			CONVERT(xml,
				-- 1.b simplify the XML into one schema and reduce the meta
				N'<ODM xmlns:mdsol="h" >'+
				REPLACE(SUBSTRING(X.C, CHARINDEX('<ClinicalData', X.C, 2), len(X.C)), '<mdsol:QueueItem', '<QueueItem')
				).query('.')
				AS XC,
				CR.CodingRequestId
		FROM CodingRequests CR
			LEFT JOIN #CodingElementSourceProperties CESP
				ON CR.CodingRequestId = CESP.CodingRequestId
			CROSS APPLY
			(
				-- 1. a cast to NVARCHAR as NTEXT can't be cast to xml
				SELECT C = CONVERT(NVARCHAR(MAX), XmlContent)
			) AS X
		WHERE CR.SegmentId = @SegmentId
			and dataLength(CR.XmlContent) >0
			AND CESP.CodingRequestId IS NULL
	)

	INSERT INTO #CodingElementSourceProperties
	(
		CodingElementId,
		CodingRequestId,

		StudyOID,
		SubjectKey,
		SiteOID,
		StudyEventOID,
		StudyEventRepeatKey,
		FormOID,
		FormRepeatKey,
		ItemGroupOID,
		ItemGroupRepeatKey,
		ItemOID,
		SourceIdentifier 
	)
	SELECT
		-1
		,CodingRequestId

		-- *** Source Properties
		,ISNULL(CL.DT.value('@StudyOID','VARCHAR(51)'), '') AS StudyOID
		,ISNULL(SB.DT.value('@SubjectKey','NVARCHAR(51)'), '') AS SubjectKey
		,ISNULL(ST.DT.value('@LocationOID','NVARCHAR(51)'), '') AS SiteOID
		,ISNULL(SED.DT.value('@StudyEventOID','VARCHAR(101)'), '') AS StudyEventOID
		,ISNULL(SED.DT.value('@StudyEventRepeatKey','VARCHAR(101)'), '') AS StudyEventRepeatKey
		,ISNULL(FM.DT.value('@FormOID','VARCHAR(101)'), '') AS FormOID
		,ISNULL(FM.DT.value('@FormRepeatKey','VARCHAR(101)'), '') AS FormRepeatKey
		,ISNULL(IGD.DT.value('@ItemGroupOID','VARCHAR(101)'), '') AS ItemGroupOID
		,ISNULL(IGD.DT.value('@ItemGroupRepeatKey','VARCHAR(11)'), '') AS ItemGroupRepeatKey
		,ISNULL(ID.DT.value('@ItemOID','VARCHAR(101)'), '') AS ItemOID
		,ISNULL(QI.DT.value('@OID','VARCHAR(101)'), '') AS SourceIdentifier

	FROM xCTE
		CROSS APPLY XC.nodes('ODM/ClinicalData') CL(DT)
		CROSS APPLY CL.DT.nodes('SubjectData') SB(DT)
		CROSS APPLY SB.DT.nodes('SiteRef') ST(DT)
		CROSS APPLY SB.DT.nodes('StudyEventData') SED(DT)
		CROSS APPLY SED.DT.nodes('FormData') FM(DT)
		CROSS APPLY FM.DT.nodes('ItemGroupData') IGD(DT)
		CROSS APPLY IGD.DT.nodes('ItemData') ID(DT)
		CROSS APPLY ID.DT.nodes('QueueItem') QI(DT)

	UPDATE CESP
	SET CodingElementId = CE.CodingElementId,
		-- Requirement 7: Identify Truncated data (if any)
		Truncated = 
		CASE WHEN LEN(StudyOID) > 50 THEN 1 ELSE 0 END +
		CASE WHEN LEN(SubjectKey) > 50 THEN 1 ELSE 0 END +
		CASE WHEN LEN(SiteOID) > 50 THEN 1 ELSE 0 END +
		CASE WHEN LEN(StudyEventOID) > 100 THEN 1 ELSE 0 END +
		CASE WHEN LEN(StudyEventRepeatKey) > 100 THEN 1 ELSE 0 END +
		CASE WHEN LEN(FormOID) > 100 THEN 1 ELSE 0 END +
		CASE WHEN LEN(FormRepeatKey) > 100 THEN 1 ELSE 0 END +
		CASE WHEN LEN(ItemGroupOID) > 100 THEN 1 ELSE 0 END +
		CASE WHEN LEN(ItemGroupRepeatKey) > 10 THEN 1 ELSE 0 END +
		CASE WHEN LEN(ItemOID) > 100 THEN 1 ELSE 0 END +
		CASE WHEN LEN(CESP.SourceIdentifier) > 100 THEN 1 ELSE 0 END
	FROM #CodingElementSourceProperties CESP
		JOIN CodingElements CE
			ON CE.SourceIdentifier = CESP.SourceIdentifier --Note: SourceIdentifier is from ODM mdsol:QueueItem OID while after Coder 2013.4.0 CodingElements(CE) table stores UUID as SourceIdentifier on CE table
			AND CE.CodingRequestId = CESP.CodingRequestId
	WHERE CESP.CodingElementSourcePropertyId > @minIDPresent

	DELETE FROM #CodingElementSourceProperties
	WHERE CodingElementId = -1
		AND CodingElementSourcePropertyId > @minIDPresent

	-- Requirement 4 : Group Same Datapoint sourcing tasks
	DECLARE @dlb VARBINARY(1) = CAST('|' AS VARBINARY(1))

	;WITH xCTE (SourceSystemId, SourceKey, Truncated)
	AS
	(
		SELECT CR.SourceSystemId,
			CAST(StudyOID AS VARBINARY(50)) + @dlb +
			CAST(SubjectKey AS VARBINARY(100)) + @dlb +
			CAST(SiteOID AS VARBINARY(100)) + @dlb +
			CAST(StudyEventOID AS VARBINARY(100)) + @dlb +
			CAST(StudyEventRepeatKey AS VARBINARY(100)) + @dlb +
			CAST(FormOID AS VARBINARY(100)) + @dlb +
			CAST(FormRepeatKey AS VARBINARY(100)) + @dlb +
			CAST(ItemGroupOID AS VARBINARY(100)) + @dlb +
			CAST(ItemGroupRepeatKey AS VARBINARY(10)) + @dlb +
			CAST(ItemOID AS VARBINARY(100)),
			CESP.Truncated
		FROM #CodingElementSourceProperties CESP
			JOIN CodingRequests CR
				ON CESP.CodingRequestId = CR.CodingRequestId
		WHERE CESP.CodingElementSourcePropertyId > @minIDPresent
	)

	-- if any data in the chain is truncated, then the whole key is truncated
	INSERT INTO #CodingElementSourceKeys (SourceSystemId, SourceKey, IsTruncated)
	SELECT x.SourceSystemId, x.SourceKey, CASE WHEN SUM(x.Truncated) > 0 THEN 1 ELSE 0 END
	FROM xCTE x
		LEFT JOIN #CodingElementSourceKeys CESK
			ON CESK.SourceSystemId = x.SourceSystemId
			AND CESK.SourceKey = x.SourceKey
	WHERE CESK.CodingElementSourceKeyId IS NULL
	GROUP BY x.SourceSystemId, x.SourceKey

	-- calculate the key Id for new ones
 	UPDATE CESP
	SET CESP.CodingElementSourceKeyId = CESK.CodingElementSourceKeyId
	FROM #CodingElementSourceProperties CESP
		CROSS APPLY
		(
			SELECT SourceSystemId
			FROM CodingRequests CRI
			WHERE CESP.CodingRequestId = CRI.CodingRequestId
		) AS CR
		JOIN #CodingElementSourceKeys CESK
			WITH (FORCESEEK)
			ON CESK.SourceSystemId = CR.SourceSystemId
			AND CESK.SourceKey = 
					CAST(StudyOID AS VARBINARY(50)) + @dlb +
					CAST(SubjectKey AS VARBINARY(100)) + @dlb +
					CAST(SiteOID AS VARBINARY(100)) + @dlb +
					CAST(StudyEventOID AS VARBINARY(100)) + @dlb +
					CAST(StudyEventRepeatKey AS VARBINARY(100)) + @dlb +
					CAST(FormOID AS VARBINARY(100)) + @dlb +
					CAST(FormRepeatKey AS VARBINARY(100)) + @dlb +
					CAST(ItemGroupOID AS VARBINARY(100)) + @dlb +
					CAST(ItemGroupRepeatKey AS VARBINARY(10)) + @dlb +
					CAST(ItemOID AS VARBINARY(100))
	WHERE CESP.CodingElementSourcePropertyId > @minIDPresent

	-- Rollup isChainTruncated
	-- NOTE: this may not scale well, especially if there's a lot of truncated keys
 	UPDATE CESP
	SET CESP.IsChainTruncated = 1
	FROM #CodingElementSourceKeys CESK
		JOIN #CodingElementSourceProperties CESP
			ON CESP.CodingElementSourceKeyId = CESK.CodingElementSourceKeyId
	WHERE CESK.IsTruncated = 1

	-- Requirement 5 : Identify & Select only the last task representing a datapoint request (ignore past ones)
	-- NOTE : potential OPT to recompute only given segment & added data (requires extra join)
	;WITH xCTE AS
	(
		SELECT CodingElementId, CodingElementSourceKeyId,
			ROW_NUMBER() OVER(
			PARTITION BY CodingElementSourceKeyId ORDER BY CodingElementId ASC) AS RowNum
		FROM #CodingElementSourceProperties
		WHERE NextCodingElementId = -1
	)

	UPDATE CESP
	SET CESP.NextCodingElementId = n.CodingElementId
	FROM xCTE p
		JOIN xCTE n
			ON p.CodingElementSourceKeyId = n.CodingElementSourceKeyId
			AND n.RowNum = p.RowNum + 1
		JOIN #CodingElementSourceProperties CESP
			ON p.CodingElementId = CESP.CodingElementId

	DROP TABLE #CodingElementSourceKeys
END
GO