
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_RemoveBadVersionReferences')
	DROP PROCEDURE spCoder_CMP_RemoveBadVersionReferences
GO

-- EXEC spCoder_CMP_RemoveBadVersionReferences 'HD_DDE_B2', '201312'

CREATE PROCEDURE dbo.spCoder_CMP_RemoveBadVersionReferences
(
	@dictionaryOID VARCHAR(50),
	@versionOID VARCHAR(50),
	@Comment NVARCHAR(500) = N'Tasks will be reset to start state due to previously loaded incorrect dictionary version'
)
AS
BEGIN

	DECLARE @dictionaryID INT
	DECLARE @versionID INT

	-- resolve OIDs into IDs
	SELECT @dictionaryID = DictionaryRefId
	FROM DictionaryRef
	WHERE OID = @dictionaryOID

	IF (@dictionaryID IS NULL)
	BEGIN
		PRINT 'Dictionary NOT FOUND'
		RETURN 0
	END

	SELECT @versionID = DictionaryVersionRefId
	FROM DictionaryVersionRef
	WHERE DictionaryRefId = @dictionaryID
		AND OID = @versionOID

	IF (@versionID IS NULL)
	BEGIN
		PRINT 'Version NOT FOUND'
		RETURN 0
	END

	DECLARE @badSyns TABLE(SynonymListID INT PRIMARY KEY, WorkflowStartStateID INT)
	DECLARE @badPatterns TABLE(CodingPatternID INT PRIMARY KEY)

	-- Store synonyms that are to be purged
	IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'PurgedSynonymBackup'))
	BEGIN
			CREATE TABLE [dbo].[PurgedSynonymBackup](	
				[ID] INT IDENTITY(1,1) NOT NULL,
					
				[SynonymListID] INT NOT NULL,
				[CodingPatternID] INT NOT NULL,
				[CodingElementGroupID] INT NOT NULL,

				[MatchPercent] DECIMAL NOT NULL,
				[SynonymStatus] TINYINT NOT NULL,
				[IsExactMatch] BIT NOT NULL,

				[Created] DATETIME NOT NULL CONSTRAINT DF_PurgedSynonymBackup_Created DEFAULT (GETUTCDATE()),
			CONSTRAINT [PK_PurgedSynonymBackup] PRIMARY KEY CLUSTERED 
			(
				[ID] ASC
			)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			) ON [PRIMARY]
	END

	BEGIN TRY
	BEGIN TRANSACTION

		-- Given SynonymMigrationMngmt in the bad version
		INSERT INTO @badSyns(SynonymListID, WorkflowStartStateID)
		SELECT SMM.SynonymMigrationMngmtID, WS.WorkflowStateID
		FROM SynonymMigrationMngmt SMM
			JOIN WorkflowStates WS
				ON SMM.SegmentID = WS.SegmentId
				AND WS.IsStartState = 1
				AND SMM.DictionaryVersionId = @versionID

		INSERT INTO @badPatterns
		SELECT CP.CodingPatternID
		FROM CodingPatterns CP
			JOIN dbo.fnGetAllBadTermsForBadVersion() BT
				ON CHARINDEX('.'+CAST(BT.TermId AS VARCHAR(50))+'.', Codingpath, 0) = 2

		-- validate closure
		-- make sure no coding decisions reference any bad CodingPatterns outside of the condemned synonym lists
		IF EXISTS (
			SELECT NULL
			FROM @badPatterns CP
				JOIN SegmentedGroupCodingPatterns SGCP
					ON CP.CodingPatternId = SGCP.CodingPatternID
				LEFT JOIN @badSyns B
					ON B.SynonymListID = SGCP.SynonymManagementID
			WHERE B.SynonymListID IS NULL)
		BEGIN

			ROLLBACK TRANSACTION
			PRINT 'Coding decisions exist outside of the condemned synonym lists'
			RETURN 1

		END

		-- save the active synonyms which are about to be purged
		INSERT INTO PurgedSynonymBackup
			(SynonymListID, CodingPatternID, CodingElementGroupID, MatchPercent, SynonymStatus, IsExactMatch)
		SELECT
			B.SynonymListID, SGCP.CodingPatternID, SGCP.CodingElementGroupID, SGCP.MatchPercent, SGCP.SynonymStatus, SGCP.IsExactMatch
		FROM SegmentedGroupCodingPatterns SGCP
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID
				-- ignore inactives
				AND SGCP.Active = 1

		-- SynonymMigrationSuggestions
		DELETE SMS
		FROM SynonymMigrationSuggestions SMS
			JOIN SynonymMigrationEntries SME
				ON SMS.SynonymMigrationEntryID = SME.SynonymMigrationEntryID
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = SME.SegmentedGroupCodingPatternID
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- SynonymMigrationEntries
		DELETE SME
		FROM SynonymMigrationEntries SME
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = SME.SegmentedGroupCodingPatternID
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- Long Async Task History for BOTs
		DELETE LATH
		FROM LongAsyncTaskHistory LATH
			JOIN LongAsyncTasks LAT
				ON LATH.TaskId = LAT.TaskId
			JOIN BOTElements BE
				ON LAT.ReferenceId = BE.BOTElementID
				AND LAT.LongAsyncTaskType = 6
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = BE.SegmentedCodingPatternId
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- Long Async Tasks for BOTs
		DELETE LAT
		FROM LongAsyncTasks LAT
			JOIN BOTElements BE
				ON LAT.ReferenceId = BE.BOTElementID
				AND LAT.LongAsyncTaskType = 6
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = BE.SegmentedCodingPatternId
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- BOTElements
		DELETE BE
		FROM BOTElements BE
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = BE.SegmentedCodingPatternId
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- OutTransmissionLogs
		DELETE OTL
		FROM OutTransmissionLogs OTL
			JOIN TransmissionQueueItems TQI
				ON OTL.TransmissionQueueItemId = TQI.TransmissionQueueItemID
			JOIN CodingAssignment CA
				ON TQI.ObjectID = CA.CodingAssignmentID
				AND TQI.ObjectTypeID IN (2255, 2251)
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- OutTransmissions
		DELETE OT
		FROM OutTransmissions OT
			JOIN TransmissionQueueItems TQI
				ON OT.OutTransmissionID = TQI.OutTransmissionID
			JOIN CodingAssignment CA
				ON TQI.ObjectID = CA.CodingAssignmentID
				AND TQI.ObjectTypeID IN (2255, 2251)
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- TransmissionQueueItems for all Coding Assignments
		DELETE TQI
		FROM TransmissionQueueItems TQI
			JOIN CodingAssignment CA
				ON TQI.ObjectID = CA.CodingAssignmentID
				AND TQI.ObjectTypeID IN (2255, 2251)
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- WorkflowTaskHistory after bad Coding Assignments
		;WITH 
			purgeFROM AS
			(
				SELECT MIN(WTH.WorkflowTaskHistoryId) AS WorkflowTaskHistoryId, WTH.WorkflowTaskID
				FROM WorkflowTaskHistory WTH
					JOIN CodingAssignment CA
						ON WTH.CodingAssignmentId = CA.CodingAssignmentID
					JOIN SegmentedGroupCodingPatterns SGCP
						ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
					JOIN @badSyns B
						ON B.SynonymListID = SGCP.SynonymManagementID
				GROUP BY WTH.WorkflowTaskID
			)

		DELETE WTH
		FROM WorkflowTaskHistory WTH
			JOIN purgeFROM PF
				ON WTH.WorkflowTaskID = PF.WorkflowTaskID
				AND WTH.WorkflowTaskHistoryId >= PF.WorkflowTaskHistoryId

		-- CodingAssignment
		DELETE CA
		FROM CodingAssignment CA
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- SegmentedGroupCodingPatterns
		DELETE SGCP
		FROM SegmentedGroupCodingPatterns SGCP
			JOIN @badSyns B
				ON B.SynonymListID = SGCP.SynonymManagementID

		-- Long Async Task History for SynonymLoads, Synonym Migration, Synonym Migration Activation
		DELETE LATH
		FROM LongAsyncTaskHistory LATH
			JOIN LongAsyncTasks LAT
				ON LATH.TaskId = LAT.TaskId
			JOIN @badSyns B
				ON B.SynonymListID = LAT.ReferenceId
				AND LAT.LongAsyncTaskType IN (2, 3, 4)

		-- Long Async Tasks for SynonymLoads, Synonym Migration, Synonym Migration Activation
		DELETE LAT
		FROM LongAsyncTasks LAT
			JOIN @badSyns B
				ON B.SynonymListID = LAT.ReferenceId
				AND LAT.LongAsyncTaskType IN (2, 3, 4)

		-- SynonymLoadStaging
		DELETE SLS
		FROM SynonymLoadStaging SLS
			JOIN @badSyns B
				ON B.SynonymListID = SLS.SynonymManagementID

		-- SynonymMigrationMngmt
		-- 1. reset migration from (if any ongoing)
		UPDATE SMMFrom
		SET SMMFrom.MigratingToIds = '',
			SMMFrom.Updated = GETUTCDATE(),
			SMMFrom.CacheVersion = SMM.CacheVersion + 1
		FROM SynonymMigrationMngmt SMM
			JOIN @badSyns B
				ON B.SynonymListID = SMM.SynonymMigrationMngmtID
			JOIN SynonymMigrationMngmt SMMFrom
				ON SMMFrom.SynonymMigrationMngmtID = SMM.FromSynonymListID

		-- 2. full reset bad lists
		UPDATE SMM
		SET SMM.IsSynonymListLoadedFromFile = 0,
			SMM.Updated = GETUTCDATE(),
			SMM.CacheVersion = SMM.CacheVersion + 1,
			SMM.FromSynonymListID = -1,
			SMM.SynonymMigrationStatusRID = CASE WHEN SMM.SynonymMigrationStatusRID > 1 THEN 6 ElSE 1 END,
			SMM.MigrationUserId = 0,
			SMM.ActivationUserId = 0,
			SMM.MigrationOrLoadEndDate = NULL,
			SMM.MigrationOrLoadStartDate = NULL,
			SMM.ActivationDate = NULL
		FROM SynonymMigrationMngmt SMM
			JOIN @badSyns B
				ON B.SynonymListID = SMM.SynonymMigrationMngmtID
		-- activate everything currently in process
		-- and set lists to merely created state (with no synonyms)

		-- [UPDATE] CodingElements
		UPDATE CE
		SET CE.WorkflowStateId = B.WorkflowStartStateID,
			CE.AssignedSegmentedGroupCodingPatternId = -1, 
			CE.AssignedTermCode = '',
			CE.AssignedCodingPath = '',
			CE.AssignedTermKey = '',
			CE.AssignedTermText = N'',
			CE.IsClosed = 0,
			CE.Updated = GETUTCDATE(),
			CE.CacheVersion = CE.CacheVersion + 1
		FROM CodingElements CE
			JOIN StudyDictionaryVersion SDV
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
			JOIN @badSyns B
				ON SDV.SynonymManagementID = B.SynonymListID
		WHERE CE.IsInvalidTask = 0


		-- [INSERT VERSION FIX COMMENT FOR STATE CHANGE] WorkflowTaskHistory
		INSERT INTO WorkflowTaskHistory (WorkflowTaskID, WorkflowStateID, WorkflowActionID, WorkflowSystemActionID, UserID, Comment, SegmentId, CodingAssignmentId, CodingElementGroupId, QueryId)
		SELECT CE.CodingElementId, CE.WorkflowStateID, NULL, NULL, -2, @Comment, CE.SegmentId, -1, CE.CodingElementGroupID, 0
		FROM CodingElements CE
			JOIN StudyDictionaryVersion SDV
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
			JOIN @badSyns B
				ON SDV.SynonymManagementID = B.SynonymListID
		WHERE CE.IsInvalidTask = 0

		-- Long Async Task History for STUDY MIGRATIONS -- note failure
		-- these should all be rolled back!
		INSERT INTO LongAsyncTaskHistory(TaskId, IsFailed, TaskLog, SegmentId, CommandType, AsyncTaskNodeId)
		SELECT LAT.TaskId, 1, @Comment, LATH.SegmentId, LATH.CommandType, LATH.AsyncTaskNodeId
		FROM LongAsyncTasks LAT
			JOIN StudyMigrationTraces SMT
				ON LAT.ReferenceId = SMT.StudyMigrationTraceId
				AND LAT.LongAsyncTaskType = 1
				AND (LAT.IsComplete = 0 OR LAT.IsFailed = 1)
			JOIN @badSyns B
				ON SMT.ToSynonymMgmtId = B.SynonymListID
			CROSS APPLY
			(
				SELECT TOP 1 *
				FROM LongAsyncTaskHistory LATH
				WHERE LATH.TaskId = LAT.TaskId
				ORDER BY TaskHistoryId DESC
			) AS LATH

		-- Long Async Task for STUDY MIGRATIONS -- note failure
		-- these should all be rolled back!
		UPDATE LAT
		SET LAT.IsFailed = 1,
			LAT.IsComplete = 1,
			LAT.OngoingTaskHistoryId = -1,
			LAT.Updated = GETUTCDATE(),
			LAT.CacheVersion = LAT.CacheVersion + 1
		FROM LongAsyncTasks LAT
			JOIN StudyMigrationTraces SMT
				ON LAT.ReferenceId = SMT.StudyMigrationTraceId
				AND LAT.LongAsyncTaskType = 1
				AND (LAT.IsComplete = 0 OR LAT.IsFailed = 1)
			JOIN @badSyns B
				ON SMT.ToSynonymMgmtId = B.SynonymListID

		DELETE CP
		FROM CodingPatterns CP
			JOIN @badPatterns BP
				ON CP.CodingPatternID = BP.CodingPatternID

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(4000) = N'CMP ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH	

END
