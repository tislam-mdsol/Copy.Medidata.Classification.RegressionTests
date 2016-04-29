IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByPath')
	DROP PROCEDURE spCodingPatternGetByPath
GO

CREATE PROCEDURE dbo.spCodingPatternGetByPath
(
	@CodingPath VARCHAR(MAX)
)
AS
BEGIN
    
    DECLARE @fixedCodingPath VARCHAR(MAX) = REPLACE(@CodingPath, '%20', ' ')

	SELECT CodingPatternId, CodingPath, PathCount, MedicalDictionaryLevelKey
	FROM CodingPatterns
	WHERE REPLACE(CodingPath, '%20', ' ') = @fixedCodingPath
    ORDER BY CodingPatternId ASC
	

END
GO
