/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Eric Grun egrun@mdsol.com
//
// Reset tasks that have been coded to the previous version during a Study Migration.
// This bug was present for Coder version 2015.1.0 and 2015.1.1 and was fixed in 2015.2.0
// 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_ResetCodingElementsCodedToPreviousDuringStudyMigration')
	DROP PROCEDURE dbo.spCoder_CMP_ResetCodingElementsCodedToPreviousDuringStudyMigration
GO

CREATE PROCEDURE dbo.spCoder_CMP_ResetCodingElementsCodedToPreviousDuringStudyMigration
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @errorString NVARCHAR(MAX)
	,@successString NVARCHAR(MAX)

	DECLARE @trancount INT
	SET @trancount = @@TRANCOUNT

	BEGIN TRY
		IF @trancount = 0
			BEGIN TRANSACTION
		ELSE
			SAVE TRANSACTION XResetCodingElementsMCC166874
	
	DECLARE @updatedCodingTasks TABLE
		(
		[SegmentId] BIGINT
		,[CodingElementID] BIGINT
		,[WorkflowStateID] BIGINT
		,[CodingElementGroupId] BIGINT
		)

	DECLARE @Comment AS NVARCHAR(250) = 'Coding decision reset due to MCC-166874' 

	SELECT ce.[codingelementid]
	INTO #CodingElementsToReset
		FROM [codingelements] ce 
		JOIN [segments] s ON s.[segmentid] = ce.[SegmentId]
		JOIN [studydictionaryversion] sdv ON sdv.[StudyDictionaryVersionID] = ce.[StudyDictionaryVersionId]
		JOIN [trackableobjects] tro ON tro.[TrackableObjectID] = sdv.[studyid]
		JOIN [dictionaryref] dr ON dr.[DictionaryRefID] = sdv.[MedicalDictionaryID]
		JOIN [dictionaryversionref] dvr ON dvr.[DictionaryVersionRefID] = sdv.[DictionaryVersionId]
		JOIN [codingassignment] ca ON ca.[active] = 1 AND ca.[CodingElementID] = ce.[CodingElementId]  
	WHERE ce.[IsInvalidTask] = 0
		AND sdv.[Updated] > '2-1-2015'
		AND sdv.[NumberOfMigrations] > 0
		AND ca.[DictionaryVersionId] <> sdv.[dictionaryversionid] -- Coding Assignment version does not match version for the Study

	UPDATE ce
	SET ce.[workflowstateid] = 1
	OUTPUT 
		INSERTED.[segmentId],
		INSERTED.[codingelementId],
		INSERTED.[workflowstateId],
		INSERTED.[codingelementgroupId]
	INTO @updatedCodingTasks
	FROM [codingelements] ce
	JOIN #CodingElementsToReset tce on ce.[codingelementid] = tce.[codingelementid]

	--create a task history entry for the change
	INSERT INTO [WorkflowTaskHistory]
			( [WorkflowTaskID]
			,[WorkflowStateID]
			,[WorkflowActionID]
			,[WorkflowSystemActionID]
			,[UserID]
			,[Comment]
			,[SegmentId]
			,[CodingAssignmentId]
			,[CodingElementGroupId]
			,[QueryId]
			)
	SELECT  UT.[CodingElementId]
			,UT.[WorkflowStateID]
			,NULL
			,NULL
			,-2
			,@Comment
			,UT.[SegmentId]
			,-1
			,UT.[CodingElementGroupID]
			,0
	FROM    @updatedCodingTasks UT

	DECLARE @updatedCount INT
	SELECT @updatedCount = Count(*) FROM @updatedCodingTasks

	SET @successString = N'Tasks have been reset: '+ CONVERT(NVARCHAR, @updatedCount)
	PRINT @successString

	SELECT * FROM @updatedCodingTasks

	IF @trancount = 0
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

		DECLARE
		@XState INT = XACT_STATE(),
		@ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
		@ErrorNumber INT = ERROR_NUMBER(),
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorProcedure NVARCHAR(200) = ISNULL(ERROR_PROCEDURE(), 'spCoder_CMP_ResetCodingElementsCodedToPreviousDuringStudyMigration');

		IF @XState = -1
			ROLLBACK TRANSACTION
		IF @XState = 1 and @trancount = 0
			ROLLBACK TRANSACTION
		IF @XState = 1 and @trancount > 1
			ROLLBACK TRANSACTION XForceCompleteFailedTasks

		SET @errorString = N'CMP ERROR: Transaction Error Message - Error ' + CONVERT(VARCHAR,@ErrorNumber) +
			N', Severity ' + CONVERT(VARCHAR,@ErrorSeverity) + 
			N', State ' + CONVERT(VARCHAR,@ErrorState) + 
			N', Procedure ' + @ErrorProcedure + 
			N', Line '+ CONVERT(VARCHAR,@ErrorLine) +
			N', Message: ' + @ErrorMessage

		PRINT @errorString
		RAISERROR (@errorString, @ErrorSeverity, 1)

	END CATCH

END