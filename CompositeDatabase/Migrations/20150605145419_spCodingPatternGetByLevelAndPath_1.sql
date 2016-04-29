IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByLevelAndPath')
	DROP PROCEDURE spCodingPatternGetByLevelAndPath
GO

CREATE PROCEDURE dbo.spCodingPatternGetByLevelAndPath
(
	@DictionaryLevelID SMALLINT,
	@CodingPath VARCHAR(MAX),
	@VersionId INT,
	@Locale CHAR(3)
)
AS

BEGIN

	SELECT *
	FROM CodingPatterns
	WHERE LevelID = @DictionaryLevelID
		AND CodingPath = @CodingPath
		AND VersionId = @VersionId
		AND Locale = @Locale
	

END
GO
