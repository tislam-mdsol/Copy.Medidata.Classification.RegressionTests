-- map references
UPDATE DVS
SET DVS.SegmentId = OS.SegmentId,
	DVS.DictionaryVersionId = DVLR.NewVersionId,
	DVS.DictionaryLocale = DVLR.Locale,
	DVS.DictionaryLicenceInformationId = DLI.DictionaryLicenceInformationId
FROM DictionaryVersionSubscriptions DVS
	JOIN ObjectSegments OS
		ON DVS.ObjectSegmentId = OS.ObjectSegmentId
	JOIN DictionaryVersionLocaleRef DVLR
		ON DVLR.DictionaryVersionLocaleRefID = DVS.HistoricalVersionLocaleStatusID
	JOIN DictionaryLicenceInformations DLI
		ON DLI.MedicalDictionaryID = DVLR.DictionaryRefID
		AND DLI.SegmentID = OS.SegmentId
		AND DLI.IsHistoricalEntry = 0
		AND DLI.DictionaryLocale = DVLR.Locale

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'Active')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP COLUMN Active
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'IsHistoricalEntry')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP COLUMN IsHistoricalEntry
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'VersionSubscriptionAction')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP COLUMN VersionSubscriptionAction
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_DictionaryVersionSubscriptions_HistoricalVersionLocaleStatusID')
	DROP INDEX DictionaryVersionSubscriptions.IX_DictionaryVersionSubscriptions_HistoricalVersionLocaleStatusID 
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'HistoricalVersionLocaleStatusID')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP COLUMN HistoricalVersionLocaleStatusID
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_DictionaryVersionSubscriptions_ObjectSegmentID')
	DROP INDEX DictionaryVersionSubscriptions.IX_DictionaryVersionSubscriptions_ObjectSegmentID 
GO

IF EXISTS (SELECT NULL FROM sys.foreign_keys
	WHERE name = 'FK_DictionaryVersionSubscriptions_ObjectSegmentId')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP CONSTRAINT FK_DictionaryVersionSubscriptions_ObjectSegmentId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'ObjectSegmentId')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP COLUMN ObjectSegmentId
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_DictionaryVersionSubscriptions_SubscriptionLogID')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP CONSTRAINT DF_DictionaryVersionSubscriptions_SubscriptionLogID
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 AND COLUMN_NAME = 'SubscriptionLogId')
	ALTER TABLE DictionaryVersionSubscriptions
	DROP COLUMN SubscriptionLogId
GO

-- mark duplicates as deleted
;WITH keepLast AS
(
	SELECT DictionaryVersionSubscriptionId,
		ROW_NUMBER() OVER (PARTITION BY DictionaryLocale, DictionaryVersionId, SegmentId ORDER BY DictionaryVersionSubscriptionId DESC) AS rownum
	FROM DictionaryVersionSubscriptions
)

UPDATE DVS
SET DVS.Deleted = 1
FROM DictionaryVersionSubscriptions DVS
	JOIN keepLast KL
		ON KL.DictionaryVersionSubscriptionId = DVS.DictionaryVersionSubscriptionId
		AND KL.rownum > 1