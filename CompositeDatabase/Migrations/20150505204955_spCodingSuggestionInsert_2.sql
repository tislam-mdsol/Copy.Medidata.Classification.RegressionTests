

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSuggestionInsert')
	DROP PROCEDURE dbo.spCodingSuggestionInsert
GO
  
CREATE PROCEDURE dbo.spCodingSuggestionInsert (
 @CodingSuggestionID int output,
 @CodingElementID bigint,
 @MigrationTraceID INT,
 @MedicalDictionaryTermID varchar(255),
 @MatchPercent float,
 @IsSelected bit,
 @SuggestionReason varchar(50),
 @Created datetime output,
 @Updated datetime output,
 @SegmentId int
)
AS  
  
BEGIN
 DECLARE @UtcDate DateTime
 SET @UtcDate = GetUtcDate()
 SELECT @Created = @UtcDate, @Updated = @UtcDate
 
 INSERT INTO dbo.CodingSuggestions (
  CodingElementID,
  MigrationTraceID,
  MedicalDictionaryTermID,
  SegmentId,
  MatchPercent,
  IsSelected,
  SuggestionReason,
  Created,
  Updated 
 ) VALUES (
  @CodingElementID,
  @MigrationTraceID,
  @MedicalDictionaryTermID,
  @SegmentId,
  @MatchPercent,
  @IsSelected, 
  @SuggestionReason,
  @UtcDate,
  @UtcDate 
 )
 SET @CodingSuggestionID = SCOPE_IDENTITY()
END
 
GO
