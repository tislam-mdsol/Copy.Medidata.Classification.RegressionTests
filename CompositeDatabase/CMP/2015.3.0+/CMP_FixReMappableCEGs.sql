-- Background : https://jira.mdsol.com/browse/MCC-195362
-- a non-validated data change has caused data integrity issues - 
-- CEG or a set of tasks were updated - in an effort to perform cross dictionary migration !!!!
-- this procedure remaps the affected tasks to the correct CEGs - as well as remaps and consolidates
-- the synonyms to the correct CEGs.


	BEGIN TRY
	BEGIN TRANSACTION

		-- store the mapping results for later diagnostics
		IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME = 'CMP_FixCodingElementGroupsViaRemap')
		BEGIN
		
			CREATE TABLE CMP_FixCodingElementGroupsViaRemap (
				CodingElementId BIGINT PRIMARY KEY, 
				CodingElementGroupId BIGINT, 
				NextCodingElementGroupId BIGINT,
				TaskLevelKey NVARCHAR(100),
				MedicalDictionaryLevelKey NVARCHAR(100))

		END

		;WITH affectedTasks AS(
			SELECT 
				ce.CodingElementId,
				ce.CodingElementGroupID,
				ce.MedicalDictionaryLevelKey AS TaskLevelKey,
				
				ceg.MedicalDictionaryLevelKey,
				ceg.CompSuppCount,
				ceg.GroupVerbatimID,
				ceg.SegmentID
			FROM CodingElements ce 						
				JOIN codingElementGroups ceg 
					ON ce.CodingElementGroupId = ceg.CodingElementGroupId
			WHERE 						
				CHARINDEX(
					SUBSTRING(
						ce.MedicalDictionaryLevelKey, 
						1, 
						LEN(ce.MedicalDictionaryLevelKey) + 1 - CHARINDEX('-', REVERSE(ce.MedicalDictionaryLevelKey), 1)),
					ceg.MedicalDictionaryLevelKey, 1) <> 1
				AND ceg.MedicalDictionaryLevelKey <> ''
				AND ce.MedicalDictionaryLevelKey <> ''
				AND ceg.DictionaryLocale = 'eng' -- no JPN exist in copy, assert anyways (better safe)
		),
		inNextCEGFix AS
		(
			SELECT 
				AT.*,
				match.CodingElementGroupID AS NextCodingElementGroupID,
				CASE WHEN match.CC = 1 THEN 1 ELSE 0 END AS isCEGReMappableForTasks,
				CASE WHEN match.CC = 0 THEN 1 ELSE 0 END AS toCreateNewCEG
			FROM affectedTasks AT
				CROSS APPLY
				(
					SELECT ISNULL(MAX(CodingElementGroupID), 0) AS CodingElementGroupID,
						ISNULL(MAX(CC), 0) AS CC
					FROM
					(
						SELECT MAX(CEG_Next.CodingElementGroupID) AS CodingElementGroupID,
							COUNT(1) AS CC
						FROM CodingElementGroups CEG_Next
							CROSS APPLY
							(
								SELECT compSupps = COUNT(1)
								FROM CodingElementGroupComponents CEGC
									JOIN CodingElementGroupComponents CEGC_Next
										ON CEGC.NameTextID = CEGC_Next.NameTextID
										AND CEGC.SupplementFieldKeyId = CEGC_Next.SupplementFieldKeyId
								WHERE CEG_Next.CodingElementGroupID = CEGC_Next.CodingElementGroupID
									AND AT.CodingElementGroupID = CEGC.CodingElementGroupID
							) AS matchedComponents
						WHERE CEG_Next.GroupVerbatimID = AT.GroupVerbatimID
							AND CEG_Next.MedicalDictionaryLevelKey = AT.TaskLevelKey
							AND CEG_Next.SegmentID = AT.SegmentID
							AND CEG_Next.DictionaryLocale = 'eng' -- no JPN exist in copy, assert anyways (better safe)
							AND CEG_Next.CompSuppCount = AT.CompSuppCount
							AND CEG_Next.CompSuppCount = matchedComponents.compSupps
						GROUP BY CEG_Next.CodingElementGroupID
					) AS match
				) AS match
		)

		INSERT INTO CMP_FixCodingElementGroupsViaRemap(
			CodingElementId, 
			CodingElementGroupId, 
			NextCodingElementGroupId,
			TaskLevelKey,
			MedicalDictionaryLevelKey
			)
		SELECT 
			CodingElementId, 
			CodingElementGroupId, 
			NextCodingElementGroupId,
			TaskLevelKey,
			MedicalDictionaryLevelKey
		FROM inNextCEGFix
		WHERE isCEGReMappableForTasks = 1 OR toCreateNewCEG = 1

		DECLARE @mapNewCEGs TABLE(CEGId BIGINT PRIMARY KEY, SourceCEGId BIGINT)

		-- create newCEGs
		;WITH newCEGs AS
		(
			SELECT c.CodingElementGroupId, TaskLevelKey
			FROM CMP_FixCodingElementGroupsViaRemap c
				JOIN CodingElementGroups CEG
					ON c.CodingElementGroupId = CEG.CodingElementGroupId
			WHERE c.NextCodingElementGroupId = 0
			GROUP BY c.CodingElementGroupId, TaskLevelKey
		)

		INSERT INTO CodingElementGroups(SegmentID, DictionaryLocale, GroupVerbatimID, CompSuppCount, 
			MedicalDictionaryLevelKey, ProgrammaticAuxiliary,
			DictionaryId_Backup, DictionaryLevelId_Backup)
		OUTPUT inserted.CodingElementGroupId, inserted.ProgrammaticAuxiliary INTO @mapNewCEGs(CEGId, SourceCEGId)
		SELECT CEG.SegmentID, CEG.DictionaryLocale, CEG.GroupVerbatimID, CEG.CompSuppCount, 
			TaskLevelKey, c.CodingElementGroupId,
			0, 0
		FROM newCEGs c
			JOIN CodingElementGroups CEG
				ON c.CodingElementGroupId = CEG.CodingElementGroupId

		INSERT INTO CodingElementGroupComponents(
			CodingElementGroupId, SupplementFieldKeyId, NameTextID, IsSupplement,
			CodeText, SearchType, SearchOperator)
		SELECT m.CEGId, SupplementFieldKeyId, NameTextID, IsSupplement,
			CodeText, SearchType, SearchOperator
		FROM @mapNewCEGs M
			JOIN CodingElementGroupComponents CEGC
				ON M.SourceCEGId = CEGC.CodingElementGroupID

		UPDATE C
		SET C.NextCodingElementGroupId = M.CEGId
		FROM CMP_FixCodingElementGroupsViaRemap C
			JOIN @mapNewCEGs M
				ON C.CodingElementGroupId = M.SourceCEGId
		WHERE C.NextCodingElementGroupId = 0

		-- remap the tasks
		UPDATE CE
		SET CE.CodingElementGroupId = C.NextCodingElementGroupId
		FROM CMP_FixCodingElementGroupsViaRemap C
			JOIN CodingElements CE
				ON C.CodingElementId = CE.CodingElementId

		DECLARE @synonymMapping TABLE(
			SGCPId BIGINT PRIMARY KEY, 
			NextCodingElementGroupId BIGINT,
			ReplacementSGCPId BIGINT, 
			toDownGradeStatus BIT)

		-- match the synonyms
		;WITH cegMappings AS
		(
			SELECT TaskLevelKey, CodingElementGroupId, MedicalDictionaryLevelKey, NextCodingElementGroupId
			FROM CMP_FixCodingElementGroupsViaRemap
			GROUP BY TaskLevelKey, CodingElementGroupId, MedicalDictionaryLevelKey, NextCodingElementGroupId
		),
		affectedSGCPs AS
		(
			SELECT 
				sgcp.SegmentedGroupCodingPatternID,
				sgcp.SynonymManagementID,
				sgcp.CodingPatternID,
				ceg.*,
                -- if all the synonyms wired to the affected CEGs match the dictionary context of the 
                -- task, then if the CEG can be mapped safely from the task perspective, it can also
                -- be mapped safely from the synonym perspective
				CASE WHEN CHARINDEX(taskParsing.dictionaryType, smm.MedicalDictionaryVersionLocaleKey, 1) = 1 THEN 1 ELSE 0 END AS isTaskMatchingSynonym
			FROM cegMappings ceg
				JOIN SegmentedGroupCodingPatterns sgcp
					ON ceg.CodingElementGroupID = sgcp.CodingElementGroupID				
				JOIN SynonymMigrationMngmt smm						
					ON sgcp.SynonymManagementID = smm.SynonymMigrationMngmtID
				CROSS APPLY						
				(						
					SELECT dictionaryType =					
					SUBSTRING(
						ceg.MedicalDictionaryLevelKey, 
						1, 
						LEN(ceg.MedicalDictionaryLevelKey) + 1 - CHARINDEX('-',REVERSE(ceg.MedicalDictionaryLevelKey), 1))					
				) AS cegParsing
				CROSS APPLY						
				(						
					SELECT dictionaryType =					
					SUBSTRING(
						ceg.TaskLevelKey, 
						1, 
						LEN(ceg.TaskLevelKey) + 1 - CHARINDEX('-',REVERSE(ceg.TaskLevelKey), 1))					
				) AS taskParsing							
			WHERE CHARINDEX(cegParsing.dictionaryType, smm.MedicalDictionaryVersionLocaleKey, 1) <> 1
		),
		actionMappedSGCPs AS
		(
			SELECT sgcp.*,
				ReplacementSGCPId,
				CASE WHEN SynonymExistsInCEG > 0 THEN 1 ELSE 0 END AS toDownGradeStatus
			FROM affectedSGCPs sgcp
				CROSS APPLY
				(
					SELECT 
						ReplacementSGCPId = MAX(ExactMatchingId), 
						SynonymExistsInCEG = SUM(SynonymExistsInCEG)
					FROM
					(
						SELECT
							CASE WHEN sgcp_next.CodingPatternID = sgcp.CodingPatternID THEN 
								sgcp_next.SegmentedGroupCodingPatternID ELSE 0 END AS ExactMatchingId,
							CASE WHEN sgcp_next.SynonymStatus > 0 THEN 1 ELSE 0 END AS SynonymExistsInCEG
						FROM SegmentedGroupCodingPatterns sgcp_next
						WHERE sgcp.SynonymManagementID = sgcp_next.SynonymManagementID
							AND sgcp_next.CodingElementGroupID = sgcp.NextCodingElementGroupId
					) nextSGCPs
				) nextSGCP
			WHERE isTaskMatchingSynonym = 1
		)
		
		INSERT INTO @synonymMapping(SGCPId, NextCodingElementGroupId, ReplacementSGCPId, toDownGradeStatus)
		SELECT SegmentedGroupCodingPatternID, NextCodingElementGroupId, ReplacementSGCPId, toDownGradeStatus
		FROM actionMappedSGCPs

		-- port first the replacements
		UPDATE CE
		SET CE.AssignedSegmentedGroupCodingPatternId = SM.ReplacementSGCPId
		FROM @synonymMapping SM
			JOIN CodingElements CE
				ON SM.SGCPId = CE.AssignedSegmentedGroupCodingPatternId
		WHERE SM.ReplacementSGCPId > 0

		UPDATE CA
		SET CA.SegmentedGroupCodingPatternID = SM.ReplacementSGCPId
		FROM @synonymMapping SM
			JOIN CodingAssignment CA
				ON SM.SGCPId = CA.SegmentedGroupCodingPatternID
		WHERE SM.ReplacementSGCPId > 0

		DELETE SMS
		FROM @synonymMapping SM
			JOIN SynonymMigrationEntries SME
				ON SME.SegmentedGroupCodingPatternID = SM.SGCPId	
			JOIN SynonymMigrationSuggestions SMS
				ON SMS.SynonymMigrationEntryID = SME.SynonymMigrationEntryID
		WHERE SM.ReplacementSGCPId > 0

		DELETE SME
		FROM @synonymMapping SM
			JOIN SynonymMigrationEntries SME
				ON SME.SegmentedGroupCodingPatternID = SM.SGCPId
		WHERE SM.ReplacementSGCPId > 0

		DELETE SGCP
		FROM @synonymMapping SM
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = SM.SGCPId
		WHERE SM.ReplacementSGCPId > 0

		DELETE @synonymMapping
		WHERE ReplacementSGCPId > 0

		-- next the synonym updates
		UPDATE SGCP
		SET SGCP.CodingElementGroupID = SM.NextCodingElementGroupId,
			SGCP.SynonymStatus = CASE WHEN SM.toDownGradeStatus = 1 THEN 0 ELSE SGCP.SynonymStatus END
		FROM @synonymMapping SM
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = SM.SGCPId

	    COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(MAX)
		SET @errorString = N'ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH