-- keep only deleted as indication of history
IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryLicenceInformations'
		 AND COLUMN_NAME = 'IsHistoricalEntry')
BEGIN
	UPDATE DictionaryLicenceInformations
	SET Deleted = 1
	WHERE IsHistoricalEntry = 1	

	ALTER TABLE DictionaryLicenceInformations
	DROP COLUMN IsHistoricalEntry
END
GO

-- keep only last non-deleted entry as indication of active licence
;WITH NPlicateLicences
AS
(
	SELECT DLI.DictionaryLicenceInformationID, 
		Segmentid, MedicalDictionaryID, DictionaryLocale, StartLicenceDate, EndLicenceDate,
		ROW_NUMBER() OVER 
			(PARTITION BY Segmentid, MedicalDictionaryID, DictionaryLocale, StartLicenceDate, EndLicenceDate 
				ORDER BY DictionaryLicenceInformationID DESC) AS rownum
	FROM DictionaryLicenceInformations DLI
	WHERE Deleted = 0
)

UPDATE DLI
SET DLI.Deleted = 1
FROM DictionaryLicenceInformations DLI
	JOIN NPlicateLicences NL
		ON DLI.DictionaryLicenceInformationID = NL.DictionaryLicenceInformationID
WHERE NL.rownum > 1

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryLicenceInformations'
		 AND COLUMN_NAME = 'Active')
	ALTER TABLE DictionaryLicenceInformations
	DROP COLUMN Active
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryLicenceInformations'
		 AND COLUMN_NAME = 'LicenceSubscriptionAction')
	ALTER TABLE DictionaryLicenceInformations
	DROP COLUMN LicenceSubscriptionAction
GO
