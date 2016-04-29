IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spStudyDictionaryVersionUpdate')
	DROP PROCEDURE dbo.spStudyDictionaryVersionUpdate 
GO
  
CREATE PROCEDURE dbo.spStudyDictionaryVersionUpdate  (  
	@StudyDictionaryVersionID BIGINT,
	
	-- state control
	@CacheVersion BIGINT,
	@NewCacheVersion BIGINT,
	@WasUpdated BIT OUTPUT,

	@StudyID BIGINT ,
	@KeepCurrentVersion BIT ,
	@NumberOfMigrations INT,
	@StudyLock TINYINT,
	@InitialDictionaryVersionId INT,
	@SynonymManagementID INT,
	
	@Created datetime,  
	@Updated datetime output,
	@SegmentID INT
)  
AS  
  
BEGIN  
 DECLARE @UtcDate DateTime  
 SET @UtcDate = GetUtcDate()  
 SET @Updated = @UtcDate  
 
 -- do not update the rest of the data
 UPDATE dbo.StudyDictionaryVersion SET  
		CacheVersion = @NewCacheVersion,
		KeepCurrentVersion = @KeepCurrentVersion,
		InitialDictionaryVersionId = @InitialDictionaryVersionId,
		NumberOfMigrations = @NumberOfMigrations,
		SynonymManagementID = @SynonymManagementID,
		StudyLock = @StudyLock,
		Updated = @Updated
 WHERE StudyDictionaryVersionID = @StudyDictionaryVersionID
	AND CacheVersion = @CacheVersion

	-- check if we updated
	IF (@@ROWCOUNT = 0)
		SET @WasUpdated = 0
	ELSE
		SET @WasUpdated = 1   
END  
  
GO
