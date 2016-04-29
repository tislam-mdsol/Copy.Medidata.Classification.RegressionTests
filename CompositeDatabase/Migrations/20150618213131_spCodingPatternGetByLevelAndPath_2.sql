IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByLevelAndPath')
	DROP PROCEDURE spCodingPatternGetByLevelAndPath
GO

CREATE PROCEDURE dbo.spCodingPatternGetByLevelAndPath
(
	@DictionaryLevelID SMALLINT,
	@CodingPath VARCHAR(MAX),
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100)
)
AS

BEGIN

	SELECT *
	FROM CodingPatterns
	WHERE LevelID = @DictionaryLevelID
		AND CodingPath = @CodingPath
		AND MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
	

END
GO
