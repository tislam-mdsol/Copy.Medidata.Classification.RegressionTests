IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictSegmentAssociationUpdate')
	DROP PROCEDURE dbo.spMedicalDictSegmentAssociationUpdate
GO

CREATE PROCEDURE dbo.spMedicalDictSegmentAssociationUpdate
(
	@DefaultSuggestThresholdValue NVARCHAR(4000),
	@DefaultSelectThresholdValue NVARCHAR(4000),
	@IsAutoAddSynonymValue NVARCHAR(4000),
	@MaxNumberofSearchResultsValue NVARCHAR(4000),
	@IsAutoApprovalValue NVARCHAR(4000),
	@ActiveValue NVARCHAR(4000),

	@ObjectSegmentId INT
)
AS
BEGIN

	DECLARE 	
		@DefaultSuggestThresholdTag VARCHAR(50) = 'DefaultSuggestThreshold',
		@DefaultSelectThresholdTag VARCHAR(50) = 'DefaultSelectThreshold',
		@IsAutoAddSynonymTag VARCHAR(50) = 'IsAutoAddSynonym',
		@MaxNumberofSearchResultsTag VARCHAR(50) = 'MaxNumberofSearchResults',
		@IsAutoApprovalTag VARCHAR(50) = 'IsAutoApproval',
		@ActiveTag VARCHAR(50) = 'Active'

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  

	UPDATE ObjectSegmentAttributes
	SET Value = CASE 
				WHEN Tag = @DefaultSuggestThresholdTag THEN @DefaultSuggestThresholdValue
				WHEN Tag = @DefaultSelectThresholdTag THEN @DefaultSelectThresholdValue
				WHEN Tag = @IsAutoAddSynonymTag THEN @IsAutoAddSynonymValue
				WHEN Tag = @MaxNumberofSearchResultsTag THEN @MaxNumberofSearchResultsValue
				WHEN Tag = @IsAutoApprovalTag THEN @IsAutoApprovalValue
				WHEN Tag = @ActiveTag THEN @ActiveValue
				ELSE ''
			END,
			Updated = @UtcDate
	WHERE ObjectSegmentId = @ObjectSegmentId
		AND Tag IN (@DefaultSuggestThresholdTag, @DefaultSelectThresholdTag, @IsAutoAddSynonymTag,
			@MaxNumberofSearchResultsTag, @IsAutoApprovalTag, @ActiveTag)
	
END
GO
 