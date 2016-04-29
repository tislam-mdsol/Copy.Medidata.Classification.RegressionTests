-- Background : https://jira.mdsol.com/browse/MCC-195362
-- a non-validated data change has caused data integrity issues - 
-- CEG or a set of tasks were updated - in an effort to perform cross dictionary migration !!!!
-- this procedure fixes those CEGs that are non-conflicting (single use) - by porting them
-- to the other dictionary

	BEGIN TRY
	BEGIN TRANSACTION

		;WITH affectedTasks AS(
			SELECT 
				ce.CodingElementId,
				ce.CodingElementGroupID,
				ce.MedicalDictionaryLevelKey AS TaskLevelKey,
				ceg.MedicalDictionaryLevelKey
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
		),
		inCEGFix AS
		(
			SELECT 
				at.*,
                -- if only a single task on the CEG, then the CEG may be updated safely (nonConflicting)
				CASE WHEN x.TotalInGroup > 1 THEN 0 ELSE 1 END AS isCEGFixableForTasks
			FROM affectedTasks at
				CROSS APPLY					
				(					
					SELECT COUNT(1) AS TotalInGroup				
					FROM CodingElements ce			
					WHERE ce.CodingElementGroupID = at.CodingElementGroupID								
				) AS x	
		),
		affectedSGCPs AS
		(
			SELECT ceg.*,
                -- if all the synonyms wired to the affected CEGs match the dictionary context of the 
                -- task, then if the CEG can be updated safely from the task perspective, it can also
                -- be updated safely from the synonym perspective
				CASE WHEN CHARINDEX(taskParsing.dictionaryType, smm.MedicalDictionaryVersionLocaleKey, 1) = 1 THEN 1 ELSE 0 END AS isTaskMatchingSynonym
			FROM inCEGFix ceg
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
				AND isCEGFixableForTasks = 1
		),
		fixableCEGs AS
		(
			SELECT
				CodingElementGroupID, MAX(TaskLevelKey) AS TaskLevelKey, 
				MIN(TaskLevelKey) AS assertKey -- better safe
			FROM affectedSGCPs
                -- fix only those CEGs that can be safely updated!
			WHERE isTaskMatchingSynonym = 1
			GROUP BY CodingElementGroupID
		)

		UPDATE CEG
		SET CEG.MedicalDictionaryLevelKey = fCEG.TaskLevelKey
		FROM fixableCEGs fCEG
			JOIN CodingElementGroups CEG
				ON fCEG.CodingElementGroupID = CEG.CodingElementGroupID
		WHERE assertKey = TaskLevelKey

	    COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(MAX)
		SET @errorString = N'ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH