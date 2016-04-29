
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionUpdate')
	DROP PROCEDURE spDictionaryVersionSubscriptionUpdate
GO

CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionUpdate
(
	@DictionaryVersionSubscriptionID INT,
	@Deleted BIT,
	@UserID INT,

	@DictionaryVersionId INT,
	@SegmentId INT,
	@DictionaryLicenceInformationId INT,
	@DictionaryLocale CHAR(3),

	@Created DATETIME,
	@Updated DATETIME OUTPUT
)
AS
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Updated = @UtcDate  

  
	-- special historical record - do not update data fields
	UPDATE DictionaryVersionSubscriptions
	SET
		UserID = @UserID,
		Deleted = @Deleted,
		DictionaryLicenceInformationId = @DictionaryLicenceInformationId,
		Updated = @Updated
	WHERE DictionaryVersionSubscriptionID = @DictionaryVersionSubscriptionID


GO   