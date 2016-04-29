IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionGetByKey')
	DROP PROCEDURE spDictionaryVersionSubscriptionGetByKey
GO
CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionGetByKey
(
	@segmentID INT, 
	@versionId INT, 
	@locale CHAR(3)
)
AS
BEGIN

	SELECT DVS.*
	FROM DictionaryVersionSubscriptions DVS
	WHERE DVS.Deleted               = 0
		AND DVS.SegmentID           = @segmentID
		AND DVS.DictionaryLocale    = @locale
		AND DVS.DictionaryVersionId = @versionId

END 