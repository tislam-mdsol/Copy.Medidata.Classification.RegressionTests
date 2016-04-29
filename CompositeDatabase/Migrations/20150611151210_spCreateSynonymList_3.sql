
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

	DECLARE @versionID INT, @segmentID INT, @synonymListId INT, @Created datetime ,@Updated datetime,@SynonymMigrationMngmtID int, @Locale_Lower CHAR(3)
	
	SELECT @Locale_Lower = LOWER(@LOCALE)

	DECLARE @t TABLE(versionId INT PRIMARY KEY, dictionaryid INT, dictionaryOid VARCHAR(50), versionOid VARCHAR(50))

	INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid)
	EXECUTE spGetDictionaryAndVersions
   
	SELECT @versionID = versionId
	FROM @t
	WHERE dictionaryOid = @Dictionary
		AND versionOid = @Version

	IF @versionID IS NULL  
	BEGIN  
		PRINT N'Cannot find Version'  
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
	
	-- 0. verify dictionary is available
	SELECT @synonymListId           = SynonymMigrationMngmtID FROM SynonymMigrationMngmt
		WHERE SegmentId             = @segmentID
			And DictionaryVersionId = @versionID
			AND Deleted             = 0
			AND ListName            = @SynonymListName
			AND Locale              = @Locale_Lower
	
	IF @synonymListId IS NOT NULL
	BEGIN
		PRINT N'Synonym Management Entry for dictionary & segment already exists'  
		RETURN 0 			
	END
		
		EXECUTE dbo.spSynonymMigrationManagementInsert  @versionID, -1,
		        @SynonymListName, @Created output, @Updated output, @Locale_Lower, 1,
		        0, 
		        NULL, NULL, NULL,
		        0, 0, '', 0, @SynonymMigrationMngmtID output, @segmentID 
		
END