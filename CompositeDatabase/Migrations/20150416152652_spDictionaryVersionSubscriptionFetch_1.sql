
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionFetch')
	DROP PROCEDURE spDictionaryVersionSubscriptionFetch
GO
CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionFetch
(
	@DictionaryVersionSubscriptionId int
)
AS
	
	SELECT DVS.*
	FROM DictionaryVersionSubscriptions DVS
	WHERE DVS.DictionaryVersionSubscriptionId = @DictionaryVersionSubscriptionId
		
	
GO 