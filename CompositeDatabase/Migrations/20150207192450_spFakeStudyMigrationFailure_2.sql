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
--exec spFakeStudyMigrationFailure 'coderadmin','MedidataReserved1','MedidataRsrvd1','MedDRA','eng','12.0','13.0','Primary','Primary'
CREATE PROCEDURE dbo.spFakeStudyMigrationFailure  
(  
 @UserLogin NVARCHAR(100), 
 @SegmentOID  NVARCHAR(100),  
 @StudyName NVARCHAR(100),
 @DictionaryOID  VARCHAR(100),
 @DictionaryLocale CHAR(3),
 @FromVersionOID VARCHAR(100),
 @ToVersionOID VARCHAR(100),
 @FromSynonymListName NVARCHAR(100),
 @ToSynonymListName NVARCHAR(100)
)  
AS  
BEGIN
--production check
 IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
BEGIN
	PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	RETURN 1
END

DECLARE @UserID INT, @MedicalDictionaryID INT, @SegmentID INT, @StudyID INT, @FromVersionID INT, @FromSynonymMgmtID INT, @ToVersionID INT, @ToSynonymMgmtId INT, @StudyDictionaryVersionId INT
SELECT @UserID = UserID
FROM Users
WHERE Login = @UserLogin

SELECT @MedicalDictionaryID = DictionaryRefID
FROM Dictionaryref
WHERE  OID = @DictionaryOID

IF @MedicalDictionaryID IS NULL  
BEGIN  
	PRINT N'Cannot find dictionary OID'  
	RETURN 1  
END  

SELECT @FromVersionID = DictionaryVersionRefID
FROM DictionaryVersionRef
WHERE OID = @FromVersionOID AND DictionaryRefID = @MedicalDictionaryID

IF @FromVersionID IS NULL  
BEGIN  
	PRINT N'Cannot find FromVersion OID'  
	RETURN 1  
END 
SELECT @ToVersionID = DictionaryVersionRefID
FROM DictionaryVersionRef
WHERE OID = @ToVersionOID AND DictionaryRefID = @MedicalDictionaryID

IF @ToVersionID IS NULL  
BEGIN  
	PRINT N'Cannot find ToVersion OID'  
	RETURN 1  
END 

SELECT @SegmentID = SegmentId
FROM Segments
WHERE OID = @SegmentOID

IF @SegmentID IS NULL  
BEGIN  
	PRINT N'Cannot find Segment'  
	RETURN 1  
END 

SELECT @FromSynonymMgmtID = SynonymMigrationMngmtID
FROM SynonymMigrationMngmt
WHERE SegmentID = @SegmentID
AND MedicalDictionaryID = @MedicalDictionaryID
AND Locale = @DictionaryLocale
AND ListName = @FromSynonymListName

IF @FromSynonymMgmtID IS NULL  
BEGIN  
	PRINT N'Cannot find FromSynonymListName'  
	RETURN 1  
END 

SELECT @ToSynonymMgmtID = SynonymMigrationMngmtID
FROM SynonymMigrationMngmt
WHERE SegmentID = @SegmentID
AND MedicalDictionaryID = @MedicalDictionaryID
AND Locale = @DictionaryLocale
AND ListName = @ToSynonymListName
IF @ToSynonymMgmtID IS NULL  
BEGIN  
	PRINT N'Cannot find ToSynonymListName'  
	RETURN 1  
END 
SELECT @StudyID = TrackableObjectID
FROM TrackableObjects
WHERE ExternalObjectName = @StudyName And SegmentId = @SegmentID
IF @StudyID IS NULL  
BEGIN  
	PRINT N'Cannot find StudyName'  
	RETURN 1  
END

SELECT @StudyDictionaryVersionId = StudyDictionaryVersionID
FROM StudyDictionaryVersion
WHERE StudyID = @StudyID 
AND SegmentID = @SegmentID 
AND MedicalDictionaryID = @MedicalDictionaryID
AND DictionaryLocale = @DictionaryLocale
IF @StudyDictionaryVersionId IS NULL  
BEGIN  
	PRINT N'Cannot find Study run on ' + @DictionaryOID +' (' + @DictionaryLocale +')'
	RETURN 1  
END
 
--Start study migaration via sql
--1.0 instantiate study migration trace
DECLARE @Created DATETIME, @Updated DATETIME, @StudyMigrationTraceId INT
exec spStudyMigrationTraceInsert @UserID, @SegmentID,@StudyID, @FromVersionID, @FromSynonymMgmtID, @ToVersionID, @ToSynonymMgmtId, @StudyDictionaryVersionId,0, 0, @Created OUTPUT, @Updated OUTPUT, @StudyMigrationTraceId OUTPUT

--1.1 instantiate long async task
DECLARE @TaskID INT 
exec spLongAsyncTaskInsert @StudyMigrationTraceId, 0, 0, @SegmentID, 1,1,-1, null, @Created OUTPUT, @Updated OUTPUT, @TaskID OUTPUT 

--1.2 instantiate Long async task history and correlate long asyc task with task history id just created
DECLARE @TaskHistoryId INT
exec  spLongAsyncTaskHistoryInsert @TaskID,0,@SegmentID,1,null,@Created OUTPUT, @Updated OUTPUT, @TaskHistoryId OUTPUT
Update LongAsyncTasks
Set OngoingTaskHistoryId = @TaskHistoryId
Where TaskId = @TaskID

--2.0 start study migration
Update StudyDictionaryVersion
Set StudyLock = 3
Where StudyDictionaryVersionID = @StudyDictionaryVersionId

--2.1 check if tasks in workflow svc
--2.2 Delete OLD Backup
DELETE FROM StudyMigrationBackup
	WHERE StudyDictionaryVersionID = @StudyDictionaryVersionId
--2.3 Clear old suggestions
DELETE FROM CodingSuggestions
	WHERE SegmentID = @SegmentID
		AND DictionaryVersionID = @FromVersionID
		AND CodingElementID IN (SELECT CodingElementID FROM CodingElements
							WHERE SegmentID = @SegmentID
								AND StudyDictionaryVersionID = @StudyDictionaryVersionId)
--2.4 back up all data
DECLARE @RowNumbers INT = 100000, @CountedBackup INT, @ClearedCount INT
exec spStudyMigrationBackupAllData @FromVersionID, @StudyDictionaryVersionId, @RowNumbers, -1, @CountedBackup

--2.5 clear all assignments
exec spStudyMigrationClearAllAssignments @StudyDictionaryVersionId, @RowNumbers, @ClearedCount

--2.6 Mimic failure at Recode to future version automation
Update StudyMigrationTraces
Set CurrentStage = 4
Where StudyMigrationTraceId = @StudyMigrationTraceId
DECLARE @FailureReason VARCHAR(100)= 'Fake Study Migration Failure for SQA testing: Study Migration failed at stage RecodeToFutureVersionAutomation.'
Update LongAsyncTaskHistory
Set IsFailed = 1, TaskLog = @FailureReason
Where TaskHistoryId = @TaskHistoryId

Update LongAsyncTasks
Set IsComplete = 1, IsFailed = 1,  OngoingTaskHistoryId = -1, Updated = GetUtcDate()
Where TaskId = @TaskID

END