IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionLoadBySegment')
	DROP PROCEDURE spDictionaryVersionSubscriptionLoadBySegment
GO
CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionLoadBySegment
(
	@segmentID INT
)
AS
BEGIN

	SELECT DVS.*
	FROM DictionaryVersionSubscriptions DVS
	WHERE DVS.Deleted = 0
		AND DVS.SegmentID = @segmentID

END 