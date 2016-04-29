DECLARE @emptyEng INT, @emptyJpn INT

SELECT @emptyEng = ISNULL(MAX(GroupVerbatimID), -1) 
FROM GroupVerbatimEng
WHERE VerbatimText = ''

SELECT @emptyJpn = ISNULL(MAX(GroupVerbatimID), -1) 
FROM GroupVerbatimJpn
WHERE VerbatimText = N''

DECLARE @emptyGroups TABLE(CodingElementGroupID BIGINT PRIMARY KEY)
DECLARE @emptyTasks TABLE(ID BIGINT PRIMARY KEY)
DECLARE @transQueueIDs TABLE(ID BIGINT PRIMARY KEY)

-- PURGE ENTIRE EMPTY GROUPS & DEPENDANT ENTITITES
DECLARE @caObjId INT, @crObjId INT

SELECT @caObjId = ObjectTypeID
FROM ObjectTypeR
WHERE ObjectTypeName = 'CodingAssignment'

SELECT @crObjId = ObjectTypeID
FROM ObjectTypeR
WHERE ObjectTypeName = 'CodingRejection'

IF (@caObjId IS NULL OR @crObjId IS NULL)
BEGIN
	RAISERROR('ERROR Empty Verbatim Purge: Unable to resolve objectType ids.', 16, 1)
END
ELSE
BEGIN

	IF EXISTS (SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_OutTransmissionLogs_OutTransmissionID')
	BEGIN
		ALTER TABLE OutTransmissionLogs
		DROP CONSTRAINT FK_OutTransmissionLogs_OutTransmissionID
	END

	BEGIN TRY
	BEGIN TRANSACTION

		INSERT INTO @emptyGroups
		SELECT CodingElementGroupID
		FROM CodingElementGroups
		WHERE (GroupVerbatimID = @emptyEng AND DictionaryLocale = 'eng')
			OR
			(GroupVerbatimID = @emptyJpn AND DictionaryLocale = 'jpn')

		INSERT INTO @emptyTasks
		SELECT CodingElementID
		FROM CodingElements CE
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = CE.CodingElementGroupID

		-- 1. Automation
		-- 1.a LongAsyncTaskHistory
		DELETE LATH
		FROM LongAsyncTaskHistory LATH
			JOIN LongAsyncTasks LAT
				ON LATH.TaskId = LAT.TaskId
			JOIN BotElements BE
				ON LAT.ReferenceId = BE.BotElementId
				AND LAT.LongAsyncTaskType = 6
			JOIN SegmentedGroupCodingPatterns SGCP
				ON BE.SegmentedCodingPatternId = SGCP.SegmentedGroupCodingPatternID
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = SGCP.CodingElementGroupID		
		
		-- 1.b LongAsyncTasks
		DELETE LAT
		FROM LongAsyncTasks LAT
			JOIN BotElements BE
				ON LAT.ReferenceId = BE.BotElementId
				AND LAT.LongAsyncTaskType = 6
			JOIN SegmentedGroupCodingPatterns SGCP
				ON BE.SegmentedCodingPatternId = SGCP.SegmentedGroupCodingPatternID
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = SGCP.CodingElementGroupID
						
		-- 1.c BotElements
		DELETE BE
		FROM BotElements BE
			JOIN SegmentedGroupCodingPatterns SGCP
				ON BE.SegmentedCodingPatternId = SGCP.SegmentedGroupCodingPatternID
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = SGCP.CodingElementGroupID
		
		-- 1.d SynonymMigrationSuggestions
		DELETE SMS
		FROM SynonymMigrationSuggestions SMS
			JOIN SynonymMigrationEntries SME
				ON SME.SynonymMigrationEntryID = SMS.SynonymMigrationEntryID
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SME.SegmentedGroupCodingPatternID = SGCP.SegmentedGroupCodingPatternID
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = SGCP.CodingElementGroupID

		-- 1.e SynonymMigrationEntries
		DELETE SME
		FROM SynonymMigrationEntries SME
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SME.SegmentedGroupCodingPatternID = SGCP.SegmentedGroupCodingPatternID
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = SGCP.CodingElementGroupID

		-- 1.f SegmentedGroupCodingPatterns
		DELETE SGCP
		FROM SegmentedGroupCodingPatterns SGCP
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = SGCP.CodingElementGroupID

		-- 2. Task Data
		-- 2.a CodingSourceTermComponents
		DELETE CSTC
		FROM CodingSourceTermComponents CSTC
			JOIN @emptyTasks x
				ON CSTC.CodingSourceTermID = x.Id

		-- 2.b CodingSourceTermReferences
		DELETE CSTR
		FROM CodingSourceTermReferences CSTR
			JOIN @emptyTasks x
				ON CSTR.CodingSourceTermID = x.Id

		-- 2.c CodingSourceTermReferences
		DELETE CSTS
		FROM CodingSourceTermSupplementals CSTS
			JOIN @emptyTasks x
				ON CSTS.CodingSourceTermID = x.Id
				
		-- 2.d CodingSuggestions
		DELETE CS
		FROM CodingSuggestions CS
			JOIN @emptyTasks x
				ON CS.CodingElementID = x.Id

		-- 2.e WorkflowTaskHistory
		DELETE WTH
		FROM WorkflowTaskHistory WTH
			JOIN @emptyTasks x
				ON WTH.WorkflowTaskID = x.Id

		-- 2.e WorkflowTaskData
		DELETE WTD
		FROM WorkflowTaskData WTD
			JOIN @emptyTasks x
				ON WTD.WorkflowTaskID = x.Id

		-- 3. Transmission Data
		INSERT INTO @transQueueIDs
		SELECT TQ.TransmissionQueueItemID
		FROM TransmissionQueueItems TQ
			JOIN CodingAssignment CA
				ON TQ.ObjectID = CA.CodingAssignmentID
				AND TQ.ObjectTypeID = @caObjId
			JOIN @emptyTasks x
				ON CA.CodingElementID = x.Id
				
		INSERT INTO @transQueueIDs
		SELECT TQ.TransmissionQueueItemID
		FROM TransmissionQueueItems TQ
			JOIN CodingRejections CR
				ON TQ.ObjectID = CR.CodingRejectionID
				AND TQ.ObjectTypeID = @crObjId
			JOIN @emptyTasks x
				ON CR.CodingElementID = x.Id

		-- 3.a OutTransmissions
		DELETE OT
		FROM OutTransmissions OT
			JOIN OutTransmissionLogs OTL
				ON OT.OutTransmissionID = OTL.OutTransmissionID
			JOIN @transQueueIDs x
				ON OTL.TransmissionQueueItemId = x.ID

		-- 3.b OutTransmissionLogs
		DELETE OTL
		FROM OutTransmissionLogs OTL
			JOIN @transQueueIDs x
				ON OTL.TransmissionQueueItemId = x.ID

		-- 3.c TransmissionQueueItems
		DELETE TQI
		FROM TransmissionQueueItems TQI
			JOIN @transQueueIDs x
				ON TQI.TransmissionQueueItemID = x.ID

		-- 4. Workflow Data
		-- 4.a CodingAssignment
		DELETE CA
		FROM CodingAssignment CA
			JOIN @emptyTasks x
				ON CA.CodingElementID = x.Id

		-- 4.b CodingRejections
		DELETE CR
		FROM CodingRejections CR
			JOIN @emptyTasks x
				ON CR.CodingElementID = x.Id

		-- 5. Study Migration
		-- 5.a StudyMigrationBackup
		DELETE SMB
		FROM StudyMigrationBackup SMB
			JOIN @emptyTasks x
				ON SMB.CodingElementId = x.Id

		-- 6. Tasks
		-- 6.a CodingElements
		DELETE CE
		FROM CodingElements CE
			JOIN @emptyTasks x
				ON CE.CodingElementId = x.Id

		-- 7. Groups
		-- 7.a CodingElementGroups
		DELETE CEG
		FROM CodingElementGroups CEG
			JOIN @emptyGroups x
				ON x.CodingElementGroupID = CEG.CodingElementGroupID

		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(4000) = N'ERROR Empty Verbatim Purge: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH

END