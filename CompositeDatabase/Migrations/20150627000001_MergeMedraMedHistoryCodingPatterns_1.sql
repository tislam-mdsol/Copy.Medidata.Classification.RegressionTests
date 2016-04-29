
DECLARE @levelCorrespondence TABLE(MedId INT, MedHistoryId INT, LevelKey VARCHAR(50))
INSERT INTO @levelCorrespondence(MedId, MedHistoryId, LevelKey)
VALUES 
(	81, 94,  'MedDRA-LLT'	),
(	80, 93,  'MedDRA-PT'	)

DECLARE @oldMedDRA VARCHAR(50) = 'MedDRAMedHistory'
DECLARE @newMedDRA VARCHAR(50) = 'MedDRA'

-- 1. Detect all MedDraMedHistory patterns
DECLARE @mappingTable TABLE(IdBefore INT, IdNext INT)

;WITH CP AS
(
	SELECT *
	FROM CodingPatterns
	WHERE MedicalDictionaryVersionLocaleKey LIKE 'MedDRAMedHistory%'
),
resolvedLevels AS
(
	SELECT *
	FROM CP
		JOIN @levelCorrespondence L
			ON CP.DictionaryLevelId_Backup = L.MedHistoryId
)

INSERT INTO @mappingTable(IdBefore, IdNext)
SELECT
    CP.CodingPatternId,
	Y.NextCodingPatternId
FROM resolvedLevels CP
	CROSS APPLY
	(	
		SELECT ISNULL(MIN(CodingPatternId), CP.CodingPatternId) AS NextCodingPatternId
		FROM CodingPatterns CP_M
		WHERE CP_M.MedicalDictionaryVersionLocaleKey LIKE 'MedDRA-%'
			AND CP_M.CodingPath = CP.CodingPath
			AND CP_M.DictionaryLevelId_Backup  = CP.MedId
	) AS Y

-- 2. update the non-conflicting patterns
UPDATE CP
SET MedicalDictionaryLevelKey         = L.LevelKey,
    MedicalDictionaryVersionLocaleKey = 
        REPLACE(REPLACE(CP.MedicalDictionaryVersionLocaleKey, @oldMedDRA, @newMedDRA), '.', '_')
FROM CodingPatterns CP
    JOIN @mappingTable MP
        ON MP.IdBefore = CP.CodingPatternId
        AND MP.IdNext = MP.IdBefore -- no conflict
	JOIN @levelCorrespondence L
		ON CP.DictionaryLevelId_Backup = L.MedHistoryId
WHERE MP.IdNext = MP.IdBefore -- no conflict

DELETE @mappingTable
WHERE IdNext = IdBefore

-- 3. merge conflicting patterns

-- 3.1. update SGCP
UPDATE SGCP
SET SGCP.CodingPatternID = CPM.IdNext
FROM SegmentedGroupCodingPatterns SGCP
	JOIN @mappingTable CPM
		ON CPM.IdBefore = SGCP.CodingPatternID

-- 3.2. clean up CP
DELETE CP
FROM CodingPatterns CP
	JOIN @mappingTable CPM
		ON CP.CodingPatternId = CPM.IdBefore
