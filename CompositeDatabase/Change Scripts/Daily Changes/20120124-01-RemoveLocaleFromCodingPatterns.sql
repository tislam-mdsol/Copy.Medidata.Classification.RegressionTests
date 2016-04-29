-- *** PART 1 - Remove offending data *** --

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'TempStorageCodingPatterns')
	DROP TABLE dbo.TempStorageCodingPatterns

CREATE TABLE dbo.TempStorageCodingPatterns
(
	MasterId INT PRIMARY KEY,
	SlaveId INT
)

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'TempStorageCodingRules')
	DROP TABLE dbo.TempStorageCodingRules

CREATE TABLE dbo.TempStorageCodingRules
(
	MasterId INT PRIMARY KEY,
	SlaveId INT
)

BEGIN TRANSACTION
BEGIN TRY

	-- 1. find any duplicated CodingPatterns
	-- (build remap/delete ids)
	INSERT INTO TempStorageCodingPatterns(MasterId, SlaveId)
	SELECT Y.CodingPatternID, CP2.CodingPatternID
	FROM
	(
		SELECT *
		FROM
		(
			SELECT MedicalDictionaryTermID, CodingPath, CodingPatternId, 
				ROW_NUMBER() OVER(
					PARTITION BY MedicalDictionaryTermID, CodingPath ORDER BY MedicalDictionaryTermID ASC) AS RowNum
			FROM CodingPatterns
		) AS X
		WHERE X.RowNum = 2
	) AS Y
		JOIN CodingPatterns CP2
			ON CP2.MedicalDictionaryTermID = Y.MedicalDictionaryTermID
			AND CP2.CodingPath = Y.CodingPath
			AND CP2.CodingPatternID <> Y.CodingPatternID

	-- 2. update SegmentedGroupCodingPatterns
	--(build remap/delete ids)
	INSERT INTO TempStorageCodingRules(MasterId, SlaveId)
	SELECT SGCP_Master.SegmentedGroupCodingPatternID, SGCP_Slave.SegmentedGroupCodingPatternID
	FROM SegmentedGroupCodingPatterns SGCP_Master
		JOIN TempStorageCodingPatterns CP
			ON SGCP_Master.CodingPatternID = CP.MasterId
		JOIN SegmentedGroupCodingPatterns SGCP_Slave
			ON SGCP_Slave.CodingPatternID = CP.SlaveId

	-- 3. update CodingAssignment
	UPDATE CA
	SET CA.SegmentedGroupCodingPatternID = CR.MasterId
	FROM CodingAssignment CA
		JOIN TempStorageCodingRules CR
			ON CA.SegmentedGroupCodingPatternID = CR.SlaveId

	-- 4. update CodingElement
	UPDATE CE
	SET CE.AssignedSegmentedGroupCodingPatternId = CR.MasterId
	FROM CodingElements CE
		JOIN TempStorageCodingRules CR
			ON CE.AssignedSegmentedGroupCodingPatternId = CR.SlaveId

	-- 5. delete from SegmentedGroupCodingPatterns
	DELETE FROM SegmentedGroupCodingPatterns
	WHERE SegmentedGroupCodingPatternID IN (SELECT SlaveId FROM TempStorageCodingRules)

	-- 6. delete from CodingPatterns
	DELETE FROM CodingPatterns
	WHERE CodingPatternID IN (SELECT SlaveId FROM TempStorageCodingPatterns)

	COMMIT TRANSACTION
	
END TRY
BEGIN CATCH

	ROLLBACK TRANSACTION
	RAISERROR('Failed to update CodingPatterns with locale changes', 1, 16)
	
END CATCH

DROP TABLE dbo.TempStorageCodingRules
DROP TABLE dbo.TempStorageCodingPatterns

-- *** PART 2 - Change Schema *** --

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_CodingPatterns_Multi')
	DROP INDEX CodingPatterns.UIX_CodingPatterns_Multi
	
CREATE NONCLUSTERED INDEX UIX_CodingPatterns_Multi
ON [dbo].[CodingPatterns]
([MedicalDictionaryTermID] ASC ,[CodingPath] ASC)


IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingPatterns'
		AND COLUMN_NAME = 'DictionaryLocale'))
BEGIN	
	ALTER TABLE CodingPatterns
	DROP COLUMN DictionaryLocale
END