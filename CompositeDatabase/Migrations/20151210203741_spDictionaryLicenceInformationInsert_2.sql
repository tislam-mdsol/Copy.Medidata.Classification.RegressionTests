IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryLicenceInformationInsert')
	DROP PROCEDURE spDictionaryLicenceInformationInsert
GO
create procedure dbo.spDictionaryLicenceInformationInsert
(
	@Deleted BIT,
	@UserID INT,
	@StartLicenceDate DATETIME,
	@EndLicenceDate DATETIME,
	@LicenceCode NVARCHAR(300),
	@DictionaryLocale CHAR(3),
	@SegmentID INT,
	@MedicalDictionaryKey NVARCHAR(100),
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@DictionaryLicenceInformationID INT OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO DictionaryLicenceInformations (  
		Deleted,
		UserID,
		StartLicenceDate,
		EndLicenceDate,
		LicenceCode,
		DictionaryLocale,
		SegmentID,
		MedicalDictionaryKey,
		Created,
		Updated
	) VALUES (  
		@Deleted,
		@UserID,
		@StartLicenceDate,
		@EndLicenceDate,
		@LicenceCode,
		@DictionaryLocale,
		@SegmentID,
		@MedicalDictionaryKey,
		@Created,
		@Updated
	)  
	
	SET @DictionaryLicenceInformationID = SCOPE_IDENTITY()  	
	
END
GO     