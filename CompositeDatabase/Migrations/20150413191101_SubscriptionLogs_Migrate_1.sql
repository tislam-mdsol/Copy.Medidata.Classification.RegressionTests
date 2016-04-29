UPDATE sl
SET sl.DictionaryVersionId = dvlr.NewVersionId,
	sl.DictionaryLocale = dvlr.Locale
FROM SubscriptionLogs sl
	JOIN dictionaryversionlocaleref dvlr
		ON dvlr.dictionaryversionlocalerefid = sl.versionlocalestatusid
		AND dvlr.versionstatus = 8
		AND dvlr.oldversionordinal IS NULL

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SubscriptionLogs'
		 AND COLUMN_NAME = 'versionlocalestatusid')
	ALTER TABLE SubscriptionLogs
	DROP COLUMN versionlocalestatusid
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSubscriptionLogLoadByVerLocaleID')
	DROP PROCEDURE spSubscriptionLogLoadByVerLocaleID
GO