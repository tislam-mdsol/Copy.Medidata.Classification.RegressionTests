IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spMedicalDictSegmentAssociationLoad')
	DROP PROCEDURE dbo.spMedicalDictSegmentAssociationLoad
GO

CREATE PROCEDURE dbo.spMedicalDictSegmentAssociationLoad 
(
	@ObjectSegmentID INT
)
AS
BEGIN

	DECLARE                                                                        
		@DefaultSuggestThresholdValue NVARCHAR(4000),
		@DefaultSelectThresholdValue NVARCHAR(4000),
		@IsAutoAddSynonymValue NVARCHAR(4000),
		@MaxNumberofSearchResultsValue NVARCHAR(4000),
		@IsAutoApprovalValue NVARCHAR(4000),
		@ActiveValue NVARCHAR(4000)

	DECLARE 	
		@DefaultSuggestThresholdTag VARCHAR(50) = 'DefaultSuggestThreshold',
		@DefaultSelectThresholdTag VARCHAR(50) = 'DefaultSelectThreshold',
		@IsAutoAddSynonymTag VARCHAR(50) = 'IsAutoAddSynonym',
		@MaxNumberofSearchResultsTag VARCHAR(50) = 'MaxNumberofSearchResults',
		@IsAutoApprovalTag VARCHAR(50) = 'IsAutoApproval',
		@ActiveTag VARCHAR(50) = 'Active'

                                                                    
	SELECT 
		@DefaultSuggestThresholdValue = MAX(CASE WHEN Tag = @DefaultSuggestThresholdTag THEN VALUE ELSE '' END),
		@DefaultSelectThresholdValue = MAX(CASE WHEN Tag = @DefaultSelectThresholdTag THEN VALUE ELSE '' END),
		@IsAutoAddSynonymValue = MAX(CASE WHEN Tag = @IsAutoAddSynonymTag THEN VALUE ELSE '' END),
		@MaxNumberofSearchResultsValue = MAX(CASE WHEN Tag = @MaxNumberofSearchResultsTag THEN VALUE ELSE '' END),
		@IsAutoApprovalValue = MAX(CASE WHEN Tag = @IsAutoApprovalTag THEN VALUE ELSE '' END),
		@ActiveValue = MAX(CASE WHEN Tag = @ActiveTag THEN VALUE ELSE '' END)
	FROM ObjectSegmentAttributes 
	WHERE ObjectSegmentID = @ObjectSegmentID 
		AND Tag IN (@DefaultSuggestThresholdTag, @DefaultSelectThresholdTag, @IsAutoAddSynonymTag,
			@MaxNumberofSearchResultsTag, @IsAutoApprovalTag, @ActiveTag )


	SELECT 
		@DefaultSuggestThresholdValue AS DefaultSuggestThreshold,
		@DefaultSelectThresholdValue AS DefaultSelectThreshold,
		@IsAutoAddSynonymValue AS IsAutoAddSynonym,
		@MaxNumberofSearchResultsValue AS MaxNumberofSearchResults,
		@IsAutoApprovalValue AS IsAutoApproval,
		@ActiveValue AS Active,
		@ObjectSegmentID AS ObjectSegmentId


END
GO 