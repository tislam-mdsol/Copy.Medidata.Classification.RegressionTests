IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationManagementInsert')
	DROP PROCEDURE spSynonymMigrationManagementInsert
GO

CREATE PROCEDURE spSynonymMigrationManagementInsert (
	
	@FromSynonymListID INT,
	@listName NVARCHAR(100),
	
	@Created datetime output,
	@Updated datetime output,
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100),
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
		MedicalDictionaryVersionLocaleKey,
		FromSynonymListID,
		ListName,
			
		SegmentId ,
		Created ,
		Updated,
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
		@MedicalDictionaryVersionLocaleKey,
		@FromSynonymListID,
		@listName,
	
		@SegmentId ,
		@Created  ,
		@Updated  ,
		@SynonymMigrationStatusRID,
		@IsSynonymListLoadedFromFile,
		@MigrationOrLoadStartDate,
		@MigrationOrLoadEndDate,
		@ActivationDate,
		@MigrationUserId,
		@ActivationUserId,
		ISNULL(@MigratingToIds, ''),
		@CacheVersion)

	SET @SynonymMigrationMngmtID = SCOPE_IDENTITY()
END

GO