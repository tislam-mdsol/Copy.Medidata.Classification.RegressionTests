-- New Tables
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
		 )
	CREATE TABLE CodingElementGroups
	(
		CodingElementGroupID BIGINT IDENTITY(1,1) NOT NULL,
		VerbatimText NVARCHAR(450) NOT NULL, -- 450 limitation so that if needed it can be indexed (FT)
		MedicalDictionaryID INT NOT NULL,
		DictionaryLevelID INT NOT NULL,
		--DictionaryVersionID INT NOT NULL, can be changed on runtime... so group on runtime
		DictionaryLocale CHAR(3) NOT NULL,
		SegmentID INT NOT NULL,
		HasComponents BIT NOT NULL CONSTRAINT DF_CodingElementGroups_HasComponents DEFAULT((0)),
		
		ProgrammaticAuxiliary BIGINT NOT NULL CONSTRAINT DF_CodingElementGroups_ProgrammaticAuxiliary DEFAULT((0)),
		
		Created DATETIME NOT NULL CONSTRAINT DF_CodingElementGroups_Created DEFAULT((GETUTCDATE())),
		Updated DATETIME NOT NULL CONSTRAINT DF_CodingElementGroups_Updated DEFAULT((GETUTCDATE())),
	 CONSTRAINT PK_CodingElementGroups PRIMARY KEY CLUSTERED 
	(
		CodingElementGroupID ASC
	)
	)
GO	

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroupComponents'
		 )
	CREATE TABLE CodingElementGroupComponents
	(
		CodingElementGroupComponentID BIGINT IDENTITY(1,1) NOT NULL,
		CodingElementGroupID BIGINT NOT NULL,
		ComponentTypeID INT NOT NULL,
		NameText NVARCHAR(450),
		CodeText NVARCHAR(50),
		SearchType INT,
		SearchOperator INT,

		Created DATETIME NOT NULL CONSTRAINT DF_CodingElementGroupComponents_Created DEFAULT((GETUTCDATE())),
		Updated DATETIME NOT NULL CONSTRAINT DF_CodingElementGroupComponents_Updated DEFAULT((GETUTCDATE())),
	 CONSTRAINT PK_CodingElementGroupComponents PRIMARY KEY CLUSTERED 
	(
		CodingElementGroupComponentID ASC
	)
	)
GO	

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 )
	CREATE TABLE CodingPatterns
	(
		CodingPatternID BIGINT IDENTITY(1,1) NOT NULL,
		--DictionaryVersionID INT NOT NULL,
		DictionaryLocale CHAR(3) NOT NULL,
		IsPrimaryPath BIT NOT NULL CONSTRAINT DF_CodingPatterns_IsPrimaryPath DEFAULT((0)), -- meddra like specific...
		MedicalDictionaryTermID BIGINT NOT NULL CONSTRAINT DF_CodingPatterns_MedicalDictionaryTermID DEFAULT((-1)),
		CodingPath VARCHAR(300) NOT NULL CONSTRAINT DF_CodingPatterns_CodingPath DEFAULT(('')),

		Created DATETIME NOT NULL CONSTRAINT DF_CodingPatterns_Created DEFAULT((GETUTCDATE())),
		Updated DATETIME NOT NULL CONSTRAINT DF_CodingPatterns_Updated DEFAULT((GETUTCDATE())),
	 CONSTRAINT PK_CodingPatterns PRIMARY KEY CLUSTERED 
	(
		CodingPatternID ASC
	)
	)
GO	

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		 )
	CREATE TABLE SegmentedGroupCodingPatterns
	(
		SegmentedGroupCodingPatternID BIGINT IDENTITY(1,1) NOT NULL,
		CodingElementGroupID BIGINT NOT NULL CONSTRAINT DF_GroupCodingPatterns_CodingElementGroupID DEFAULT((-1)),
		CodingPatternID BIGINT NOT NULL,
		DictionaryVersionID INT NOT NULL,
		SegmentID INT,
		--CodingStatus INT NOT NULL CONSTRAINT DF_GroupCodingPatterns_CodingStatus DEFAULT((0)), 
		-- { waiting_approval, active, inactive } -- mimics the synonym
		MatchPercent DECIMAL NOT NULL CONSTRAINT DF_GroupCodingPatterns_MatchPercent DEFAULT((0)),

		IsValidForAutoCode BIT NOT NULL CONSTRAINT DF_GroupCodingPatterns_IsValidForAutoCode DEFAULT((0)),
		Active BIT NOT NULL CONSTRAINT DF_GroupCodingPatterns_Active DEFAULT((0)),
		AssociatedSynonymTermID BIGINT NOT NULL CONSTRAINT DF_GroupCodingPatterns_AssociatedSynonymTermID DEFAULT((-1)),

		Created DATETIME NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_Created DEFAULT((GETUTCDATE())),
		Updated DATETIME NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_Updated DEFAULT((GETUTCDATE())),
	 CONSTRAINT PK_SegmentedGroupCodingPatterns PRIMARY KEY CLUSTERED 
	(
		SegmentedGroupCodingPatternID ASC
	)
	)
GO	

IF (NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_SegmentedGroupCodingPatterns_SinglePerGroup'))
BEGIN
	CREATE UNIQUE INDEX UIX_SegmentedGroupCodingPatterns_SinglePerGroup ON SegmentedGroupCodingPatterns
	(
		CodingElementGroupId,
		DictionaryVersionID,
		SegmentID
	)
	WHERE Active = 1
		AND IsValidForAutoCode = 1
END

IF (NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_SegmentedGroupCodingPatterns_Multi'))
BEGIN
	CREATE UNIQUE INDEX UIX_SegmentedGroupCodingPatterns_Multi ON SegmentedGroupCodingPatterns
	(
		CodingElementGroupId,
		CodingPatternID,
		DictionaryVersionID,
		SegmentID
	)
	WHERE Active = 1
END

IF (NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_SegmentedGroupCodingPatterns_AssocSyn'))
BEGIN
	CREATE INDEX UIX_SegmentedGroupCodingPatterns_AssocSyn ON SegmentedGroupCodingPatterns
	(
		AssociatedSynonymTermID
	)
END

IF (NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_CodingPatterns_Multi'))
BEGIN
	CREATE UNIQUE INDEX UIX_CodingPatterns_Multi ON CodingPatterns
	(
		DictionaryLocale,
		MedicalDictionaryTermID,
		CodingPath
	)
END

-- TODO: Foreign key : { pattern, dictionary, segment, synonym }
-- TODO: this means that the synonym can be reactivated.... - how will this work 
-- with synonym auditing/history... - need revision of synonym auditing logic?????
-- OR... same as per synonyms, create new active segmentedcodingpattern... [favor this one]
-- the second version will allow for perfect auditing at the cost of dangling (historical)
-- references


-- TODO : determine if grouping criteria will be the same or will vary across segments
-- if it will vary, how will runtime changes be accomodated - timewise?

-- Alter existing tables
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
	 AND COLUMN_NAME = 'CodingElementGroupID'))
BEGIN
	ALTER TABLE CodingElements
	ADD CodingElementGroupID BIGINT NOT NULL CONSTRAINT DF_CodingElements_CodingElementGroupID DEFAULT((-1))
END
GO

-- eval whether to drop table sourcetermcomponents

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
	 AND COLUMN_NAME = 'SegmentedGroupCodingPatternID'))
BEGIN
	ALTER TABLE CodingAssignment
	ADD SegmentedGroupCodingPatternID BIGINT NOT NULL CONSTRAINT DF_CodingAssignment_SegmentedGroupCodingPatternID DEFAULT((-1))
	-- TODO : foreign key the coding pattern link
	-- TODO : drop 1) matchpercent, 2) isvalidforautocode, 3) medicaldictionarytermid, 4) codingpath
	-- (cont'd) 5) synonymtermid, 6) sourcesynonymtermid, 7) isPrimary
END
GO

-- SQL modify existing tables part

-- 1. rebuild coding patterns from past coding decisions (todo : what about synonyms?)
IF NOT EXISTS (SELECT NULL FROM CodingPatterns)
BEGIN

	INSERT INTO CodingPatterns
	(MedicalDictionaryTermID, CodingPath, dictionarylocale, isprimarypath)
	SELECT
		y.termid, y.newPath, y.dlocale,
		CASE WHEN REPLACE(dbo.fnGetPrimaryNodepathFromNodepath(MDT.NodePath), '*', '') = y.newPath
			THEN 1
			ELSE 0
		END
	FROM 
	(
		SELECT
			ca.MedicalDictionaryTermID as termid, 
			X.newPath, 
			ce.DictionaryLocale as dlocale
		FROM CodingAssignment CA
			JOIN CodingElements CE
				ON CA.CodingElementID = CE.CodingElementId
			CROSS APPLY 
			(
				SELECT newPath = dbo.fnFixCodingPatternNodePath(CA_X.CodingPath)
				FROM CodingAssignment CA_X
				WHERE CA.CodingAssignmentID = CA_X.CodingAssignmentID
			) X
		GROUP BY ca.MedicalDictionaryTermID, 
			X.newPath,
			ce.DictionaryLocale
	) AS Y
		JOIN MedicalDictionaryTerm MDT
			ON Y.termid = MDT.TermId

END
GO

--2. Rebuild groups
IF NOT EXISTS (SELECT NULL FROM CodingElementGroups)
BEGIN

	-- 2.1 get first the ones that don't have components
	INSERT INTO CodingElementGroups
	(VerbatimText, MedicalDictionaryID, DictionaryLocale, DictionaryLevelId, SegmentID, HasComponents)
	SELECT CE.VerbatimTerm AS VT, 
		MDV.MedicalDictionaryId AS MD, 
		CE.DictionaryLocale AS DL, 
		CE.DictionaryLevelId AS DLID,
		CE.SegmentId AS SG,
		0
	FROM CodingElements CE
		join MedicalDictionaryVersion MDV
			ON CE.DictionaryVersionId = MDV.DictionaryVersionId
		JOIN CodingSourceTerms CST
			ON CE.CodingElementID = CST.CodingElementID
		LEFT JOIN CodingSourceTermComponents CSTC
			ON CSTC.CodingSourceTermID = CST.CodingSourceTermId
	WHERE CE.CodingElementGroupID < 1
		AND CSTC.CodingSourceTermID IS NULL
	GROUP BY CE.VerbatimTerm, 
		MDV.MedicalDictionaryId, 
		CE.DictionaryLocale, 
		CE.DictionaryLevelId,
		CE.SegmentId
	
	UPDATE CE
	SET CE.CodingElementGroupID = CEG.CodingElementGroupID
	from CodingElements CE
		JOIN CodingSourceTerms CST
			ON CE.CodingElementID = CST.CodingElementID
		LEFT JOIN CodingSourceTermComponents CSTC
			ON CSTC.CodingSourceTermID = CST.CodingSourceTermId
		join MedicalDictionaryVersion MDV
			ON CE.DictionaryVersionId = MDV.DictionaryVersionId
		join CodingElementGroups CEG
			ON CEG.MedicalDictionaryID = MDV.MedicalDictionaryId
			AND CEG.DictionaryLocale = CE.DictionaryLocale
			AND CEG.VerbatimText = CE.verbatimterm
			AND CEG.DictionaryLevelId = CE.DictionaryLevelId
			AND CEG.SegmentId = CE.SegmentId
	WHERE CE.CodingElementGroupID < 1
		AND CSTC.CodingSourceTermID IS NULL

END
GO

-- 2a rebuild coding components
IF NOT EXISTS (SELECT NULL FROM CodingElementGroupComponents)
BEGIN

	DECLARE @ComponentGroups TABLE(ID INT IDENTITY(1,1), CodingElementGroupId BIGINT, CodingElementID BIGINT, RowNum INT)

	-- 2.2 get the ones that do have components
	INSERT INTO @ComponentGroups
	(CodingElementGroupId, CodingElementID, RowNum)
	SELECT 
		-1,
		CE.CodingElementId,
		ROW_NUMBER() OVER(PARTITION BY CE.VerbatimTerm, 
			MDV.MedicalDictionaryId, 
			CE.DictionaryLocale, 
			CE.DictionaryLevelId,
			CE.SegmentId,
			M.list ORDER BY CE.CodingElementId ASC)
	from CodingElements CE
		join MedicalDictionaryVersion MDV
			ON CE.DictionaryVersionId = MDV.DictionaryVersionId
			CROSS APPLY 
			(
				SELECT CAST(CSTC.ComponentTypeID AS VARCHAR) + '.'+
					CAST(CSTC.SearchType AS VARCHAR) + '.' + CAST(CSTC.SearchOperator AS VARCHAR) + '.' +
					CSTC.ComponentValue + '.'
					AS [text()] 
				FROM CodingSourceTerms CST
					JOIN CodingSourceTermComponents CSTC
						ON CSTC.CodingSourceTermID = CST.CodingSourceTermId				
				WHERE CE.CodingElementID = CST.CodingElementID
				ORDER BY CSTC.ComponentTypeID ASC
				FOR XML PATH('')
			) M (list)					
	WHERE CE.CodingElementGroupID < 1
		AND M.list IS NOT NULL
		
	DECLARE @startCodingElementGroupID BIGINT
	SELECT @startCodingElementGroupID = MAX(CodingElementGroupID)
	FROM CodingElementGroups
	
	INSERT INTO CodingElementGroups
	(VerbatimText, MedicalDictionaryID, DictionaryLocale, DictionaryLevelId, SegmentID, HasComponents)
	SELECT CE.VerbatimTerm, MDV.MedicalDictionaryID, CE.DictionaryLocale, CE.DictionaryLevelId, CE.SegmentID, 1
	FROM CodingElements CE
		JOIN @ComponentGroups CG
			ON CE.CodingElementId = CG.CodingElementID
			AND CG.RowNum = 1
		JOIN MedicalDictionaryVersion MDV
			ON CE.DictionaryVersionId = MDV.DictionaryVersionId
			AND CE.CodingElementGroupID = -1
	ORDER BY CG.ID ASC
		
	;WITH xCTE (MatchedRowNum, ID)
	AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY ID ASC), ID
		FROM @ComponentGroups CG
		WHERE CG.RowNum = 1
	)
	-- set the groupids for the first codingelementids
	UPDATE CG
	SET CodingElementGroupId = @startCodingElementGroupId + xCTE.MatchedRowNum
	FROM @ComponentGroups CG
		JOIN xCTE
			ON CG.ID = xCTE.ID
	WHERE CG.RowNum = 1
	
	INSERT INTO CodingElementGroupComponents
	(CodingElementGroupID, componenttypeid, nametext, codetext, searchtype, searchoperator)
	SELECT CG.CodingElementGroupID, componenttypeid, ComponentValue, '', CSTC.searchtype, searchoperator
	FROM CodingSourceTermComponents CSTC
		JOIN CodingSourceTerms CST
			ON CSTC.CodingSourceTermID = CST.CodingSourceTermId
		JOIN @ComponentGroups CG
			ON CG.CodingElementID = CST.CodingElementID
			AND CG.RowNum = 1
	GROUP BY CG.CodingElementGroupID, componenttypeid, ComponentValue, CSTC.searchtype, searchoperator
	
	-- set the groupids for the rest of codingelementids
	;WITH xCTE (ID, CodingElementGroupId, RowNum)
	AS(
		SELECT ID, CodingElementGroupId, RowNum
		FROM @ComponentGroups 
		WHERE rownum = 1
		UNION ALL
		SELECT CG.ID, xCTE.CodingElementGroupId, CG.RowNum
		FROM @ComponentGroups CG
			JOIN xCTE
				ON CG.RowNum = xCTE.RowNum + 1
				AND CG.ID = xCTE.ID + 1
	)

	UPDATE CG
	SET CG.CodingElementGroupId = xCTE.CodingElementGroupId
	FROM @ComponentGroups CG
		JOIN xCTE
			ON CG.ID = xCTE.ID
			AND xCTE.RowNum > 1
	
	-- update codingelements
	UPDATE CE
	SET CE.CodingElementGroupID = CG.CodingElementGroupID
	FROM CodingElements CE
		JOIN @ComponentGroups CG
			ON CE.CodingElementId = CG.CodingElementId 

END
GO

-- test component correct creation
--select * 
--from CodingElementGroupComponents CEGC
--	JOIN CodingElementGroups CEG
--		ON CEGC.CodingElementGroupID = CEG.CodingElementGroupID

-- 4. populate segmentedpatterns
IF NOT EXISTS (SELECT NULL FROM SegmentedGroupCodingPatterns)
BEGIN
	;with xcte (cegid, versionid, validforauto, active, SynTermid, Mpercent, patternid, sgid)
	as
	(
	select ce.CodingElementGroupID, CE.DictionaryVersionID, --WT.WorkflowStateID,
		--CE.CodingElementId, CA.CodingAssignmentID,
		MIN(CAST(CA.IsValidForAutoCode & CA.Active & CASE WHEN ISNULL(CA.SourceSynonymTermID, ISNULL(CA.SynonymTermID,-1)) < 1 THEN CAST(0 AS BIT) ELSE CAST(1 AS Bit) END AS INT)),
		CA.Active,
		ISNULL(CA.SourceSynonymTermID, ISNULL(CA.SynonymTermID, -1)),
		MAX(ISNULL(CA.MatchPercent, 0)),
		CD.CodingPatternID,
		ce.SegmentId
	from CodingElements CE
		JOIN CodingAssignment CA
			ON CE.CodingElementId = CA.CodingElementID
		JOIN CodingElementGroups CEG
			ON CEG.CodingElementGroupID = CE.CodingElementGroupID
		--join WorkflowTasks WT
		--	ON WT.WorkflowTaskID = CE.WorkflowTaskId
		JOIN CodingPatterns CD
			ON CD.MedicalDictionaryTermID = CA.MedicalDictionaryTermID
			AND CD.CodingPath = dbo.fnFixCodingPatternNodePath(CA.CodingPath)
			AND CD.DictionaryLocale = CE.DictionaryLocale
	group by 
		ce.CodingElementGroupID, 
		CE.DictionaryVersionID, 
		CA.Active,
		ISNULL(CA.SourceSynonymTermID, ISNULL(CA.SynonymTermID, -1)),
		CD.CodingPatternID,
		ce.SegmentId --, WT.WorkflowStateID
	)
	
	
	--select patternid,
	--	cegid, 
	--	versionid, --CA.SourceSynonymTermID, CA.SynonymTermID,
	--	sgid
	--	--validforauto,
	--	--Active,
	--	--Mpercent,
	--from xcte
	--WHERE Active = 1
	--	and NOT
	--	(cegid = 4591 AND versionid = 3 AND syntermid = 1216541 and patternid = 1083 and sgid = 1
	--	and validforauto = 1)
	--group by patternid,
	--	cegid, 
	--	versionid, --CA.SourceSynonymTermID, CA.SynonymTermID,
	--	sgid
	--having COUNT(*) > 1

	--select *
	--from xcte
	--WHERE Active = 1
	--	and patternid = 1080
	--	--and validforauto = 1
	--	and cegid = 4778 
	--	and versionid = 3 --CA.SourceSynonymTermID, CA.SynonymTermID,
	--	and sgid = 8

	INSERT INTO SegmentedGroupCodingPatterns
	(CodingPatternID, CodingElementGroupID, DictionaryVersionID, SegmentID, 
		IsValidForAutoCode, active, AssociatedSynonymTermID, MatchPercent)
	SELECT xcte.patternid,
		xcte.cegid, 
		xcte.versionid, --CA.SourceSynonymTermID, CA.SynonymTermID,
		xcte.sgid,
		validforauto,
		Active,
		SynTermid,
		Mpercent
	FROM xcte
		LEFT JOIN
		(
		select patternid,
			cegid, 
			versionid, --CA.SourceSynonymTermID, CA.SynonymTermID,
			sgid
			--validforauto,
			--Active,
			--Mpercent,
		from xcte
		WHERE Active = 1
			--and NOT
			--(cegid = 4591 AND versionid = 3 AND syntermid = 1216541 and patternid = 2156 and sgid = 1
			--and validforauto = 1)
		group by patternid,
			cegid, 
			versionid, --CA.SourceSynonymTermID, CA.SynonymTermID,
			sgid
		having COUNT(*) > 1	
		) AS X
			ON X.cegid = xcte.cegid
			AND X.versionid = xcte.versionid
			and X.sgid = xcte.sgid
			and X.patternid = xcte.patternid
	WHERE (X.cegid IS NULL OR xcte.SynTermid > 0)
	-- exception list (wrong past data)
	--AND	NOT
	--	(xcte.cegid = 4591 AND xcte.versionid = 3 AND xcte.syntermid = 1216541 and xcte.patternid = 2156 and xcte.sgid = 1
	--	and xcte.validforauto = 1)
	
	--INSERT INTO SegmentedGroupCodingPatterns
	--(CodingPatternID, CodingElementGroupID, DictionaryVersionID, SegmentID, 
	--	IsValidForAutoCode, active, AssociatedSynonymTermID, MatchPercent)
	--values(2156, 4591, 3, 1, 0, 1, 1216541, 37)

	-- update coding assignments with coding pattern info
	update CA
	set CA.SegmentedGroupCodingPatternid = SGCP.SegmentedGroupCodingPatternID
	FROm CodingAssignment CA
		JOIN CodingPatterns CD
			ON CA.MedicalDictionaryTermID = CD.MedicalDictionaryTermID
			AND CD.CodingPath = dbo.fnFixCodingPatternNodePath(CA.CodingPath)
		join SegmentedGroupCodingPatterns SGCP
			on SGCP.segmentid = CA.SegmentId
			and SGCP.codingpatternid = CD.codingpatternid
			--and SGCP.IsValidForAutoCode = CA.IsValidForAutoCode
			--and SGCP.AssociatedSynonymTermID = ISNULL(CA.SourceSynonymTermID, ISNULL(CA.SynonymTermID, 0))
			and sgcp.active = CA.Active
		join CodingElements cE
			on CE.CodingElementId = CA.CodingElementID
			AND SGCP.CodingElementGroupID = CE.CodingElementGroupID
			and SGCP.DictionaryVersionID = CE.DictionaryVersionID
			
END

-- 5. reconcile synonyms with patterns
-- 5.1 cannot have validforauto and inactive patterns
UPDATE SegmentedGroupCodingPatterns
SET IsValidForAutoCode = 0
WHERE Active = 0 and IsValidForAutoCode = 1	

-- 5.2 cannot have validforauto when inactive synonym
UPDATE  SGCP
SET SGCP.IsValidForAutoCode = 0
FROM SegmentedGroupCodingPatterns SGCP
	LEFT JOIN MedicalDictionaryTerm MDT
		ON SGCP.AssociatedSynonymTermID = MDT.TermId
WHERE SGCP.Active = 1
	AND SGCP.IsValidForAutoCode = 1
	AND (MDT.TermID IS NULL OR MDT.TermStatus <> 1)

-- 5.2 cannot have active synonym when not validforauto
UPDATE MDT
SET MDT.TermStatus = 2 -- set to retired
FROM SegmentedGroupCodingPatterns SGCP
	JOIN MedicalDictionaryTerm MDT
		ON SGCP.AssociatedSynonymTermID = MDT.TermId
		AND SGCP.Active = 1
		AND SGCP.IsValidForAutoCode = 0
		AND MDT.TermStatus = 1
		
-- 5.3 cannot have active/provisional synonyms when pattern does not exist
UPDATE MDT
SET MDT.TermStatus = 2 -- set to retired
FROM MedicalDictionaryTerm MDT
	LEFT JOIN SegmentedGroupCodingPatterns SGCP
		ON SGCP.AssociatedSynonymTermID = MDT.TermId
		AND SGCP.Active = 1
		AND SGCP.IsValidForAutoCode = 1
WHERE SGCP.AssociatedSynonymTermID IS NULL
	AND	MDT.TermStatus IN (0, 1)
	AND MDT.TermType IN (0, 3) -- only synonyms
