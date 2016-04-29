IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsLoad')
	DROP PROCEDURE spDoNotAutoCodeTermsLoad
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeTermsLoad
	@SegmentId				INT,
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100)
AS
BEGIN

	SELECT *
	FROM  DoNotAutoCodeTerms
	WHERE MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
		AND   [SegmentId]			= @SegmentId
		AND   [Active]				= 1

END 
GO 