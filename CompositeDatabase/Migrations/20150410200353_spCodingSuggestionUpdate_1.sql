
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSuggestionUpdate')
	DROP PROCEDURE dbo.spCodingSuggestionUpdate
GO
  
CREATE PROCEDURE dbo.spCodingSuggestionUpdate (
 @CodingSuggestionID int,
 @CodingElementID bigint,
 @MedicalDictionaryTermID varchar(255),
 @MatchPercent float,
 @IsSelected bit,
 @SuggestionReason varchar(50),
 @Created datetime,
 @Updated datetime output,
 @SegmentId int
)
AS

BEGIN
 DECLARE @UtcDate DateTime
 SET @UtcDate = GetUtcDate()
 SET @Updated = @UtcDate

 UPDATE dbo.CodingSuggestions SET
  CodingElementID = @CodingElementID,
  MedicalDictionaryTermID = @MedicalDictionaryTermID,
  SegmentId = @SegmentId,
  MatchPercent = @MatchPercent,
  IsSelected = @IsSelected,
  SuggestionReason = @SuggestionReason,
  Created = @Created,
  Updated = @UtcDate
 WHERE CodingSuggestionID = @CodingSuggestionID
END
  
GO
