
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySegmentConfigurationUpdate')
	DROP PROCEDURE dbo.spDictionarySegmentConfigurationUpdate
GO

CREATE PROCEDURE dbo.spDictionarySegmentConfigurationUpdate
(
	@DictionarySegmentConfigurationId INT,
    @UserId INT,
	@IsAutoAddSynonym BIT,
	@IsAutoApproval BIT,
	@Updated DATETIME OUTPUT
)
AS
BEGIN

	SELECT @Updated = GETUTCDATE()  

	UPDATE DictionarySegmentConfigurations
	SET
		UserId                   = @UserId,
		IsAutoAddSynonym         = @IsAutoAddSynonym,
		IsAutoApproval           = @IsAutoApproval,
		Updated                  = @Updated
	 WHERE DictionarySegmentConfigurationId = @DictionarySegmentConfigurationId
	
END
GO
 