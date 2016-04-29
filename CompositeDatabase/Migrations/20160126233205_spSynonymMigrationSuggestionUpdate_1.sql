IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSynonymMigrationSuggestionUpdate')
	DROP PROCEDURE dbo.spSynonymMigrationSuggestionUpdate
GO
  
CREATE PROCEDURE dbo.spSynonymMigrationSuggestionUpdate (  
	@SynonymMigrationSuggestionID int,
	--@TermId int,
    @NextTermIdsAndText NVARCHAR(MAX),
	@SuggestedNodePath VARCHAR(MAX),
	
	@SynonymSuggestionReasonRID int,
	@SynonymMigrationEntryID int,
	@IsPrimaryPath BIT,
	@Updated datetime output  
)  
AS  
  
BEGIN  
 DECLARE @UtcDate DateTime  
 SET @UtcDate = GetUtcDate()  
 SET @Updated = @UtcDate  
  
 UPDATE dbo.SynonymMigrationSuggestions SET  
		--TermId = @TermId,
		NextTermIdsAndText = @NextTermIdsAndText,
		SuggestedNodePath = @SuggestedNodePath,
		
		SynonymSuggestionReasonRID = @SynonymSuggestionReasonRID,
		IsPrimaryPath = @IsPrimaryPath,
		Updated = @Updated,
		SynonymMigrationEntryID = @SynonymMigrationEntryID
 WHERE SynonymMigrationSuggestionID = @SynonymMigrationSuggestionID  
END  
  
GO  