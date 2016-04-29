IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeListReadByDictionaryAndSegment_CRI')
	DROP PROCEDURE spDoNotAutoCodeListReadByDictionaryAndSegment_CRI
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeListReadByDictionaryAndSegment_CRI
	@SegmentId				INT,
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100)
AS
BEGIN

	SELECT ListId, ListName, MedicalDictionaryVersionLocaleKey, SegmentId
	FROM  DoNotAutoCodeLists
	WHERE MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
		AND   [SegmentId]			= @SegmentId

END 
GO 