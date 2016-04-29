IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationTraceInsert')
	DROP PROCEDURE spStudyMigrationTraceInsert
GO
CREATE PROCEDURE dbo.spStudyMigrationTraceInsert
(
    @UserId INT,
    @SegmentId INT,
    @StudyId INT,
    @FromSynonymMgmtId INT,
    @ToSynonymMgmtId INT,
    @StudyDictionaryVersionId INT,
    @CurrentStage INT,
	@CacheVersion BIGINT,

	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@StudyMigrationTraceId INT OUTPUT
)
AS
BEGIN

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO StudyMigrationTraces (  
		UserId,
		SegmentId,
		StudyId,
		FromSynonymMgmtId,
		ToSynonymMgmtId,
		StudyDictionaryVersionId,
		CurrentStage,
		CacheVersion,

		Created,
		Updated
	) VALUES (
		@UserId,
		@SegmentId,
		@StudyId,
		@FromSynonymMgmtId,
		@ToSynonymMgmtId,
		@StudyDictionaryVersionId,
		@CurrentStage,
		@CacheVersion,

		@Created,
		@Updated
	)  
	
	SET @StudyMigrationTraceId = SCOPE_IDENTITY()  	

END
GO  
   