IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSynonymMigrationManagementUpdate')
	DROP PROCEDURE dbo.spSynonymMigrationManagementUpdate
GO
  
CREATE PROCEDURE dbo.spSynonymMigrationManagementUpdate (  
	@SynonymMigrationMngmtID bigint,  
	
	 -- state control
	 @CacheVersion BIGINT,
	 @NewCacheVersion BIGINT,
	 @WasUpdated BIT OUTPUT,
	
	@dictionaryVersionId INT,
	@FromSynonymListID INT,
	
	@listName NVARCHAR(100),
	
	@Created datetime,
	@Locale char(3),
	@SynonymMigrationStatusRID int,
	--@IsVersionInvolvedInMigration BIT,
	@IsSynonymListLoadedFromFile BIT,

	@MigrationOrLoadStartDate datetime,
	@MigrationOrLoadEndDate datetime,
	@ActivationDate datetime,
	@MigrationUserId int,
	@ActivationUserId int,
	@MigratingToIds VARCHAR(MAX),
	
	@Updated datetime output,
	@SegmentId int
)  
AS  
  
BEGIN  
 DECLARE @UtcDate DateTime  
 SET @UtcDate = GetUtcDate()  
 SET @Updated = @UtcDate  
  
 UPDATE dbo.SynonymMigrationMngmt SET 
	CacheVersion = @NewCacheVersion,
	
		SegmentId = @SegmentId,
		Created = @Created,
		Updated = @Updated,
		Locale = @Locale,
		SynonymMigrationStatusRID = @SynonymMigrationStatusRID,
		IsSynonymListLoadedFromFile = @IsSynonymListLoadedFromFile,
		MigrationOrLoadStartDate = @MigrationOrLoadStartDate,
		MigrationOrLoadEndDate = @MigrationOrLoadEndDate,
		ActivationDate = @ActivationDate,
		MigrationUserId = @MigrationUserId,
		ActivationUserId = @ActivationUserId,
		
		DictionaryVersionId = @dictionaryVersionId,
		FromSynonymListID = @FromSynonymListID,
		ListName = @listName,
		MigratingToIds = ISNULL(@MigratingToIds, '')
 WHERE @SynonymMigrationMngmtID = SynonymMigrationMngmtID 
	AND CacheVersion = @CacheVersion
		
	 -- check if we updated
	 IF (@@ROWCOUNT = 0)
		SET @WasUpdated = 0
	 ELSE
		SET @WasUpdated = 1  
END  
  
GO