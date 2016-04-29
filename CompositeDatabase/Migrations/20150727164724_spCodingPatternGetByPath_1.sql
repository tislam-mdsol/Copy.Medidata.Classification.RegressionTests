IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByPath')
	DROP PROCEDURE spCodingPatternGetByPath
GO

CREATE PROCEDURE dbo.spCodingPatternGetByPath
(
	@CodingPath VARCHAR(MAX)
)
AS

BEGIN

	SELECT CodingPatternId, CodingPath, PathCount, MedicalDictionaryLevelKey
	FROM CodingPatterns
	WHERE CodingPath = @CodingPath
	

END
GO
