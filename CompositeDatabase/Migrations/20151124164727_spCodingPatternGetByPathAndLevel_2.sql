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

    DECLARE @fixedCodingPath VARCHAR(MAX) = REPLACE(@CodingPath, '%20', ' ')

	SELECT CodingPatternId, CodingPath, PathCount, MedicalDictionaryLevelKey
	FROM CodingPatterns
	WHERE REPLACE(CodingPath, '%20', ' ') = @fixedCodingPath
        AND MedicalDictionaryLevelKey = @MedicalDictionaryLevelKey
    ORDER BY CodingPatternId ASC

END
GO
