IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionaryVersionSubscriptionLoadBySgmtDctLcl')
	DROP PROCEDURE spDictionaryVersionSubscriptionLoadBySgmtDctLcl
GO
CREATE PROCEDURE dbo.spDictionaryVersionSubscriptionLoadBySgmtDctLcl
(
	@segmentID INT, 
	@medicalDictionaryId INT, 
	@locale CHAR(3)
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
		AND DVS.DictionaryLocale = @locale

END 