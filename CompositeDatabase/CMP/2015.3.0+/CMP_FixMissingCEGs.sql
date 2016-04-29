-- Background : https://jira.mdsol.com/browse/MCC-195362
-- a non-validated data change has caused data integrity issues - 
-- CEG or a set of tasks were updated - those updates were not rolled out
-- to WorkflowTaskHistory - which requires CEG data for historical purposes

	BEGIN TRY
	BEGIN TRANSACTION

		-- STORE DATA
		IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME = 'TempCEGMap')
		BEGIN
			CREATE TABLE TempCEGMap (OldCEGId BIGINT PRIMARY KEY, NewCEGId BIGINT)
		END
		ELSE
		BEGIN
			TRUNCATE TABLE TempCEGMap
		END

        ;WITH problematicWTHs AS (
	        SELECT 
		        WTH.CodingElementGroupID,
                -- use the latest assignment information for historical CEG mapping
		        ISNULL(MAX(WTH.CodingAssignmentId), 0) AS CodingAssignmentID
	        FROM WorkflowTaskHistory WTH
		        LEFT JOIN CodingElementGroups CEG
			        ON CEG.CodingElementGroupID = WTH.CodingElementGroupID
	        WHERE CEG.CodingElementGroupID IS NULL
	        GROUP BY WTH.CodingElementGroupID
        ),
        mappedCEGs AS
        (
	        SELECT 
		        WTH.CodingElementGroupId,
		        ISNULL(SGCP.CodingElementGroupID, 0) AS CorrectCEGId
	        FROM problematicWTHs WTH
		        LEFT JOIN CodingAssignment CA
			        ON CA.CodingAssignmentID = WTH.CodingAssignmentID
		        LEFT JOIN SegmentedGroupCodingPatterns SGCP
			        ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
        )

        -- Determine correct CEG from the assignment information for historical WTHs
        INSERT INTO TempCEGMap(OldCEGId, NewCEGId)
        SELECT CodingElementGroupId, CorrectCEGId
        FROM mappedCEGs

        -- Determine correct CEG from the task information for non-historical WTHs
        UPDATE CEG
        SET CEG.NewCEGId = CE.CodingElementGroupID
        FROM TempCEGMap CEG
	        CROSS APPLY
	        (
		        SELECT TOP 1 WTH.WorkflowTaskID
		        FROM WorkflowTaskHistory WTH
		        WHERE WTH.CodingElementGroupId = CEG.OldCEGId
		        ORDER BY WTH.WorkflowTaskHistoryID DESC
	        ) AS WTH
	        JOIN CodingElements CE
		        ON CE.CodingElementId = WTH.WorkflowTaskID
        WHERE CEG.NewCEGId < 1

        UPDATE WTH
        SET WTH.CodingElementGroupID = CEG.NewCEGId
        FROM TempCEGMap CEG
            JOIN WorkflowTaskHistory WTH
                ON WTH.CodingElementGroupID = CEG.OldCEGId

        UPDATE CQ
        SET CQ.CodingElementGroupID = CEG.NewCEGId
        FROM TempCEGMap CEG
            JOIN CoderQueries CQ
                ON CQ.CodingElementGroupID = CEG.OldCEGId

	    COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(MAX)
		SET @errorString = N'ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH