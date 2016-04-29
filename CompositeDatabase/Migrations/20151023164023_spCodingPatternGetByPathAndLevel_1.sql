IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByPathAndLevel')
	DROP PROCEDURE spCodingPatternGetByPathAndLevel
GO

CREATE PROCEDURE dbo.spCodingPatternGetByPathAndLevel
(
	@CodingPath VARCHAR(500),
    @MedicalDictionaryLevelKey NVARCHAR(100)
)
AS

BEGIN

	SELECT CodingPatternId, CodingPath, PathCount, MedicalDictionaryLevelKey
	FROM CodingPatterns
	WHERE CodingPath = @CodingPath
        AND MedicalDictionaryLevelKey = @MedicalDictionaryLevelKey

END
GO
