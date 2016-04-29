IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationManagementInsert')
	DROP PROCEDURE spSynonymMigrationManagementInsert
GO

CREATE PROCEDURE spSynonymMigrationManagementInsert (
	
	@dictionaryVersionId INT,
	@FromSynonymListID INT,
	@listName NVARCHAR(100),
	
	@Created datetime output,
	@Updated datetime output,
	@Locale char(3),
	--@IsVersionInvolvedInMigration BIT,
	@SynonymMigrationStatusRID int,
	@IsSynonymListLoadedFromFile BIT,
	
	@MigrationOrLoadStartDate datetime,
	@MigrationOrLoadEndDate datetime,
	@ActivationDate datetime,
	@MigrationUserId int,
	@ActivationUserId int,
	@MigratingToIds VARCHAR(MAX),
	@CacheVersion BIGINT,
	
	@SynonymMigrationMngmtID int output,
	@SegmentId int
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate

	INSERT INTO dbo.SynonymMigrationMngmt (
		DictionaryVersionId,
		FromSynonymListID,
		ListName,
			
		SegmentId ,
		Created ,
		Updated,
		Locale,
		SynonymMigrationStatusRID,
		IsSynonymListLoadedFromFile,
		MigrationOrLoadStartDate,
		MigrationOrLoadEndDate,
		ActivationDate,
		MigrationUserId,
		ActivationUserId,
		MigratingToIds,
		CacheVersion
	) VALUES (
		@dictionaryVersionId,
		@FromSynonymListID,
		@listName,
	
		@SegmentId ,
		@Created  ,
		@Updated  ,
		@Locale ,
		@SynonymMigrationStatusRID,
		@IsSynonymListLoadedFromFile,
		@MigrationOrLoadStartDate,
		@MigrationOrLoadEndDate,
		@ActivationDate,
		@MigrationUserId,
		@ActivationUserId,
		ISNULL(@MigratingToIds, ''),
		@CacheVersion
	)
	SET @SynonymMigrationMngmtID = SCOPE_IDENTITY()
END

GO