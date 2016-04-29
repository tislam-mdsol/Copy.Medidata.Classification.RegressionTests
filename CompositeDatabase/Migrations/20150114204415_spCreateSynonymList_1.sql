/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Connor Ross cross@mdsol.com
// required by automation
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateSynonymList')
	DROP PROCEDURE spCreateSynonymList
GO
CREATE PROCEDURE dbo.spCreateSynonymList  
(  
 @Segment NVARCHAR(500),
 @Dictionary NVARCHAR(100),  
 @Version  NVARCHAR(100),
 @Locale  CHAR(3),
 @SynonymListName NVARCHAR(100)
)  
AS 
BEGIN

	SET XACT_ABORT ON
	
	 --production check
	IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
	BEGIN
		PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
		RETURN
	END

	DECLARE @dictID INT, @versionOrdinal INT, @versionID INT, @segmentID INT, @dictVersionID INT, @synonymListId INT, @Created datetime ,@Updated datetime,@SynonymMigrationMngmtID int, @Locale_Lower CHAR(3)
	
	SELECT @Locale_Lower = LOWER(@LOCALE)

	SELECT @dictID = DictionaryRefID  
	FROM DictionaryRef  
	WHERE OID = @Dictionary  

	IF @dictID IS NULL  
	BEGIN  
		PRINT N'Cannot find dictionary OID'  
		RETURN 1  
	END  

	SELECT @versionOrdinal = Ordinal,
		@versionID = DictionaryVersionRefID
	FROM DictionaryVersionRef  
	WHERE OID = @Version  
		AND DictionaryRefID = @dictID  

	IF @versionOrdinal IS NULL  
	BEGIN  
		PRINT N'Cannot find Version OID'  
		RETURN 1  
	END

	SELECT @segmentID = SegmentId  
	FROM Segments  
	WHERE OID = @Segment 

	IF @segmentID IS NULL  
	BEGIN  
		PRINT N'Cannot find Segment OID'  
		RETURN 1  
	END
	
	SELECT @dictVersionID = DictionaryVersionRefID  
	FROM DictionaryVersionRef  
	WHERE DictionaryRefID = @dictID
		AND Ordinal = @versionOrdinal 

	IF @dictVersionID IS NULL  
	BEGIN  
		PRINT N'Cannot find dictionary version'  
		RETURN 1  
	END
	-- 0. verify dictionary is available
	SELECT @synonymListId = SynonymMigrationMngmtID FROM SynonymMigrationMngmt
		WHERE SegmentId = @segmentID
			AND MedicalDictionaryID = @dictID
			And DictionaryVersionId = @dictVersionID
			AND Deleted = 0
			AND ListName = @SynonymListName
			AND Locale = @Locale_Lower
	
	IF @synonymListId IS NOT NULL
	BEGIN
		PRINT N'Synonym Management Entry for dictionary & segment already exists'  
		RETURN 0 			
	END
		
		EXECUTE dbo.spSynonymMigrationManagementInsert  @dictVersionID, -1,
		        @SynonymListName, @Created output, @Updated output, @dictID, @Locale_Lower, 1,
		        0, 
		        NULL, NULL, NULL,
		        0, 0, '', 0, @SynonymMigrationMngmtID output, @segmentID 
		
END