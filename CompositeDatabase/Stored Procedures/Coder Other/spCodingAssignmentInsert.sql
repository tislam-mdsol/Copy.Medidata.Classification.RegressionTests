IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingAssignmentInsert')
	DROP PROCEDURE dbo.spCodingAssignmentInsert
GO
  
CREATE PROCEDURE dbo.spCodingAssignmentInsert (  
	@CodingAssignmentID bigint output,  
	@CodingElementID bigint,  
	@UserID int,  
	@CodingSourceAlgorithmID int,  
	@IsSuggested bit,
	@IsAutoCoded bit,
	@Active bit,
	@SourceSynonymTermID int,
	@Created datetime output,  
	@Updated datetime output,
	@SegmentedGroupCodingPatternID BIGINT,
	@SegmentId int
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DateTime  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	SET @SegmentedGroupCodingPatternID = ISNULL(@SegmentedGroupCodingPatternID, -1)

	INSERT INTO dbo.CodingAssignment (  
	  CodingElementID,  
	  SegmentId,
	  UserID,  
	  CodingSourceAlgorithmID,  
	  IsSuggested,
	  IsAutoCoded,
	  Active,
	  SourceSynonymTermID,
	  SegmentedGroupCodingPatternID,
	  Created,  
	  Updated  
	 ) 
	 VALUES (  
	  @CodingElementID,  
	  @SegmentId, 
	  @UserID,  
	  @CodingSourceAlgorithmID,  
	  @IsSuggested,
	  @IsAutoCoded,
	  1,
	  @SourceSynonymTermID,
	  @SegmentedGroupCodingPatternID,
	  @UtcDate,  
	  @UtcDate  
	 )  
	 SET @CodingAssignmentID = SCOPE_IDENTITY()  
	 
END  
  
GO

