IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternGetByLevelAndPath')
	DROP PROCEDURE spCodingPatternGetByLevelAndPath
GO

CREATE PROCEDURE dbo.spCodingPatternGetByLevelAndPath
(
	@MedicalDictionaryLevelKey NVARCHAR(100),
	@CodingPath VARCHAR(MAX),
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100)
)
AS

BEGIN

	SELECT *
	FROM CodingPatterns
	WHERE MedicalDictionaryLevelKey = @MedicalDictionaryLevelKey
		AND CodingPath = @CodingPath
		AND MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
	

END
GO
