IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryLicenceInformationLoadBySgmtDctLcl')
	DROP PROCEDURE spDictionaryLicenceInformationLoadBySgmtDctLcl
GO
CREATE PROCEDURE dbo.spDictionaryLicenceInformationLoadBySgmtDctLcl
(
	@segmentID INT, 
	@medicalDictionaryKey NVARCHAR(100), 
	@locale CHAR(3)
)
AS
	
	SELECT *
	FROM DictionaryLicenceInformations
	WHERE
		Deleted = 0
		AND SegmentID = @segmentID
		AND MedicalDictionaryKey = @medicalDictionaryKey
		AND DictionaryLocale = @locale
GO   