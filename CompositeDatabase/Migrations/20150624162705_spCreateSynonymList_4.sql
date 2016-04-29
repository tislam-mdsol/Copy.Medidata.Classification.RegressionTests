
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateSynonymList')
	DROP PROCEDURE spCreateSynonymList
GO
CREATE PROCEDURE dbo.spCreateSynonymList  
(  
	 @Segment NVARCHAR(500),
	 @MedicalDictionaryVersionLocaleKey NVARCHAR(100),
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

	DECLARE  @segmentID INT, @synonymListId INT, @Created datetime ,@Updated datetime,@SynonymMigrationMngmtID int

	SELECT @segmentID = SegmentId  
	FROM Segments  
	WHERE OID = @Segment 

	IF @segmentID IS NULL  
	BEGIN  
		PRINT N'Cannot find Segment OID'  
		RETURN 1  
	END
	
	-- 0. verify dictionary is available
	SELECT @synonymListId                         = SynonymMigrationMngmtID FROM SynonymMigrationMngmt
		WHERE SegmentId                           = @segmentID
			And MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
			AND Deleted                           = 0
			AND ListName                          = @SynonymListName
	
	IF @synonymListId IS NOT NULL
	BEGIN
		PRINT N'Synonym Management Entry for dictionary & segment already exists'  
		RETURN 0 			
	END
		
		EXECUTE dbo.spSynonymMigrationManagementInsert  -1,
		        @SynonymListName, @Created output, @Updated output, @MedicalDictionaryVersionLocaleKey, 1,
		        0, 
		        NULL, NULL, NULL,
		        0, 0, '', 0, @SynonymMigrationMngmtID output, @segmentID 
		
END