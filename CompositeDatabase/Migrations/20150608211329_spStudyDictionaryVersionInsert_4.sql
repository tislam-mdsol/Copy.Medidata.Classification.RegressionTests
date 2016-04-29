
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryVersionInsert')
	DROP PROCEDURE dbo.spStudyDictionaryVersionInsert
GO

CREATE PROCEDURE dbo.spStudyDictionaryVersionInsert (
	@StudyID BIGINT,
	@KeepCurrentVersion BIT,
	@CacheVersion BIGINT,
	@NumberOfMigrations INT,
	@SynonymManagementID INT,
	@RegistrationName NVARCHAR(100),
	@StudyDictionaryVersionID BIGINT output,
	@Created datetime output,  
	@Updated datetime output,
	@SegmentID INT
)
AS

BEGIN

	DECLARE @UtcDate DateTime  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  


	INSERT INTO dbo.StudyDictionaryVersion (
		StudyID,
		KeepCurrentVersion,
		CacheVersion,
		NumberOfMigrations,
		SegmentID,
		SynonymManagementID,
		RegistrationName,
		Created,  
		Updated
	) VALUES (
		@StudyID,
		@KeepCurrentVersion,
		@CacheVersion,
		@NumberOfMigrations,
		@SegmentID,
		@SynonymManagementID,
		@RegistrationName,
		@Created,
		@Updated
	)
	
	SET @StudyDictionaryVersionID = SCOPE_IDENTITY()
END
GO