-- Background : verify data integrity
-- *** Synonyms must pertain to synonym lists which are wired
-- to incorrect CEGs (matching in dictionary context!)

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'dgxTasksAcrossCEGs')
	DROP PROCEDURE dgxTasksAcrossCEGs
GO

CREATE PROCEDURE dbo.dgxTasksAcrossCEGs
AS  
BEGIN

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
		inNextCEGFix AS -- match next CEG!!
		(
			SELECT 
				at.*,
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
				CASE WHEN CHARINDEX(taskParsing.dictionaryType, smm.MedicalDictionaryVersionLocaleKey, 1) = 1 THEN 1 ELSE 0 END AS isTaskMatchingSynonym
			FROM inNextCEGFix ceg
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
		fixableCEGs AS
		(
			SELECT
				CodingElementGroupID,
				MAX(TaskLevelKey) AS anyKey,
				MIN(TaskLevelKey) AS anyOtherKey
			FROM affectedSGCPs
			WHERE isTaskMatchingSynonym = 1
				AND isCEGFixableForTasks = 1
			GROUP BY CodingElementGroupID
		)

		SELECT CEG.MedicalDictionaryLevelKey,fCEG.anyKey
		FROM fixableCEGs fCEG
			JOIN CodingElementGroups CEG
				ON fCEG.CodingElementGroupID = CEG.CodingElementGroupID
		WHERE anyKey = anyOtherKey						

END