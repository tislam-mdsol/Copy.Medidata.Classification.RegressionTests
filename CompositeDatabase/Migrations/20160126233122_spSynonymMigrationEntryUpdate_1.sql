IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSynonymMigrationEntryUpdate')
	DROP PROCEDURE dbo.spSynonymMigrationEntryUpdate
GO
  
CREATE PROCEDURE dbo.spSynonymMigrationEntryUpdate (  
	@SynonymMigrationEntryID bigint,
	@AreSuggestionsGenerated BIT,
	@SuggestionCategoryType INT,
	@SelectedSuggestionId BIGINT,	
	@SegmentedGroupCodingPatternID BIGINT,
	@PriorTermIdsAndText NVARCHAR(MAX),	
	
	@SynonymMigrationStatusRID int,
	@NumberOfSuggestions int,
	@UserID INT,	
	@ActivatedStatus INT,
	@SynonymMigrationMngmtID int ,
	@IsPrimaryPath bit,
	@Updated datetime output  
)  
AS  
  
BEGIN  
 DECLARE @UtcDate DateTime  
 SET @UtcDate = GetUtcDate()  
 SET @Updated = @UtcDate  
  
 UPDATE dbo.SynonymMigrationEntries SET  
		AreSuggestionsGenerated = @AreSuggestionsGenerated,
		SuggestionCategoryType = @SuggestionCategoryType,
		SelectedSuggestionId = @SelectedSuggestionId,
		
		SegmentedGroupCodingPatternID = @SegmentedGroupCodingPatternID,
		PriorTermIdsAndText = @PriorTermIdsAndText,
			
		SynonymMigrationStatusRID = @SynonymMigrationStatusRID,
		Updated = @Updated,
		SynonymMigrationMngmtID = @SynonymMigrationMngmtID,
		NumberOfSuggestions = @NumberOfSuggestions,
		UserID = @UserID,
		IsPrimaryPath = @IsPrimaryPath,
		ActivatedStatus = @ActivatedStatus
 WHERE @SynonymMigrationEntryID = SynonymMigrationEntryID  
END  
  
GO 