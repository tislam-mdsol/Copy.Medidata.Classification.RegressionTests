
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationInsert')
	DROP PROCEDURE dbo.spDictionarySegmentConfigurationInsert
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationInsert
(
    @SegmentId INT,
	@DictionaryId INT,
    @UserId INT,

	@DefaultSuggestThreshold INT,
	@DefaultSelectThreshold INT,
	@MaxNumberofSearchResults INT,

	@IsAutoAddSynonym BIT,
	@Active BIT,
	@IsAutoApproval BIT,

	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@DictionarySegmentConfigurationId INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DATETIME  
	SET @UtcDate = GETUTCDATE()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO DictionarySegmentConfigurations (  
		SegmentId,
		DictionaryId,
		UserId,

		DefaultSuggestThreshold,
		DefaultSelectThreshold,
		MaxNumberofSearchResults,

		IsAutoAddSynonym,
		Active,
		IsAutoApproval,

		Created,
		Updated
	) VALUES (  
		@SegmentId,
		@DictionaryId,
		@UserId,

		@DefaultSuggestThreshold,
		@DefaultSelectThreshold,
		@MaxNumberofSearchResults,

		@IsAutoAddSynonym,
		@Active,
		@IsAutoApproval,

		@Created,
		@Updated
	)  
	
	SET @DictionarySegmentConfigurationId = SCOPE_IDENTITY()  	
	
END
GO
