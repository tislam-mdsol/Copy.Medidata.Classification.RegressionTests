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
// This script is to fake a workflow bot failure due to max re-try number reached in the coder system
// 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFakeWorkflowBotFailure')
	DROP PROCEDURE spFakeWorkflowBotFailure
GO

CREATE PROCEDURE dbo.spFakeWorkflowBotFailure  
(  
	@UserLogin NVARCHAR(100), 
	@SegmentOID  NVARCHAR(100),  
	@DictionaryOID  VARCHAR(100),
	@DictionaryLocale CHAR(3),
	@VersionOID VARCHAR(100),
	@SynonymListName NVARCHAR(100),
	@groupVerbatim NVARCHAR(450),
	@FailTimes INT, -- how many times the fake failed
	@FailureReason NVARCHAR(500) = 'Failure Reason',
	@BotLog VARCHAR(500) = 'BotLog string',
	@commandType INT = 1 -- default to RUN
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

	DECLARE @UserID INT, @MedicalDictionaryID INT, @SegmentID INT, @StudyID INT, @VersionID INT, @SynonymMgmtID INT
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

	SELECT @VersionID = DictionaryVersionRefID
	FROM DictionaryVersionRef
	WHERE OID = @VersionOID AND DictionaryRefID = @MedicalDictionaryID

	IF @VersionID IS NULL  
	BEGIN  
		PRINT N'Cannot find Version OID'  
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

	SELECT @SynonymMgmtID = SynonymMigrationMngmtID
	FROM SynonymMigrationMngmt
	WHERE SegmentID = @SegmentID
		AND MedicalDictionaryID = @MedicalDictionaryID
		AND Locale = @DictionaryLocale
		AND ListName = @SynonymListName

	IF @SynonymMgmtID IS NULL  
	BEGIN  
		PRINT N'Cannot find SynonymListName'  
		RETURN 1  
	END

	DECLARE @SegmentedCodingPatternId BIGINT

	SELECT TOP 1 @SegmentedCodingPatternId = SegmentedGroupCodingPatternId
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN CodingElementGroups CEG
			ON CEG.CodingElementGroupID = SGCP.CodingElementGroupID
		CROSS APPLY
		(
			SELECT ISNULL(MAX(GroupVerbatimID), -1) AS GroupVerbatimID
			FROM GroupVerbatimEng GV
			WHERE GV.VerbatimText = @groupVerbatim
				AND GV.GroupVerbatimId = CEG.GroupVerbatimID
				AND @DictionaryLocale = 'eng'
		 ) AS GVE 
		CROSS APPLY
		(
			SELECT ISNULL(MAX(GroupVerbatimID), -1) AS GroupVerbatimID
			FROM GroupVerbatimJpn GV
			WHERE GV.VerbatimText = @groupVerbatim
				AND GV.GroupVerbatimId = CEG.GroupVerbatimID
				AND @DictionaryLocale = 'jpn'
		 ) AS GVJ
	WHERE SGCP.SynonymManagementID = @SynonymMgmtID
		AND 
		(
			(GVE.GroupVerbatimID > 0 AND @DictionaryLocale = 'eng') OR
			(GVJ.GroupVerbatimID > 0 AND @DictionaryLocale = 'jpn')
		)
		-- only synonyms
		AND SGCP.SynonymStatus = 2

	IF (@SegmentedCodingPatternId IS NULL)
	BEGIN
		PRINT N'Cannot find Synonym'  
		RETURN 1  
	END

	BEGIN TRANSACTION
	BEGIN TRY

		--Start WorflowBOT via sql
		--1.0 instantiate a bot element entity
		DECLARE @Created DATETIME, @Updated DATETIME, @BotElementId INT, @IsForwardBOT BIT = 1
		EXEC spBOTElementInsert @SegmentID, @UserID, @SegmentedCodingPatternId, @IsForwardBOT, @FailureReason, @BotLog, @Created OUTPUT, @Updated OUTPUT, @BotElementId OUTPUT

		--1.1 instantiate corresponding long async task (in a failed state - but not complete)
		DECLARE @TaskID INT, @LongAsyncTaskType TINYINT = 6 --workflowbot
		EXEC spLongAsyncTaskInsert @BotElementId, 0, 0, @SegmentID, @LongAsyncTaskType, @commandType,-1, NULL, @Created OUTPUT, @Updated OUTPUT, @TaskID OUTPUT 

		DECLARE @i INT = 0

		-- not more than 9
		IF (ISNULL(@FailTimes, 9) > 9)
			SET @FailTimes = 9

		-- not less than 1
		IF (ISNULL(@FailTimes, 9) < 0)
			SET @FailTimes = 1

		-- generate @FailTimes times log
		WHILE (@i < @FailTimes)
		BEGIN

			-- IsFailed
			EXEC spLongAsyncTaskHistoryInsert @TaskID, 1, @SegmentID, @commandType, @FailureReason, 1000001, NULL, NULL, NULL

			SET @i = @i + 1
		END

		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		
		PRINT N'Caught Exception'
		ROLLBACK TRANSACTION
		
		DECLARE	@ErrorSeverity int, 
				@ErrorState int,
				@ErrorLine int,
				@ErrorMessage nvarchar(4000),
				@ErrorProc nvarchar(4000)

		SELECT @ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorLine = ERROR_LINE(),
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorProc = ERROR_PROCEDURE()
		SELECT @ErrorMessage = coalesce(@ErrorProc, 'spFakeWorkflowBotFailure.sql - Cauught Exception in line(') + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage + CONVERT(VARCHAR,GETUTCDATE(),21)
		PRINT @ErrorMessage
		RAISERROR (@ErrorMessage,  @ErrorSeverity, @ErrorState);

	END CATCH

END