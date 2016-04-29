
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spActivateSynonymListForDictionaryVersionLocaleSegment')
	DROP PROCEDURE spActivateSynonymListForDictionaryVersionLocaleSegment
GO

CREATE PROCEDURE dbo.spActivateSynonymListForDictionaryVersionLocaleSegment  
(  
 @MedicalDictionaryVersionLocaleKey NVARCHAR(100),
 @Segment  NVARCHAR(100),
 @SynonymListName NVARCHAR(100)
)  
AS  
 --production check
 IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
BEGIN
	PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	RETURN
END


 DECLARE @segmentID INT
   
 SELECT @segmentID = SegmentId  
 FROM Segments  
 WHERE OID = @Segment  
   
 IF @segmentID IS NULL  
 BEGIN  
  PRINT N'Cannot find Segment OID'  
  RETURN 1  
 END  

   
 DECLARE @synMgID INT  
   
 -- find the synMgID  
 SELECT @synMgID = SynonymMigrationMngmtID  
 FROM SynonymMigrationMngmt  
 WHERE SegmentId                          = @segmentID
	And MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey 
	AND FromSynonymListID                 = -1  
	AND SynonymMigrationStatusRID         = 1  
	AND ListName                          = @SynonymListName
   
 IF @synMgID IS NULL  
 BEGIN  
  PRINT N'Cannot find Synonym Management or its already activated'  
  RETURN 1  
 END   
   
 UPDATE SynonymMigrationMngmt  
 SET FromSynonymListID            = -1,  
	  SynonymMigrationStatusRID   = 6,
	  IsSynonymListLoadedFromFile = 0
 WHERE @synMgID                   = SynonymMigrationMngmtID  