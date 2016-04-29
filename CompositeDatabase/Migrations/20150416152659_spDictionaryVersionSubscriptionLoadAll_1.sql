

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionLoadAll')
	DROP PROCEDURE spDictionaryVersionSubscriptionLoadAll
GO

CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionLoadAll
AS
	
	SELECT DVS.*
	FROM DictionaryVersionSubscriptions DVS

GO  