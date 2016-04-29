IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByPath_CRI')
	DROP PROCEDURE spCodingPatternGetByPath_CRI
GO

CREATE PROCEDURE dbo.spCodingPatternGetByPath_CRI
(
	@CodingPath VARCHAR(MAX)
)
AS
BEGIN
    
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE @fixedCodingPath VARCHAR(MAX) = REPLACE(@CodingPath, '%20', ' ')

	SELECT *
	FROM CodingPatterns
	WHERE (CodingPath = @fixedCodingPath
	    OR CodingPath = @CodingPath)
    ORDER BY CodingPatternId ASC
	

END
GO
