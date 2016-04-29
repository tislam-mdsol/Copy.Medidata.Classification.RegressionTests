-- Background : https://jira.mdsol.com/browse/MCC-195362
-- a non-validated data change has caused data integrity issues - 
-- CEG or a set of tasks were updated - in an effort to perform cross dictionary migration !!!!
-- this procedure removes the 'bad' synonyms from use.


	BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @badSynonyms TABLE(Id BIGINT PRIMARY KEY, usedInCA BIT)

	    ;WITH affectedSynonyms AS						
	    (						
		    SELECT DISTINCT(sgcp.SegmentedGroupCodingPatternID)
		    FROM SegmentedGroupCodingPatterns sgcp						
			    JOIN SynonymMigrationMngmt smm						
				    ON sgcp.SynonymManagementID = smm.SynonymMigrationMngmtID						
			    JOIN CodingElementGroups ceg						
				    ON ceg.CodingElementGroupID = sgcp.CodingElementGroupID						
			    CROSS APPLY						
			    (						
				    SELECT dictionaryType =					
				    SUBSTRING(
					    ceg.MedicalDictionaryLevelKey, 
					    1, 
					    LEN(ceg.MedicalDictionaryLevelKey) + 1 - CHARINDEX('-',REVERSE(ceg.MedicalDictionaryLevelKey), 1))					
			    ) AS x						
		    WHERE CHARINDEX(x.dictionaryType, smm.MedicalDictionaryVersionLocaleKey, 1) <> 1						
	    ),
	    inUseSGCP AS
	    (
		    SELECT s.*,
				CASE WHEN CA.CC > 0 THEN 1 ELSE 0 END AS usedInCA
		    FROM affectedSynonyms s
				CROSS APPLY
				(
					SELECT CC = COUNT(1)
					FROM CodingAssignment CA
				    WHERE s.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
				) AS CA
	    )

	    INSERT INTO @badSynonyms(Id, usedInCA)
	    SELECT SegmentedGroupCodingPatternID, usedInCA
	    FROM inUseSGCP

		DECLARE @updateDATE DATETIME = GETUTCDATE()

		-- handle first those tasks wired to these synonyms (reset the tasks!)
		UPDATE CE
		SET CE.AssignedSegmentedGroupCodingPatternId = 0,
			CE.WorkflowStateID = 1,
			CE.CacheVersion = CE.CacheVersion + 2,
			CE.Updated = @updateDATE,
			CE.AssignedCodingPath = '',
			CE.AssignedTermCode = '',
			CE.AssignedTermText = '',
			CE.IsClosed = 0,
			CE.IsCompleted = 0,
			CE.AutoCodeDate = NULL
		FROM @badSynonyms bSGCP
			JOIN CodingElements CE
				ON bSGCP.Id = CE.AssignedSegmentedGroupCodingPatternId

		-- next remove the bad assignments & associated histories
		DELETE WTH
		FROM @badSynonyms bSGCP
			JOIN CodingAssignment CA
				ON bSGCP.Id = CA.SegmentedGroupCodingPatternID
			JOIN WorkflowTaskHistory WTH
				ON WTH.CodingAssignmentId = CA.CodingAssignmentID
		WHERE usedInCA = 1

		DELETE CA
		FROM @badSynonyms bSGCP
			JOIN CodingAssignment CA
				ON bSGCP.Id = CA.SegmentedGroupCodingPatternID
		WHERE usedInCA = 1

		-- next remove synonym dependencies & synonyms
		DELETE SMS
		FROM @badSynonyms SM
			JOIN SynonymMigrationEntries SME
				ON SME.SegmentedGroupCodingPatternID = SM.Id	
			JOIN SynonymMigrationSuggestions SMS
				ON SMS.SynonymMigrationEntryID = SME.SynonymMigrationEntryID

		DELETE SME
		FROM @badSynonyms SM
			JOIN SynonymMigrationEntries SME
				ON SME.SegmentedGroupCodingPatternID = SM.Id

		DELETE SGCP
		FROM @badSynonyms SM
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = SM.Id

	    COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(MAX)
		SET @errorString = N'ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
