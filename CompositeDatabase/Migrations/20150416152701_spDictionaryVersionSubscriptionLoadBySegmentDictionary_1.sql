IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionLoadBySegmentDictionary')
	DROP PROCEDURE spDictionaryVersionSubscriptionLoadBySegmentDictionary
GO
CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionLoadBySegmentDictionary
(
	@segmentID INT, 
	@medicalDictionaryId INT
)
AS
BEGIN

	SELECT DVS.*
	FROM DictionaryVersionSubscriptions DVS
		JOIN DictionaryVersionRef DVR
			ON DVR.DictionaryVersionRefID = DVS.DictionaryVersionId
			AND DVR.DictionaryRefId = @medicalDictionaryId
	WHERE DVS.Deleted = 0
		AND DVS.SegmentID = @segmentID

END 