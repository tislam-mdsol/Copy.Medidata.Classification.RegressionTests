IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsLoad_CRI')
	DROP PROCEDURE spDoNotAutoCodeTermsLoad_CRI
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeTermsLoad_CRI
	@SegmentId	INT,
	@ListId INT
AS
BEGIN

	SELECT Term, UserId, MedicalDictionaryLevelKey
	FROM  DoNotAutoCodeTerms
	WHERE ListId = @ListId
		AND   [SegmentId]			= @SegmentId
		AND   [Active]				= 1

END 
GO 