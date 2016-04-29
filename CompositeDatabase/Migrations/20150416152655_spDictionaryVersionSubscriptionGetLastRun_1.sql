IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionGetLastRun')
	DROP PROCEDURE spDictionaryVersionSubscriptionGetLastRun
GO
CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionGetLastRun
(
	@versionId INT, 
	@locale CHAR(3)
)
AS
BEGIN

	SELECT TOP 1 DVS.*
	FROM DictionaryVersionSubscriptions DVS
	WHERE DVS.DictionaryLocale    = @locale
		AND DVS.DictionaryVersionId = @versionId
	ORDER BY DictionaryVersionSubscriptionID DESC

END 