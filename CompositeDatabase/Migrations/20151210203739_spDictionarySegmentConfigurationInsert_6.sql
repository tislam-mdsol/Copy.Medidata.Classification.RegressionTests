
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationInsert')
	DROP PROCEDURE dbo.spDictionarySegmentConfigurationInsert
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationInsert
(
    @SegmentId INT,
	@MedicalDictionaryKey NVARCHAR(100),
    @UserId INT,

	@MaxNumberofSearchResults INT = 50,  --Default value as placeholder for Table (as of 2015.3 release this field isn't used) - JMG

	@IsAutoAddSynonym BIT,
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

		MaxNumberofSearchResults,

		IsAutoAddSynonym,
		IsAutoApproval,

		Created,
		Updated
	) VALUES (  
		@SegmentId,
		@MedicalDictionaryKey,
		@UserId,
		@MaxNumberofSearchResults,
		@IsAutoAddSynonym,
		@IsAutoApproval,
		@Created,
		@Updated
	)  
	
	SET @DictionarySegmentConfigurationId = SCOPE_IDENTITY()  	
	
END
GO
