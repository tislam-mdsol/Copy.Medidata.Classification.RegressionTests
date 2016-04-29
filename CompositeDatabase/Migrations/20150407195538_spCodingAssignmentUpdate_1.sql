
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingAssignmentUpdate')
	DROP PROCEDURE dbo.spCodingAssignmentUpdate
GO
  
CREATE PROCEDURE dbo.spCodingAssignmentUpdate (  
 @CodingAssignmentID bigint,  
 @CodingElementID bigint,  
 @UserID int,  
 @CodingSourceAlgorithmID int,  
 @IsSuggested bit,
 @IsAutoCoded bit,
 @Active bit,
 @SourceSynonymTermID int,
 @SegmentedGroupCodingPatternID BIGINT,
 @Created datetime,  
 @Updated datetime output,
 @SegmentId int
)  
AS  
  
BEGIN  
 DECLARE @UtcDate DateTime  
 SET @UtcDate = GetUtcDate()  
 SET @Updated = @UtcDate  
 
 SET @SegmentedGroupCodingPatternID = ISNULL(@SegmentedGroupCodingPatternID, -1)

  
 UPDATE dbo.CodingAssignment SET  
  CodingElementID = @CodingElementID,  
  SegmentId=@SegmentId,
  UserID = @UserID,  
  CodingSourceAlgorithmID = @CodingSourceAlgorithmID,  
  IsSuggested = @IsSuggested,
  IsAutoCoded = @IsAutoCoded,
  Active = @Active,
  SourceSynonymTermID = @SourceSynonymTermID,
  Created = Created,  
  Updated = @UtcDate  
 WHERE CodingAssignmentID = @CodingAssignmentID  
END  
  
GO
 