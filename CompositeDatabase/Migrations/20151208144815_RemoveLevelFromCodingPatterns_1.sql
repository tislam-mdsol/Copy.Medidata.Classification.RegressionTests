IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CodingPatterns_Backup')
	DROP TABLE CodingPatterns_Backup

IF EXISTS (SELECT * FROM sys.indexes
	WHERE NAME = 'UIX_NewCodingPatterns_Multi')
	DROP INDEX CodingPatterns.UIX_NewCodingPatterns_Multi

DECLARE @codingPatterns TABLE(
	Id INT,
	IdToDiscard INT)

DECLARE @sgcpConflicts TABLE(
	Id BIGINT,
	IdToDiscard BIGINT, 
	CodingPatternId INT)

INSERT INTO @codingPatterns(Id, IdToDiscard)
SELECT MIN(CodingPatternId), MAX(CodingPatternId)
FROM CodingPatterns
GROUP BY CodingPath
HAVING COUNT(1) > 1

-- dependant SGCPs
INSERT INTO @sgcpConflicts(Id, IdToDiscard, CodingPatternId)
SELECT 
	CASE WHEN Pick.One = 1 THEN SGCP_ToKeep.SegmentedGroupCodingPatternID ELSE SGCP_ToDiscard.SegmentedGroupCodingPatternID END,
	CASE WHEN Pick.One = 1 THEN SGCP_ToDiscard.SegmentedGroupCodingPatternID ELSE SGCP_ToKeep.SegmentedGroupCodingPatternID END,
	CP.Id
FROM @codingPatterns CP
	JOIN SegmentedGroupCodingPatterns SGCP_ToKeep
		ON CP.Id = SGCP_ToKeep.CodingPatternId 
	JOIN SegmentedGroupCodingPatterns SGCP_ToDiscard
		ON CP.IdToDiscard = SGCP_ToDiscard.CodingPatternId 
		AND SGCP_ToKeep.SynonymManagementID = SGCP_ToDiscard.SynonymManagementID -- same list!
		AND SGCP_ToKeep.CodingElementGroupID = SGCP_ToDiscard.CodingElementGroupID -- same group!
	CROSS APPLY
	(
		SELECT One = CASE WHEN SGCP_ToKeep.SynonymStatus >= SGCP_ToDiscard.SynonymStatus THEN 1 ELSE 0 END
	) Pick

BEGIN TRY
BEGIN TRANSACTION

	-- 1. CodingAssignments
	UPDATE CA
	SET CA.SegmentedGroupCodingPatternID = SGCP.Id
	FROM @sgcpConflicts SGCP
		JOIN CodingAssignment CA
			ON CA.SegmentedGroupCodingPatternID = SGCP.IdToDiscard

	-- 2. BotElements
	UPDATE BE
	SET BE.SegmentedCodingPatternID = SGCP.Id
	FROM @sgcpConflicts SGCP
		JOIN BotElements BE
			ON BE.SegmentedCodingPatternID = SGCP.IdToDiscard

	-- 3. SynonymMigrationEntries (delete)
	DELETE SME
	FROM @sgcpConflicts SGCP
		JOIN SynonymMigrationEntries SME
			ON SME.SegmentedGroupCodingPatternID = SGCP.IdToDiscard

	-- 4. CodingElements
	UPDATE CE
	SET CE.AssignedSegmentedGroupCodingPatternId = SGCP.Id
	FROM @sgcpConflicts SGCP
		JOIN CodingElements CE
			ON CE.AssignedSegmentedGroupCodingPatternId = SGCP.IdToDiscard

	-- 5. SegmentedGroupCodingPatterns (delete)
	DELETE SGCP_Main
	FROM @sgcpConflicts SGCP
		JOIN SegmentedGroupCodingPatterns SGCP_Main
			ON SGCP_Main.SegmentedGroupCodingPatternID = SGCP.IdToDiscard

	-- 6. SegmentedGroupCodingPatterns (update)
	UPDATE SGCP_Main
	SET SGCP_Main.CodingPatternId = SGCP.CodingPatternId
	FROM @sgcpConflicts SGCP
		JOIN SegmentedGroupCodingPatterns SGCP_Main
			ON SGCP_Main.SegmentedGroupCodingPatternID = SGCP.Id
	WHERE SGCP_Main.CodingPatternId <> SGCP.CodingPatternId

	-- 7. CodingPatterns (delete)
	DELETE CP_Main
	FROM @codingPatterns cp
		JOIN CodingPatterns CP_Main
			ON cp.IdToDiscard = CP_Main.CodingPatternId

	COMMIT TRANSACTION

END TRY
BEGIN CATCH

	ROLLBACK TRANSACTION

	DECLARE @errorString NVARCHAR(MAX)
	SET @errorString = N'ERROR Group Migration: Transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)

END CATCH

