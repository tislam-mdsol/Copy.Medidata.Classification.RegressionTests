
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationInsert')
	DROP PROCEDURE dbo.spDictionarySegmentConfigurationInsert
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationInsert
(
    @SegmentId INT,
	@MedicalDictionaryKey NVARCHAR(100),
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
		MedicalDictionaryKey,
		UserId,

		DefaultSuggestThreshold,
		DefaultSelectThreshold,
		MaxNumberofSearchResults,

		IsAutoAddSynonym,
		Active,
		IsAutoApproval,

		Created,
		Updated,
		
		DictionaryId_BackUp --  Legacy, to remove
	) VALUES (  
		@SegmentId,
		@MedicalDictionaryKey,
		@UserId,

		@DefaultSuggestThreshold,
		@DefaultSelectThreshold,
		@MaxNumberofSearchResults,

		@IsAutoAddSynonym,
		@Active,
		@IsAutoApproval,

		@Created,
		@Updated,

		-1
	)  
	
	SET @DictionarySegmentConfigurationId = SCOPE_IDENTITY()  	
	
END
GO
