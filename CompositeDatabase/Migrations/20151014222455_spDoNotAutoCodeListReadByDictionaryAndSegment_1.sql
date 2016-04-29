IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeListReadByDictionaryAndSegment')
	DROP PROCEDURE spDoNotAutoCodeListReadByDictionaryAndSegment
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeListReadByDictionaryAndSegment
	@SegmentId				INT,
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100)
AS
BEGIN

	SELECT *
	FROM  DoNotAutoCodeLists
	WHERE MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
		AND   [SegmentId]			= @SegmentId

END 
GO 