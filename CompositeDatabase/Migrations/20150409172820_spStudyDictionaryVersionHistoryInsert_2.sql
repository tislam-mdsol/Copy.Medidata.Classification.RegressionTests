IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryVersionHistoryInsert')
	DROP PROCEDURE dbo.spStudyDictionaryVersionHistoryInsert
GO

CREATE PROCEDURE dbo.spStudyDictionaryVersionHistoryInsert (
	@StudyDictionaryVersionId INT,
	@FromDictionaryVersionId INT,
	@ToDictionaryVersionId INT,
	@UserID INT,
	@StudyDictionaryVersionHistoryID BIGINT output,
	@Created datetime output,  
	@Updated datetime output,
	@ImpactAnalysis0 INT,
	@ImpactAnalysis1 INT,
	@ImpactAnalysis2 INT,
	@ImpactAnalysis3 INT,
	@ImpactAnalysis4 INT,
	@ImpactAnalysis5 INT,
	@ImpactAnalysis6 INT,
	@ImpactAnalysis7 INT,
	@FutureVersionAutomation INT,
	@BetterDictionaryMatch INT,
	@MigrationStarted DATETIME,
	@MigrationEnded DATETIME,
	@SegmentID INT
)
AS

BEGIN

	DECLARE @UtcDate DateTime  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  


	INSERT INTO dbo.StudyDictionaryVersionHistory (
		StudyDictionaryVersionId,
		FromDictionaryVersionId,
		ToDictionaryVersionId,
		SegmentID,
		UserID,
		Created,  
		Updated,
		ImpactAnalysis0,
		ImpactAnalysis1,
		ImpactAnalysis2,
		ImpactAnalysis3,
		ImpactAnalysis4,
		ImpactAnalysis5,
		ImpactAnalysis6,
		ImpactAnalysis7,
		FutureVersionAutomation,
		BetterDictionaryMatch,
		MigrationStarted,
		MigrationEnded
	) VALUES (
		@StudyDictionaryVersionId,
		@FromDictionaryVersionId,
		@ToDictionaryVersionId,
		@SegmentID,
		@UserID,
		@Created,
		@Updated,
		@ImpactAnalysis0,
		@ImpactAnalysis1,
		@ImpactAnalysis2,
		@ImpactAnalysis3,
		@ImpactAnalysis4,
		@ImpactAnalysis5,
		@ImpactAnalysis6,
		@ImpactAnalysis7,
		@FutureVersionAutomation,
		@BetterDictionaryMatch,
		@MigrationStarted,
		@MigrationEnded
	)
	
	SET @StudyDictionaryVersionHistoryID = SCOPE_IDENTITY()
END
GO
