
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationUpdate')
	DROP PROCEDURE dbo.spDictionarySegmentConfigurationUpdate
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationUpdate
(
	@DictionarySegmentConfigurationId INT,
    @SegmentId INT,
	@MedicalDictionaryKey NVARCHAR(100),
    @UserId INT,

	@MaxNumberofSearchResults INT,

	@IsAutoAddSynonym BIT,
	@Active BIT,
	@IsAutoApproval BIT,

	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)
AS
BEGIN

	SELECT @Updated = GETUTCDATE()  

	UPDATE DictionarySegmentConfigurations
	SET
		--SegmentId = @SegmentId,
		--DictionaryId = @DictionaryId,
		UserId = @UserId,

		MaxNumberofSearchResults = @MaxNumberofSearchResults,

		IsAutoAddSynonym = @IsAutoAddSynonym,
		Active = @Active,
		IsAutoApproval = @IsAutoApproval,
	
		Updated = @Updated
	 WHERE DictionarySegmentConfigurationId = @DictionarySegmentConfigurationId
	
END
GO
 