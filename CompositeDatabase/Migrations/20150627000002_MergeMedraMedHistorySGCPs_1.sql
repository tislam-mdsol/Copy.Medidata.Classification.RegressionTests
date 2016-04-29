DECLARE @timeStamp DATETIME = GETUTCDATE()

DECLARE @levelCorrespondence TABLE(MedId INT, MedHistoryId INT, LevelKey VARCHAR(50))
INSERT INTO @levelCorrespondence(MedId, MedHistoryId, LevelKey)
VALUES 
(	81, 94,  'MedDRA-LLT'	),
(	80, 93,  'MedDRA-PT'	)

DECLARE @oldMedDRA VARCHAR(50) = 'MedDRAMedHistory'
DECLARE @newMedDRA VARCHAR(50) = 'MedDRA'

DECLARE @mappingTable TABLE(IdBefore INT, IdNext INT)

-- 1 - find meddrahistory CEG entries
;WITH CEG_MedHistory AS
(
	SELECT *
	FROM CodingElementGroups CEG
	WHERE CEG.MedicalDictionaryKey = @oldMedDRA
),
CEG AS
(
	SELECT *
	FROM CEG_MedHistory
		JOIN @levelCorrespondence L
			ON CEG_MedHistory.DictionaryLevelId_Backup = L.MedHistoryId
)

INSERT INTO @mappingTable(IdBefore, IdNext)
SELECT
    CEG.CodingElementGroupId,
	Y.NextCEGId
FROM CEG
	CROSS APPLY
	(	
		SELECT ISNULL(MIN(CEG_M.CodingElementGroupId), CEG.CodingElementGroupId) AS NextCEGId
		FROM CodingElementGroups CEG_M
		WHERE CEG_M.MedicalDictionaryKey = @newMedDRA
			AND CEG_M.GroupVerbatimId = CEG.GroupVerbatimId
			AND CEG_M.DictionaryLocale = CEG.DictionaryLocale
			AND CEG_M.MedicalDictionaryLevelKey = CEG.LevelKey
			AND CEG_M.SegmentId = CEG.SegmentId
			AND CEG_M.CompSuppCount = CEG.CompSuppCount
	) AS Y

-- 1.1. Fully match the compsupps
UPDATE m
SET m.IdNext = m.IdBefore
FROM @mappingTable m
	CROSS APPLY
	(
		SELECT CAST(CEGC.NameTextID AS VARCHAR) +':'+CAST(CEGC.SupplementFieldKeyId AS VARCHAR) + ';'
		FROM CodingElementGroupComponents CEGC
		WHERE CEGC.CodingElementGroupID = m.IdBefore
		ORDER BY NameTextID, SupplementFieldKeyId
		FOR XML PATH('')
	) AS CEGC_Before (CompositeKey)
	CROSS APPLY
	(
		SELECT CAST(CEGC.NameTextID AS VARCHAR) +':'+CAST(CEGC.SupplementFieldKeyId AS VARCHAR) + ';'
		FROM CodingElementGroupComponents CEGC
		WHERE CEGC.CodingElementGroupID = m.IdNext
		ORDER BY NameTextID, SupplementFieldKeyId
		FOR XML PATH('')
	) AS CEGC_Next (CompositeKey)
WHERE m.IdNext <> m.IdBefore 
	AND CEGC_Before.CompositeKey <> CEGC_Next.CompositeKey

-- 2. update the non-conflicting CEGs
UPDATE CEG
SET CEG.MedicalDictionaryLevelKey = L.LevelKey,
	CEG.MedicalDictionaryKey = @newMedDRA,
	Updated = @timeStamp
FROM @mappingTable MP
	JOIN CodingElementGroups CEG
        ON MP.IdBefore = CEG.CodingElementGroupId
        AND MP.IdNext = MP.IdBefore -- no conflict
	JOIN @levelCorrespondence L
		ON CEG.DictionaryLevelId_Backup = L.MedHistoryId
WHERE MP.IdNext = MP.IdBefore -- no conflict

DELETE @mappingTable
WHERE IdNext = IdBefore

-- 3. delete conflicting CEGs

-- 4 - Handle SGCPs
DECLARE @sgcpMapping TABLE(IdBefore INT, IdNext INT, IsEqualPattern BIT)

INSERT INTO @sgcpMapping (IdBefore, IdNext, IsEqualPattern)
SELECT 
	SGCP.SegmentedGroupCodingPatternID, 
	SGCP_Next.SegmentedGroupCodingPatternID,
	SGCP_Next.IsEqualPattern
FROM @mappingTable CPM
	JOIN SegmentedGroupCodingPatterns SGCP
		ON CPM.IdBefore = SGCP.CodingElementGroupId
	CROSS APPLY
	(
		SELECT 
			ISNULL(MIN(SGCP_Ordered.SegmentedGroupCodingPatternID), 0) AS SegmentedGroupCodingPatternID,
			ISNULL(MIN(SGCP_Ordered.IsEqualPattern)                , 0) AS IsEqualPattern
		FROM
		(
			SELECT TOP 1 *
			FROM
			(
				SELECT *, CASE WHEN SGCP_Inner.CodingPatternId = SGCP.CodingPatternId THEN 1 ELSE 0 END AS IsEqualPattern
				FROM SegmentedGroupCodingPatterns SGCP_Inner
				WHERE SGCP_Inner.SynonymManagementID = SGCP.SynonymManagementID
					AND SGCP_Inner.CodingElementGroupID = CPM.IdNext
			) AS SGCP_WithMatchingPattern
			ORDER BY IsEqualPattern DESC
		) AS SGCP_Ordered
	) AS SGCP_Next
WHERE SGCP_Next.SegmentedGroupCodingPatternID > 0

-- 4.3.0 - update duplicates SGCP to max synonym status
UPDATE SGCP_Next
SET SGCP_Next.SynonymStatus = SGCP.SynonymStatus,
	SGCP_Next.Updated = @timeStamp
FROM @sgcpMapping SM
	JOIN SegmentedGroupCodingPatterns SGCP
		ON SM.IdBefore = SGCP.SegmentedGroupCodingPatternID
		AND SM.IsEqualPattern = 1
	JOIN SegmentedGroupCodingPatterns SGCP_Next
		ON SGCP_Next.SegmentedGroupCodingPatternID = SM.IdNext
WHERE SGCP_Next.SynonymStatus < SGCP.SynonymStatus

-- REMOVE DUPLICATES (and update caches in CA & CE & BotElements)
UPDATE BE
SET BE.SegmentedCodingPatternID = SM.IdNext
FROM @sgcpMapping SM
	JOIN BotElements BE
		ON SM.IdBefore = BE.SegmentedCodingPatternID
WHERE SM.IsEqualPattern = 1

UPDATE CA
SET CA.SegmentedGroupCodingPatternID = SM.IdNext
FROM @sgcpMapping SM
	JOIN CodingAssignment CA
		ON SM.IdBefore = CA.SegmentedGroupCodingPatternID
WHERE SM.IsEqualPattern = 1

UPDATE CE
SET CE.AssignedSegmentedGroupCodingPatternID = SM.IdNext
FROM @sgcpMapping SM
	JOIN CodingElements CE
		ON SM.IdBefore = CE.AssignedSegmentedGroupCodingPatternID
WHERE SM.IsEqualPattern = 1

-- 4.3.1 remove duplicates
DELETE SGCP
FROM SegmentedGroupCodingPatterns SGCP
	JOIN @sgcpMapping SM
		ON SM.IdBefore = SGCP.SegmentedGroupCodingPatternID
		AND SM.IsEqualPattern = 1

-- 4.3.2 downgrade the conflicting synonyms
UPDATE SGCP
SET SGCP.SynonymStatus = 0
FROM @sgcpMapping SM
	JOIN SegmentedGroupCodingPatterns SGCP
		ON SM.IdBefore = SGCP.SegmentedGroupCodingPatternID
WHERE SGCP.SynonymStatus > 0

-- 4.3.3. update SGCP
UPDATE SGCP
SET SGCP.CodingElementGroupId = CPM.IdNext
FROM @mappingTable CPM
	JOIN SegmentedGroupCodingPatterns SGCP
		ON CPM.IdBefore = SGCP.CodingElementGroupId

-- 4.3.4 update Ce.CEGId
UPDATE CE
SET CE.CodingElementGroupId = CPM.IdNext
FROM @mappingTable CPM
	JOIN CodingElements CE
		ON CPM.IdBefore = CE.CodingElementGroupId

-- 4.3.5. clean up CEG
DELETE CEG
FROM @mappingTable CPM
	JOIN CodingElementGroups CEG
		ON CPM.IdBefore = CEG.CodingElementGroupId
