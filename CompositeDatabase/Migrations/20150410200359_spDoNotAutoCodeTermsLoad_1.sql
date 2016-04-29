IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsLoad')
	DROP PROCEDURE spDoNotAutoCodeTermsLoad
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeTermsLoad
	@DictionaryVersionId	INT,
	@SegmentId				INT,
	@Locale					CHAR(3)
AS
BEGIN

	SELECT *
	FROM  DoNotAutoCodeTerms
	WHERE [DictionaryVersionId] = @DictionaryVersionId
		AND   [SegmentId]			= @SegmentId
		AND	  [Locale]				= @Locale
		AND   [Active]				= 1

END 
GO 