-- Background : the new CodingPath property in CodingPatterns may contain spaces
-- the encoding for the spaces is not always the same - resulting in multiple codingpatterns
-- for the same CodingPath

-- this procedure will rectify (merge duplicates) for the condition where a space
-- has been encoded with '%20'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_FixDuplicateCodingPatterns')
	DROP PROCEDURE CMP_FixDuplicateCodingPatterns
GO

CREATE PROCEDURE dbo.CMP_FixDuplicateCodingPatterns
AS  
BEGIN

	DECLARE @affectedCPs TABLE(ConflictId INT IDENTITY(1,1), IdBefore INT, IdNext INT, TotalConflicts INT)

    ;WITH affectedCPs AS
    (
	    SELECT 
			MAX(CodingPatternId) AS IdBefore, 
            MIN(CodingPatternId) AS IdNext, 
            MedicalDictionaryLevelKey, 
            REPLACE(CodingPath, '%20', ' ') AS NormalizedCodingPath,
			COUNT(1) AS TotalConflicts
	    FROM CodingPatterns
	    GROUP BY MedicalDictionaryLevelKey, REPLACE(CodingPath, '%20', ' ')
		HAVING COUNT(1) > 1
    )

	INSERT INTO @affectedCPs(IdBefore, IdNext, TotalConflicts)
	SELECT IdBefore, IdNext, TotalConflicts
	FROM affectedCPs

    -- cannot handle cases where conflicts exceed 2 (min, max won't capture the entire ids)
    IF EXISTS (SELECT NULL 
        FROM @affectedCPs
        WHERE TotalConflicts > 2)
    BEGIN
		SELECT * 
        FROM @affectedCPs
        WHERE TotalConflicts > 2
        RAISERROR('CodingPattern conflict complexity exceeds the scope of this fix', 1, 16)
        RETURN 0
    END

    -- merge SGCPs
    DECLARE @sgcpMapping TABLE(ConflictId INT IDENTITY(1,1), IdBefore INT, IdNext INT, TotalConflicts INT)

    INSERT INTO @sgcpMapping (IdBefore, IdNext, TotalConflicts)
    SELECT 
	    MIN(SGCP.SegmentedGroupCodingPatternId),
		MAX(SGCP.SegmentedGroupCodingPatternId),
		COUNT(1)
    FROM @affectedCPs ACP
	    JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.CodingPatternID IN (ACP.IdBefore, ACP.IdNext)
	GROUP BY SGCP.SynonymManagementID, SGCP.CodingElementGroupID, ACP.ConflictId
	HAVING COUNT(1) > 1

    -- cannot handle cases where conflicts exceed 2 (min, max won't capture the entire ids)
    IF EXISTS (SELECT NULL 
        FROM @sgcpMapping
        WHERE TotalConflicts > 2)
    BEGIN
		SELECT * 
        FROM @sgcpMapping
        WHERE TotalConflicts > 2
        RAISERROR('SegmentedGroupCodingPattern conflict complexity exceeds the scope of this fix', 1, 16)
        RETURN 0
    END

    -- solve SGCP Conflicts
    IF EXISTS (SELECT NULL FROM @sgcpMapping)
    BEGIN

        -- REMOVE DUPLICATES (and update caches in CA & CE & BotElements)
        UPDATE BE
        SET BE.SegmentedCodingPatternID = SM.IdNext
        FROM @sgcpMapping SM
	        JOIN BotElements BE
		        ON SM.IdBefore = BE.SegmentedCodingPatternID

        UPDATE CA
        SET CA.SegmentedGroupCodingPatternID = SM.IdNext
        FROM @sgcpMapping SM
	        JOIN CodingAssignment CA
		        ON SM.IdBefore = CA.SegmentedGroupCodingPatternID

        UPDATE CE
        SET CE.AssignedSegmentedGroupCodingPatternID = SM.IdNext
        FROM @sgcpMapping SM
	        JOIN CodingElements CE
		        ON SM.IdBefore = CE.AssignedSegmentedGroupCodingPatternID

        -- 4.3.1 remove duplicates
        DELETE SGCP
        FROM SegmentedGroupCodingPatterns SGCP
	        JOIN @sgcpMapping SM
		        ON SM.IdBefore = SGCP.SegmentedGroupCodingPatternID
    END

    -- 4.3.3. update SGCP
    UPDATE SGCP
    SET SGCP.CodingPatternId = ACP.IdNext
    FROM @affectedCPs ACP
	    JOIN SegmentedGroupCodingPatterns SGCP
		    ON ACP.IdBefore = SGCP.CodingPatternId

    -- Clean up CP
    DELETE CP
    FROM CodingPatterns CP
	    JOIN @affectedCPs ACP
		    ON CP.CodingPatternId = ACP.IdBefore

    UPDATE CodingPatterns
    SET CodingPath = REPLACE(CodingPath, '%20', ' ')
    WHERE CHARINDEX('%20', CodingPath) > 1


END