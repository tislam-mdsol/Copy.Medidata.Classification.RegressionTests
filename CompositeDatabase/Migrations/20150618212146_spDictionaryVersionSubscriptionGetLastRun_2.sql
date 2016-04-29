IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionGetLastRun')
	DROP PROCEDURE spDictionaryVersionSubscriptionGetLastRun
GO
CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionGetLastRun
(
	@medicalDictionaryVersionLocaleKey  NVARCHAR(100)
)
AS
BEGIN

	SELECT TOP 1 DVS.*
	FROM DictionaryVersionSubscriptions DVS
	WHERE DVS.MedicalDictionaryVersionLocaleKey = @medicalDictionaryVersionLocaleKey
	ORDER BY DictionaryVersionSubscriptionID DESC

END 