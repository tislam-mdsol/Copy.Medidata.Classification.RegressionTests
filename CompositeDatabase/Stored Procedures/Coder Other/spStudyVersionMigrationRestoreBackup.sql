/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
//
// Simple restore
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyVersionMigrationRestoreBackup')
	BEGIN
		DROP  Procedure spStudyVersionMigrationRestoreBackup
	END

GO

CREATE Procedure dbo.spStudyVersionMigrationRestoreBackup
(
	@FromVersionID INT,
	@StudyDictionaryVersionID INT, 
	@SegmentID INT,
	@RowNumbers INT,
    @LastRowId BIGINT
)
AS
BEGIN

	DECLARE @customErrorMSG NVARCHAR(4000)
	SET @customErrorMSG = 'spStudyVersionMigrationRestoreBackup.sql('+
		CAST(@FromVersionID AS NVARCHAR)+ ','+
		CAST(@StudyDictionaryVersionID AS NVARCHAR)+ ','+
		CAST(@SegmentID AS NVARCHAR)+ CONVERT(VARCHAR,GETUTCDATE(),21)

	-- verify study lock state before restoring
	DECLARE @studyLock INT
	SELECT @studyLock = StudyLock
	FROM StudyDictionaryVersion
	WHERE StudyDictionaryVersionID = @StudyDictionaryVersionID
		AND DictionaryVersionID = @FromVersionID

	IF (ISNULL(@studyLock, 0) <> 3) -- LockedBecauseOfStudyVersionMigration
	BEGIN
		SET @customErrorMSG  = @customErrorMSG + ' Incorrect StudyLock State'
		RAISERROR (@customErrorMSG,  16, 1);	
		RETURN
	END
		
	-- *** ROLLBACK to Backed UP DATA
	DECLARE @restoreTABLE TABLE(
		CodingElementID BIGINT PRIMARY KEY, 
		OldState INT,
		OldIsClosed BIT,
		OldCodingAssignment BIGINT,
		OldSegmentedGroupCodingPatternID BIGINT,
		OldCodingPath VARCHAR(300),
		OldTermCode VARCHAR(100),
		OldText NVARCHAR(900),
		OldQueryStatus TINYINT,
		NewCodingAssignmentId BIGINT,
		NewWorkflowTaskHistoryId BIGINT,
		NewTransmissionQueueItemId BIGINT,
		NewWorkflowTaskHistory2Id BIGINT,
		NewQueryHistoryId BIGINT,
		NewQueryTransmissionQueueItemId BIGINT,
		NewQueryWorkflowHistoryId BIGINT)


		INSERT INTO @restoreTABLE(
			CodingElementID, 
			OldState,
			OldIsClosed,
			OldCodingAssignment,
			OldSegmentedGroupCodingPatternID,
			OldCodingPath,
			OldTermCode,
			OldText,
			OldQueryStatus,
			NewCodingAssignmentId,
			NewWorkflowTaskHistoryId,
			NewTransmissionQueueItemId,
			NewWorkflowTaskHistory2Id,
			NewQueryHistoryId,
			NewQueryTransmissionQueueItemId,
			NewQueryWorkflowHistoryId
			)
		SELECT TOP (@rowNumbers)
			CodingElementID, 
			OldState,
			OldIsClosed,
			OldCodingAssignment,
			OldSegmentedGroupCodingPatternID,
			OldCodingPath,
			OldTermCode,
			OldText,
			OldQueryStatus,
			NewCodingAssignmentId,
			NewWorkflowTaskHistoryId,
			NewTransmissionQueueItemId,
			NewWorkflowTaskHistory2Id,
			NewQueryHistoryId,
			NewQueryTransmissionQueueItemId,
			NewQueryWorkflowHistoryId
		FROM StudyMigrationBackup
		WHERE StudyDictionaryVersionID = @StudyDictionaryVersionID
			AND FromVersionID = @FromVersionID
			AND CodingElementId > @LastRowId
		ORDER BY CodingElementId ASC	
		
		
		-- 0. Restore CodingElements
		UPDATE CE
		SET CE.WorkflowStateID = RT.OldState,
			CE.IsClosed = RT.OldIsClosed,
			CE.AssignedSegmentedGroupCodingPatternId = RT.OldSegmentedGroupCodingPatternID,
			CE.AssignedCodingPath = RT.OldCodingPath,
			CE.AssignedTermCode = RT.OldTermCode,
			CE.AssignedTermText = RT.OldText,
			CE.QueryStatus = RT.OldQueryStatus
		FROM @restoreTABLE RT
			JOIN CodingElements CE
				ON RT.CodingElementId = CE.CodingElementId
		
		-- 1. Restore old CodingAssignments
		UPDATE CA
		SET CA.Active = 1
		FROM @restoreTABLE RT
			JOIN CodingAssignment CA
				ON RT.OldCodingAssignment = CA.CodingAssignmentID
		
		-- 2. DELETE new CodingAssignements
		DELETE CA
		FROM @restoreTABLE RT
			JOIN CodingAssignment CA
				ON RT.NewCodingAssignmentId = CA.CodingAssignmentID
		WHERE RT.NewCodingAssignmentId > 0
		
		-- 3. DELETE new WorkflowTaskHistory
		DELETE WTH
		FROM @restoreTABLE RT
			JOIN WorkflowTaskHistory WTH
				ON RT.NewWorkflowTaskHistoryId = WTH.WorkflowTaskHistoryId
		WHERE RT.NewWorkflowTaskHistoryId > 0
		
		-- 4. DELETE new TransmissionQueueItems
		DELETE TQI
		FROM @restoreTABLE RT
			JOIN TransmissionQueueItems TQI
				ON RT.NewTransmissionQueueItemId = TQI.TransmissionQueueItemID
		WHERE RT.NewTransmissionQueueItemId > 0
		
		-- 5. DELETE new WorkflowTaskHistory
		DELETE WTH
		FROM @restoreTABLE RT
			JOIN WorkflowTaskHistory WTH
				ON RT.NewWorkflowTaskHistory2Id = WTH.WorkflowTaskHistoryId
		WHERE RT.NewWorkflowTaskHistory2Id > 0

		-- DELETE Query History
		DELETE CQH
		FROM @restoreTABLE RT
			JOIN CoderQueryHistory CQH
				ON RT.NewQueryHistoryId = CQH.QueryHistoryId
		WHERE RT.NewQueryHistoryId > 0

		-- DELETE Query TransmissionQueueItems
		DELETE TQI
		FROM @restoreTABLE RT
			JOIN TransmissionQueueItems TQI
				ON RT.NewQueryTransmissionQueueItemId = TQI.TransmissionQueueItemID
		WHERE RT.NewQueryTransmissionQueueItemId > 0
		
		-- DELETE Query WorkflowTaskHistory
		DELETE WTH
		FROM @restoreTABLE RT
			JOIN WorkflowTaskHistory WTH
				ON RT.NewQueryWorkflowHistoryId = WTH.WorkflowTaskHistoryId
		WHERE RT.NewQueryWorkflowHistoryId > 0

		-- Return the codingelements that were restored
		SELECT CodingElementID FROM @restoreTABLE

END
GO
  