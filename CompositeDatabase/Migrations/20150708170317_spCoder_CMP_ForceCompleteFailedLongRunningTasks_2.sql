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
// This will clean out Failed jobs from the Job Management admin page. 
//
// @SegmentName: The name of the Segment
// @TaskType: The type of the task listed on the admin page
// @CommaDelimitedReferenceIDs: Comma delimited list of reference id's for the tasks. Leave null to clean all jobs of that type for the segment.
//
// Use the ReferenceId ##'s from the admin page as input for this cmp
// 
//      StudyMigration             = 1,
//      SynonymMigration           = 2,
//      SynonymMigrationActivation = 3,
//      SynonymLoad                = 4,
//      WorkflowBot                = 6
// 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_ForceCompleteFailedLongRunningTasks')
	DROP PROCEDURE dbo.spCoder_CMP_ForceCompleteFailedLongRunningTasks
GO

CREATE PROCEDURE dbo.spCoder_CMP_ForceCompleteFailedLongRunningTasks
(
 @SegmentName NVARCHAR(255),
 @TaskType VARCHAR(600),
 @CommaDelimitedReferenceIDs NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @trancount INT
	SET @trancount = @@TRANCOUNT

	BEGIN TRY
		IF @trancount = 0
			BEGIN TRANSACTION
		ELSE
			SAVE TRANSACTION XForceCompleteFailedTasks
			
		DECLARE @errorString NVARCHAR(MAX)
		,@successString NVARCHAR(MAX)
		,@SegmentId INT
		,@LongAsyncTaskType INT
		DECLARE @ReferenceIDs TABLE (ReferenceID BIGINT)
		DECLARE @Temp_UpdatedReferenceIDs TABLE (TaskId INT, ReferenceID BIGINT)

		SELECT @SegmentId = SegmentId
		FROM Segments 
		WHERE SegmentName = @SegmentName

		IF (@SegmentId IS NULL)
		BEGIN
			SET @errorString = N'ERROR: No such segment found!'
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		SELECT @LongAsyncTaskType =  
			CASE @TaskType
				WHEN 'StudyMigration' THEN 1
				WHEN 'SynonymMigration' THEN 2
				WHEN 'SynonymMigrationActivation' THEN 3
				WHEN 'SynonymLoad' THEN 4
				WHEN 'WorkflowBot' THEN 6
				ELSE 0
			END

		IF (@LongAsyncTaskType <= 0)
		BEGIN
			SET @errorString = N'ERROR: Job type is not recognized!'
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		INSERT INTO @ReferenceIDs (ReferenceID)  
			SELECT CAST(item AS BIGINT)
			FROM dbo.fnParseDelimitedString(@CommaDelimitedReferenceIDs, ',')

		IF NOT EXISTS (SELECT * FROM @ReferenceIDs)
		BEGIN
			SET @errorString = N'ERROR: No tasks marked for completion!'
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		--update the tasks
		UPDATE lt
		SET lt.IsFailed = 0
		OUTPUT 
			INSERTED.TaskID,
			INSERTED.ReferenceID
		INTO
			@Temp_UpdatedReferenceIDs
		FROM LongAsyncTasks lt
		JOIN @ReferenceIDs R on lt.ReferenceID = R.ReferenceID
		WHERE lt.SegmentId = @SegmentId
		AND lt.LongAsyncTaskType = @LongAsyncTaskType
		AND lt.IsComplete = 1
		AND lt.IsFailed = 1
	
		--Verify results
		IF EXISTS (SELECT NULL
			FROM @ReferenceIDs R
			LEFT JOIN @Temp_UpdatedReferenceIDs T
			ON R.ReferenceID = T.ReferenceID
			WHERE T.ReferenceID IS NULL
			AND R.ReferenceID <> 0)
		BEGIN
			SELECT @errorString = COALESCE(@errorString + N', ', N'ERROR: Could not modify the following tasks: ') + CONVERT(NVARCHAR, R.ReferenceID)			
			FROM @ReferenceIDs R
			LEFT JOIN @Temp_UpdatedReferenceIDs T
			ON R.ReferenceID = T.ReferenceID
			WHERE T.ReferenceID IS NULL
			AND R.ReferenceID <> 0

			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		-- create an audit log entry for each task		
		DECLARE 
		@IsFailed BIT = 1,
		@CommandType TINYINT = 3,	
		@TaskLog NVARCHAR(1000) = 'Failed task marked complete by CMP',
		@Created DATETIME = GETUTCDATE()

		INSERT INTO LongAsyncTaskHistory (TaskId, IsFailed, TaskLog, SegmentId, CommandType, Created, Updated)
			SELECT U.TaskID, @IsFailed, @TaskLog, @SegmentId, @CommandType, @Created, @Created
			FROM @Temp_UpdatedReferenceIDs U

		--done
		DECLARE @updatedCount INT
		SELECT @updatedCount = Count(*) FROM @Temp_UpdatedReferenceIDs

		SET @successString = N'Success! Tasks have been marked as completed: '+ CONVERT(NVARCHAR, @updatedCount)
		PRINT @successString

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
		@ErrorProcedure NVARCHAR(200) = ISNULL(ERROR_PROCEDURE(), 'spCoder_CMP_ForceCompleteFailedLongRunningTasks');

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