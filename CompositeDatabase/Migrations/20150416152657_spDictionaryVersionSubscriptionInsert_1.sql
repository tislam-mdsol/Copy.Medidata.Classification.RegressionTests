IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionInsert')
	DROP PROCEDURE spDictionaryVersionSubscriptionInsert
GO
create procedure dbo.spDictionaryVersionSubscriptionInsert
(
	@Deleted BIT,
	@UserID INT,

	@DictionaryVersionId INT,
	@SegmentId INT,
	@DictionaryLicenceInformationId INT,
	@DictionaryLocale CHAR(3),

	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@DictionaryVersionSubscriptionID INT OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO DictionaryVersionSubscriptions (  
		Deleted,
		UserID,

		DictionaryVersionId,
		SegmentId,
		DictionaryLicenceInformationId,
		DictionaryLocale,

		Created,
		Updated
	) VALUES (  
		@Deleted,
		@UserID,

		@DictionaryVersionId,
		@SegmentId,
		@DictionaryLicenceInformationId,
		@DictionaryLocale,

		@Created,
		@Updated
	)  
	
	SET @DictionaryVersionSubscriptionID = SCOPE_IDENTITY()  	
	
END
GO    