IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationTraceUpdate')
	DROP PROCEDURE spStudyMigrationTraceUpdate
GO
CREATE PROCEDURE dbo.spStudyMigrationTraceUpdate
(
	@StudyMigrationTraceId INT,
	
	-- state control
	@CacheVersion BIGINT,
	@NewCacheVersion BIGINT,
	@WasUpdated BIT OUTPUT,

    @UserId INT,
    @SegmentId INT,
    @StudyId INT,
    @FromSynonymMgmtId INT,
    @ToSynonymMgmtId INT,
    @StudyDictionaryVersionId INT,
    @CurrentStage INT,

	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)
AS
BEGIN

	SET @Updated = GetUtcDate()  

	UPDATE StudyMigrationTraces 
	SET
		CacheVersion = @NewCacheVersion,

		UserId = @UserId,
		SegmentId = @SegmentId,
		StudyId = @StudyId,
		FromSynonymMgmtId = @FromSynonymMgmtId,
		ToSynonymMgmtId = @ToSynonymMgmtId,
		StudyDictionaryVersionId = @StudyDictionaryVersionId,
		CurrentStage = @CurrentStage,
		
		Updated = @Updated 
	 WHERE StudyMigrationTraceId = @StudyMigrationTraceId
		AND CacheVersion = @CacheVersion

	-- check if we updated
	IF (@@ROWCOUNT = 0)
		SET @WasUpdated = 0
	ELSE
		SET @WasUpdated = 1   

END
GO  
   