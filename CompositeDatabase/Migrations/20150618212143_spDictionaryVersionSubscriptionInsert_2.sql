IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionInsert')
	DROP PROCEDURE spDictionaryVersionSubscriptionInsert
GO
create procedure dbo.spDictionaryVersionSubscriptionInsert
(
	@Deleted BIT,
	@UserID INT,

	@SegmentId INT,
	@DictionaryLicenceInformationId INT,
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100),

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

		SegmentId,
		DictionaryLicenceInformationId,
		MedicalDictionaryVersionLocaleKey,

		Created,
		Updated,

		-- TODO : remove
		DictionaryLocale_Backup,
		DictionaryVersionId_Backup
	) VALUES (  
		@Deleted,
		@UserID,

		@SegmentId,
		@DictionaryLicenceInformationId,
		@MedicalDictionaryVersionLocaleKey,

		@Created,
		@Updated,

		'',
		0
	)  
	
	SET @DictionaryVersionSubscriptionID = SCOPE_IDENTITY()  	
	
END
GO    