/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
// 
// This script is to fake a study migration failue in the coder system
// 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFakeStudyMigrationFailure')
	DROP PROCEDURE spFakeStudyMigrationFailure
GO

CREATE PROCEDURE dbo.spFakeStudyMigrationFailure  
(  
	@UserLogin                             NVARCHAR(100), 
	@SegmentName                           NVARCHAR(100), 
	@StudyName                             NVARCHAR(100), 
	@FromSynonymListName                   NVARCHAR(100),
	@ToSynonymListName                     NVARCHAR(100),
	@FromMedicalDictionaryVersionLocaleKey NVARCHAR(100),
	@ToMedicalDictionaryVersionLocaleKey   NVARCHAR(100)
)  
AS  
BEGIN
--production check
	IF NOT EXISTS (
		SELECT	NULL 
		FROM	CoderAppConfiguration
		WHERE	Active = 1 
		AND		IsProduction = 0)
	
	BEGIN
		PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
		RETURN 1
	END

	DECLARE @UserID					  INT,
			@SegmentID				  INT,  
			@FromSynonymMgmtID		  INT, 
			@ToSynonymMgmtId		  INT, 
			@StudyID				  INT,
			@StudyDictionaryVersionId INT

	SELECT	@UserID = UserID
	FROM	Users
	WHERE	Login   = @UserLogin

	IF @UserID IS NULL  
	BEGIN  
		PRINT N'Cannot find User'  
		RETURN 1  
	END

	SELECT @SegmentID  = SegmentId
	FROM   Segments
	WHERE  SegmentName = @SegmentName

	IF @SegmentID IS NULL  
	BEGIN  
		PRINT N'Cannot find Segment'  
		RETURN 1  
	END

	SELECT @FromSynonymMgmtID = SynonymMigrationMngmtID
	FROM   SynonymMigrationMngmt
	WHERE  SegmentId                                                         = @SegmentID
	AND	   ListName                                                          = @FromSynonymListName
	AND    dbo.fnRemoveNonAlphaCharacters(MedicalDictionaryVersionLocaleKey) = dbo.fnRemoveNonAlphaCharacters(@FromMedicalDictionaryVersionLocaleKey)

	IF @FromSynonymMgmtID IS NULL  
	BEGIN  
		PRINT N'Cannot find Synonym Migration From Synonym List'  
		RETURN 1  
	END 

	SELECT @ToSynonymMgmtId = SynonymMigrationMngmtID
	FROM   SynonymMigrationMngmt
	WHERE  SegmentId                                                         = @SegmentID
	AND	   ListName                                                          = @ToSynonymListName
	AND    dbo.fnRemoveNonAlphaCharacters(MedicalDictionaryVersionLocaleKey) = dbo.fnRemoveNonAlphaCharacters(@ToMedicalDictionaryVersionLocaleKey)

	IF @ToSynonymMgmtId IS NULL  
	BEGIN  
		PRINT N'Cannot find Synonym Migration To Synonym List'  
		RETURN 1  
	END 

	SELECT @StudyID           = TrackableObjectID
	FROM   TrackableObjects
	WHERE  ExternalObjectName = @StudyName 
	AND    SegmentId          = @SegmentID

	IF @StudyID IS NULL  
	BEGIN  
		PRINT N'Cannot find StudyName'  
		RETURN 1  
	END

	SELECT @StudyDictionaryVersionId = StudyDictionaryVersionID
	FROM   StudyDictionaryVersion
	WHERE  StudyID                   = @StudyID 
	AND    SegmentID                 = @SegmentID 

	IF @StudyDictionaryVersionId IS NULL  
	BEGIN  
		PRINT N'Cannot find Study Dictionary Version'
		RETURN 1  
	END

	--Start study migaration via sql
	--1.0 instantiate study migration trace
	DECLARE @Created			   DATETIME, 
	        @Updated			   DATETIME, 
	        @StudyMigrationTraceId INT

	EXEC spStudyMigrationTraceInsert 
		@UserID, 
		@SegmentID,
		@StudyID, 
		@FromSynonymMgmtID,  
		@ToSynonymMgmtId, 
		@StudyDictionaryVersionId,
		0,									--CurrentStage
		0,			                        --CacheVersion
		@Created               OUTPUT, 
		@Updated               OUTPUT, 
		@StudyMigrationTraceId OUTPUT

	--1.1 instantiate long async task
	DECLARE @TaskID INT 

	EXEC spLongAsyncTaskInsert 
		@StudyMigrationTraceId, 
		0,							--IsComplete
		0,		                    --IsFailed
		@SegmentID, 
		1,                          --LongAsyncTaskType
		1,                          --CommandType
		-1,                         --OngoingTaskHistoryId
		null,                       --EarliestAllowedStartTime
		@Created OUTPUT, 
		@Updated OUTPUT, 
		@TaskID  OUTPUT 

	--1.2 instantiate Long async task history and correlate long asyc task with task history id just created
	DECLARE @TaskHistoryId INT
	
	EXEC spLongAsyncTaskHistoryInsert 
		@TaskID,
		0,							--IsFailed
		@SegmentID,
		1,	                        --CommandType
		null,                       --TaskLog
		@Created       OUTPUT, 
		@Updated       OUTPUT, 
		@TaskHistoryId OUTPUT

	UPDATE LongAsyncTasks
	SET    OngoingTaskHistoryId = @TaskHistoryId
	WHERE  TaskId               = @TaskID

	--2.0 start study migration
	UPDATE StudyDictionaryVersion
	SET    StudyLock = 3
	WHERE  StudyDictionaryVersionID = @StudyDictionaryVersionId

	--2.1 check if tasks in workflow svc
	--2.2 Delete OLD Backup
	DELETE FROM StudyMigrationBackup
	WHERE       StudyDictionaryVersionID = @StudyDictionaryVersionId

	--2.3 back up all data
	DECLARE @RowNumbers    INT = 100000,
		    @CountedBackup INT, 
			@ClearedCount  INT
	
	EXEC spStudyMigrationBackupAllData 
		@FromMedicalDictionaryVersionLocaleKey, 
		@StudyDictionaryVersionId, 
		@RowNumbers, 
		-1,											--MinCodingElementId
		@CountedBackup

	--2.4 clear all assignments
	EXEC spStudyMigrationClearAllAssignments 
		@StudyDictionaryVersionId, 
		@RowNumbers, 
		@ClearedCount

	--2.5 Mimic failure at Recode to future version automation
	UPDATE StudyMigrationTraces
	SET    CurrentStage = 4
	WHERE  StudyMigrationTraceId = @StudyMigrationTraceId

	DECLARE @FailureReason VARCHAR(200)= 'Fake Study Migration Failure for SQA testing: Study Migration failed at stage RecodeToFutureVersionAutomation.'
	
	UPDATE LongAsyncTaskHistory
	SET    IsFailed      = 1, 
		   TaskLog       = @FailureReason
	WHERE  TaskHistoryId = @TaskHistoryId

	UPDATE LongAsyncTasks
	SET    IsComplete           = 1, 
		   IsFailed             = 1,  
		   OngoingTaskHistoryId = -1, 
		   Updated              = GetUtcDate()
	WHERE  TaskId               = @TaskID
END