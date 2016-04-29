IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsLoad')
	DROP PROCEDURE spDoNotAutoCodeTermsLoad
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeTermsLoad
	@SegmentId	INT,
	@ListId INT
AS
BEGIN

	SELECT *
	FROM  DoNotAutoCodeTerms
	WHERE ListId = @ListId
		AND   [SegmentId]			= @SegmentId
		AND   [Active]				= 1

END 
GO 