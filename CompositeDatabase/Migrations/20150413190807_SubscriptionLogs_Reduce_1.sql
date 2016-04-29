--remove dead links
DELETE SL
FROM SubscriptionLogs sl
	LEFT JOIN dictionaryversionlocaleref dvlr
		ON dvlr.dictionaryversionlocalerefid = sl.versionlocalestatusid
WHERE dvlr.dictionaryversionlocalerefid IS NULL

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SubscriptionLogs'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE SubscriptionLogs
	ADD DictionaryVersionId INT NOT NULL CONSTRAINT DF_SubscriptionLogs_DictionaryVersionId DEFAULT (0)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SubscriptionLogs'
		 AND COLUMN_NAME = 'DictionaryLocale')
	ALTER TABLE SubscriptionLogs
	ADD DictionaryLocale CHAR(3) NOT NULL CONSTRAINT DF_SubscriptionLogs_DictionaryLocale DEFAULT ('')
GO

