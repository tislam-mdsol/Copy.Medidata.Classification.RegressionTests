IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryLicenceInformationUpdate')
	DROP PROCEDURE spDictionaryLicenceInformationUpdate
GO

CREATE PROCEDURE dbo.spDictionaryLicenceInformationUpdate
(
	@DictionaryLicenceInformationID INT,
	@Deleted BIT,
	@UserID INT,
	@StartLicenceDate DATETIME,
	@EndLicenceDate DATETIME,
	@MedicalDictionaryKey NVARCHAR(100),
	@DictionaryLocale CHAR(3),
	@SegmentID INT,
	@Updated DATETIME OUTPUT
)
AS
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Updated = @UtcDate  

	-- special historical record - do not update data fields
	UPDATE DictionaryLicenceInformations
	SET
		Deleted = @Deleted,
		Updated = @Updated
	WHERE DictionaryLicenceInformationID = @DictionaryLicenceInformationID


GO    