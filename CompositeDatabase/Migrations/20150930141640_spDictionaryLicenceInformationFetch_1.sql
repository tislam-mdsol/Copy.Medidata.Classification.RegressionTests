IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryLicenceInformationFetch')
	DROP PROCEDURE spDictionaryLicenceInformationFetch
GO
CREATE PROCEDURE dbo.spDictionaryLicenceInformationFetch
(
	@DictionaryLicenceInformationId int
)
AS
	
	SELECT *
	FROM DictionaryLicenceInformations
	WHERE
		Deleted = 0
		AND DictionaryLicenceInformationId = @DictionaryLicenceInformationId
	
GO 