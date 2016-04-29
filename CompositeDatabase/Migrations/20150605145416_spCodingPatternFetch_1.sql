IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternFetch')
	DROP PROCEDURE spCodingPatternFetch
GO

CREATE PROCEDURE dbo.spCodingPatternFetch 
(
	@CodingPatternId BIGINT
)
AS

BEGIN
	SELECT *
	FROM CodingPatterns
	WHERE CodingPatternId = @CodingPatternId
END

GO

