IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryLicenceInformationLoadByDctLclRlsDt')
	DROP PROCEDURE spDictionaryLicenceInformationLoadByDctLclRlsDt
GO
CREATE PROCEDURE dbo.spDictionaryLicenceInformationLoadByDctLclRlsDt
(
	@medicalDictionaryKey NVARCHAR(100), 
	@locale CHAR(3),
	@releaseDate DATETIME
)
AS
	
	SELECT *
	FROM DictionaryLicenceInformations
	WHERE @releaseDate BETWEEN StartLicenceDate AND EndLicenceDate
		AND MedicalDictionaryKey = @medicalDictionaryKey
		AND DictionaryLocale = @locale
		AND Deleted = 0

GO    