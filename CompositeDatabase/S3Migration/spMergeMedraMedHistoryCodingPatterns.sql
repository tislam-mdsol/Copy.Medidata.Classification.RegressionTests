IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMergeMedraMedHistoryCodingPatterns')
BEGIN
	DROP PROCEDURE dbo.spMergeMedraMedHistoryCodingPatterns
END
GO

CREATE PROCEDURE dbo.spMergeMedraMedHistoryCodingPatterns
AS
BEGIN

    DECLARE @levelCorrespondence TABLE(MedHistoryId INT, LevelKey VARCHAR(50))
    INSERT INTO @levelCorrespondence(MedHistoryId, LevelKey)
    VALUES 
    (	94,  'MedDRA-LLT'	),
    (	93,  'MedDRA-PT'	)

    DECLARE @oldMedDRA VARCHAR(50) = 'MedDRAMedHistory'
    DECLARE @newMedDRA VARCHAR(50) = 'MedDRA'

    -- 1. Detect all MedDraMedHistory patterns
    DECLARE @oldMedPatterns TABLE(IdBefore INT, IdNext INT)

    ;WITH CP AS
    (
	    SELECT *
	    FROM CodingPatterns
	    WHERE MedicalDictionaryVersionLocaleKey LIKE 'MedDRAMedHistory%'
    ),
    CorrectPath AS
    (
	    SELECT CP.CodingPatternId, X.NewPath
	    FROM CP
		    CROSS APPLY
		    (
			    SELECT NewPath = REPLACE(CP.CodingPath, @oldMedDRA, @newMedDRA)
		    ) AS Y 
            CROSS APPLY
            (
                SELECT NewPath = REPLACE(Y.NewPath, '.', '_')
            ) X
    )

    INSERT INTO @oldMedPatterns(IdBefore, IdNext)
    SELECT
        CP.CodingPatternId,
	    Y.NextCodingPatternId
    FROM CorrectPath CP
	    CROSS APPLY
	    (
		    SELECT ISNULL(MIN(CodingPatternId), CP.CodingPatternId) AS NextCodingPatternId
		    FROM CodingPatterns CP_M
		    WHERE CP_M.MedicalDictionaryVersionLocaleKey LIKE 'MedDRA-%'
			    AND CP_M.CodingPath = CP.NewPath
	    ) AS Y

    -- 2. update the non-conflicting patterns
    UPDATE CP
    SET CodingPath                        = 
            REPLACE(REPLACE(CP.CodingPath, @oldMedDRA, @newMedDRA), '.', '_'),
    	MedicalDictionaryLevelKey         = L.LevelKey,
    	MedicalDictionaryVersionLocaleKey = 
            REPLACE(REPLACE(CP.MedicalDictionaryVersionLocaleKey, @oldMedDRA, @newMedDRA), '.', '_')
    FROM CodingPatterns CP
        JOIN @oldMedPatterns MP
            ON MP.IdBefore = CP.CodingPatternId
            AND MP.IdNext = MP.IdBefore -- no conflict
	    JOIN @levelCorrespondence L
		    ON CP.DictionaryLevelId_Backup = L.MedHistoryId
    WHERE MP.IdNext = MP.IdBefore -- no conflict

    DELETE @oldMedPatterns
    WHERE IdNext = IdBefore

    -- 3. merge conflicting patterns

    -- 3.1. update SGCP
    UPDATE SGCP
    SET SGCP.CodingPatternID = CPM.IdNext
    FROM SegmentedGroupCodingPatterns SGCP
	    JOIN @oldMedPatterns CPM
		    ON CPM.IdBefore = SGCP.CodingPatternID

    -- 3.2. clean up CP
    DELETE CP
    FROM CodingPatterns CP
	    JOIN @oldMedPatterns CPM
		    ON CP.CodingPatternId = CPM.IdBefore
	
END