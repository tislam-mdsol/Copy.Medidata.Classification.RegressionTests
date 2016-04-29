IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByPath')
	DROP PROCEDURE spCodingPatternGetByPath
GO

CREATE PROCEDURE dbo.spCodingPatternGetByPath
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
