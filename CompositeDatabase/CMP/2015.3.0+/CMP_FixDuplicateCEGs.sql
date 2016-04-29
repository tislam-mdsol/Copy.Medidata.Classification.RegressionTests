-- Background : https://jira.mdsol.com/browse/MCC-195362
-- a non-validated data change has caused data integrity issues - 
-- CEG or a set of tasks were updated - in an effort to perform cross dictionary migration !!!!
-- this procedure removes duplicate CEGs that are not used

	BEGIN TRY
	BEGIN TRANSACTION

        CREATE TABLE CMP_Duplicate_CEGMapping(
            MinId BIGINT, -- Id to Keep
            MaxId BIGINT PRIMARY KEY, -- Id to Remove
            AffectedSGCPs BIT)

        CREATE TABLE CMP_Duplicate_SGCPMapping(
            IdToKeep BIGINT, -- Id to Keep
            IdToDiscard BIGINT PRIMARY KEY, -- Id to Remove
            DowngradeStatus BIT,
			CodingElementGroupId BIGINT)

        ;WITH P AS
        (
        	SELECT
        		GroupVerbatimID, DictionaryLocale, SegmentID, MedicalDictionaryLevelKey, CompositeKey, COUNT(1) AS CC,
        		MIN(CodingElementGroupID) AS MINCodingElementGroupID,
        		MAX(CodingElementGroupID) AS MAXCodingElementGroupID
        	FROM CodingElementGroups ceg
        		CROSS APPLY
        		(
        			SELECT ISNULL(MAX(CompositeKey), '') AS CompositeKey
        			FROM 
        			(
        				SELECT CAST(SupplementFieldKeyId AS VARCHAR) +':'+CAST(NameTextID AS VARCHAR) + ';'
        				FROM CodingElementGroupComponents cegc
        				WHERE cegc.CodingElementGroupID = ceg.CodingElementGroupID
        				ORDER BY SupplementFieldKeyId, NameTextID
        				FOR XML PATH('')
        			) AS X (CompositeKey)
        		) AS X
        	GROUP BY GroupVerbatimID, DictionaryLocale, SegmentID, MedicalDictionaryLevelKey, CompositeKey
        	HAVING COUNT(1) > 1
        )

        INSERT INTO CMP_Duplicate_CEGMapping (MinId,MaxId )
        SELECT MINCodingElementGroupID, MAXCodingElementGroupID
        FROM P

        UPDATE p
        SET AffectedSGCPs = 1
        FROM CMP_Duplicate_CEGMapping P
        	JOIN SegmentedGroupCodingPatterns SGCP
        		ON P.MaxId = SGCP.CodingElementGroupID
        
		-- Fix Tasks
		UPDATE CE
        SET CE.CodingElementGroupID = P.MinId
        FROM CMP_Duplicate_CEGMapping P
        	JOIN CodingElements CE
        		ON P.MaxId = CE.CodingElementGroupID
        
		-- Fix Task History
		UPDATE WTH
        SET WTH.CodingElementGroupID = P.MinId
        FROM CMP_Duplicate_CEGMapping P
        	JOIN WorkflowTaskHistory WTH
        		ON P.MaxId = WTH.CodingElementGroupID
        
		-- Fix Queries
		UPDATE CQ
        SET CQ.CodingElementGroupID = P.MinId
        FROM CMP_Duplicate_CEGMapping P
        	JOIN CoderQueries CQ
        		ON P.MaxId = CQ.CodingElementGroupID
		
		-- Map Synonyms
		;WITH S AS 
		(
			SELECT 
				X.SegmentedGroupCodingPatternID AS IdToKeep, 
				SGCP.SegmentedGroupCodingPatternID AS IdToDiscard,
				SGCP.SynonymManagementID,
				M.MinId
			FROM CMP_Duplicate_CEGMapping M
				JOIN SegmentedGroupCodingPatterns SGCP
					ON M.MaxId = SGCP.CodingElementGroupID
				CROSS APPLY
				(
					SELECT ISNULL(MAX(X.SegmentedGroupCodingPatternID), 0) AS SegmentedGroupCodingPatternID
					FROM 
					(
						SELECT SGCP_Good.SegmentedGroupCodingPatternID
						FROM SegmentedGroupCodingPatterns SGCP_Good
						WHERE SGCP_Good.SynonymManagementID = SGCP.SynonymManagementID
							AND SGCP_Good.CodingElementGroupID = M.MinId
							AND SGCP_Good.CodingPatternID = SGCP.CodingPatternID
					) AS X
				) AS X
			WHERE AffectedSGCPs = 1
		),
		SG AS
		(
			SELECT IdToKeep, IdToDiscard, DownGradeStatus, MinId
			FROM S
				CROSS APPLY
				(
					SELECT 
						CASE WHEN ISNULL(MAX(X.SegmentedGroupCodingPatternID), 0) > 0 THEN 1 ELSE 0 END AS DownGradeStatus
					FROM 
					(
						SELECT SGCP_Other.SegmentedGroupCodingPatternID
						FROM SegmentedGroupCodingPatterns SGCP_Other
						WHERE SGCP_Other.SynonymManagementID = S.SynonymManagementID
							AND SGCP_Other.CodingElementGroupID = S.MinId
							AND SGCP_Other.SynonymStatus > 0
							AND S.IdToKeep = 0
					) AS X
				) AS X
		)

		INSERT INTO CMP_Duplicate_SGCPMapping(
					IdToKeep,
					IdToDiscard,
					DowngradeStatus,
					CodingElementGroupId)
		SELECT IdToKeep,
			   IdToDiscard,
			   DownGradeStatus,
			   MinId
		FROM SG

		-- Update Non-Conflicting SGCPs
		UPDATE SGCP
		SET SGCP.CodingElementGroupID = C.CodingElementGroupId,
			SGCP.SynonymStatus = CASE WHEN C.DowngradeStatus = 1 THEN 0 ELSE SGCP.SynonymStatus END
		FROM CMP_Duplicate_SGCPMapping C
			JOIN SegmentedGroupCodingPatterns SGCP
				ON C.IdToDiscard = SGCP.SegmentedGroupCodingPatternID
		WHERE C.IdToKeep = 0

		-- DELETE Conflicting SGCPs
		DELETE SMS
		FROM CMP_Duplicate_SGCPMapping C
			JOIN SynonymMigrationEntries SME
				ON C.IdToDiscard = SME.SegmentedGroupCodingPatternID
			JOIN SynonymMigrationSuggestions SMS
				ON SMS.SynonymMigrationEntryID = SME.SynonymMigrationEntryID
		WHERE C.IdToKeep > 0

		DELETE SME
		FROM CMP_Duplicate_SGCPMapping C
			JOIN SynonymMigrationEntries SME
				ON C.IdToDiscard = SME.SegmentedGroupCodingPatternID
		WHERE C.IdToKeep > 0

		DELETE SGCP
		FROM CMP_Duplicate_SGCPMapping C
			JOIN SegmentedGroupCodingPatterns SGCP
				ON C.IdToDiscard = SGCP.SegmentedGroupCodingPatternID
		WHERE C.IdToKeep > 0

		--ReWire References
		UPDATE CE
		SET CE.AssignedSegmentedGroupCodingPatternId = C.IdToKeep
		FROM CMP_Duplicate_SGCPMapping C
			JOIN CodingElements CE
				ON C.IdToDiscard = CE.AssignedSegmentedGroupCodingPatternId
		WHERE C.IdToKeep > 0

		UPDATE CA
		SET CA.SegmentedGroupCodingPatternID = C.IdToKeep
		FROM CMP_Duplicate_SGCPMapping C
			JOIN CodingAssignment CA
				ON C.IdToDiscard = CA.SegmentedGroupCodingPatternID
		WHERE C.IdToKeep > 0

		-- remove duplicate CEGs
        DELETE CEG
        FROM CMP_Duplicate_CEGMapping P
        	JOIN CodingElementGroups CEG
        		ON P.MaxId = CEG.CodingElementGroupID

	    COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(MAX)
		SET @errorString = N'ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH