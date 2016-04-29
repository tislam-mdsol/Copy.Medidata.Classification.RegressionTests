/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
//
// Probes long running task data for investigative purposes
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_LongRunningTaskProbe')
	DROP PROCEDURE spCoder_LongRunningTaskProbe
GO

CREATE PROCEDURE dbo.spCoder_LongRunningTaskProbe
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @taskTypes TABLE (TypeID INT, TypeName VARCHAR(50), RefTable VARCHAR(50), RefId VARCHAR(50))
	INSERT INTO @taskTypes (TypeID, TypeName, RefTable, RefId)
	VALUES 
		(1, 'StudyMigration', 'StudyMigrationTraces', 'StudyMigrationTraceId'),
		(2, 'SynonymMigration', 'SynonymMigrationMngmt', 'SynonymMigrationMngmtID'),
		(3, 'SynonymMigrationActivation', 'SynonymMigrationMngmt', 'SynonymMigrationMngmtID'),
		(4, 'SynonymLoad', 'SynonymMigrationMngmt', 'SynonymMigrationMngmtID'),
		(6, 'WorkflowBOT', 'BOTElements', 'BOTElementID')
		
	CREATE TABLE #IdReferences
	(
		ID INT PRIMARY KEY
	)
	
	DECLARE @taskTypeID INT, @taskTypeName VARCHAR(50), @refTable VARCHAR(50), @refId VARCHAR(50)
	
	DECLARE typeCursor CURSOR FORWARD_ONLY FOR
	SELECT TypeID, TypeName, RefTable, RefId
	FROM @taskTypes

	OPEN typeCursor

	WHILE (1 = 1)
	BEGIN

		FETCH typeCursor INTO @taskTypeID, @taskTypeName, @refTable, @refId
		IF (@@fetch_status <> 0) BREAK
	
		DELETE #IdReferences

		-- collect the taskTypes with open multiple enqueues
		INSERT INTO #IdReferences
		SELECT ReferenceId
		FROM LongAsyncTasks
		WHERE LongAsyncTaskType = @taskTypeID
			AND IsComplete = 0
			AND IsFailed = 0
		GROUP BY ReferenceId
		HAVING COUNT(*) > 1
		
		SELECT @taskTypeName, LAT.*, LATH.*
		FROM #IdReferences IR 
			JOIN LongAsyncTasks LAT
				ON LAT.ReferenceId = IR.ID
			JOIN LongAsyncTaskHistory LATH
				ON LAT.TaskId = LATH.TaskId
		WHERE LongAsyncTaskType = @taskTypeID
			AND ReferenceId IN (SELECT ID FROM #IdReferences)
		ORDER BY LAT.ReferenceId, LAT.TaskId, LATH.TaskHistoryId
			
		DECLARE @dynSQL VARCHAR(2000)
		
		SELECT @dynSQL = 
		'SELECT '''+@taskTypeName+''', *
		FROM '+@refTable+'
		WHERE '+@refId+' IN (SELECT ID FROM #IdReferences)
		ORDER BY '+@refId
		
		EXEC(@dynSQL)

	END
	
	CLOSE typeCursor
	DEALLOCATE typeCursor
	
	-- *** Study Migration Only Probe ***
		
	DELETE #IdReferences
	
	INSERT INTO #IdReferences
	SELECT StudyDictionaryVersionId
	FROM LongAsyncTasks LAT
		JOIN StudyMigrationTraces SMT
			ON LAT.ReferenceId = SMT.StudyMigrationTraceId
	WHERE LongAsyncTaskType = 1
		AND IsComplete = 0
		AND IsFailed = 0		
	GROUP BY SMT.StudyDictionaryVersionId
	HAVING COUNT(*) > 1
	
	SELECT 'StudyDictionaryVersion.StudyMigration', * 
	FROM #IdReferences IR
		JOIN StudyMigrationTraces SMT
			ON IR.ID = SMT.StudyDictionaryVersionId
		JOIN LongAsyncTasks LAT
			ON LAT.ReferenceId = SMT.StudyMigrationTraceId
		JOIN LongAsyncTaskHistory LATH
			ON LAT.TaskId = LATH.TaskId
	WHERE LongAsyncTaskType = @taskTypeID
		AND ReferenceId IN (SELECT ID FROM #IdReferences)
	ORDER BY SMT.StudyDictionaryVersionId, LAT.ReferenceId, LAT.TaskId, LATH.TaskHistoryId
		
END