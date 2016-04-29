IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spStudyDictionaryVersionHistoryUpdate')
	DROP PROCEDURE dbo.spStudyDictionaryVersionHistoryUpdate 
GO
  
CREATE PROCEDURE dbo.spStudyDictionaryVersionHistoryUpdate  
(  
	@StudyDictionaryVersionHistoryID BIGINT,
	@StudyDictionaryVersionId INT,
	@FromSynonymListId INT,
	@ToSynonymListId INT,
	@UserID INT,
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
	@Created datetime,  
	@Updated datetime output,
	@SegmentID INT
)  
AS  
  
BEGIN  
 DECLARE @UtcDate DateTime  
 SET @UtcDate = GetUtcDate()  
 SET @Updated = @UtcDate  
 
 UPDATE dbo.StudyDictionaryVersionHistory SET  
		StudyDictionaryVersionID= @StudyDictionaryVersionID,
		FromSynonymListId       = @FromSynonymListId,
		ToSynonymListId         = @ToSynonymListId,
		SegmentID               = @SegmentID,
		UserID                  = @UserID,
		Updated                 = @Updated,
		ImpactAnalysis0         = @ImpactAnalysis0,
		ImpactAnalysis1         = @ImpactAnalysis1,
		ImpactAnalysis2         = @ImpactAnalysis2,
		ImpactAnalysis3         = @ImpactAnalysis3,
		ImpactAnalysis4         = @ImpactAnalysis4,
		ImpactAnalysis5         = @ImpactAnalysis5,
		ImpactAnalysis6         = @ImpactAnalysis6,
		ImpactAnalysis7         = @ImpactAnalysis7,
		FutureVersionAutomation = @FutureVersionAutomation,
		BetterDictionaryMatch   = @BetterDictionaryMatch,
		MigrationStarted        = @MigrationStarted,
		MigrationEnded          = @MigrationEnded
 WHERE StudyDictionaryVersionHistoryID = @StudyDictionaryVersionHistoryID
END  
  
GO
