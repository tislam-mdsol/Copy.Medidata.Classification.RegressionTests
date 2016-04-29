IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetLocaleFromDictionaryVersionLocaleKey')
	DROP FUNCTION dbo.fnGetLocaleFromDictionaryVersionLocaleKey
GO
CREATE FUNCTION dbo.fnGetLocaleFromDictionaryVersionLocaleKey
(
	@dictionaryVersionLocaleKey NVARCHAR(200)
)
RETURNS NVARCHAR(50)
AS
BEGIN
	-- AV : hack to determine registration uniqueness within locale
	DECLARE @Locale NVARCHAR(50)
	DECLARE @dashMatch INT = -1
	DECLARE @lastMatch INT = -1

	WHILE (@dashMatch <> 0)
	BEGIN

		SET @dashMatch = CHARINDEX('-', @dictionaryVersionLocaleKey, @dashMatch+1)
		IF (@dashMatch <> 0)
			SET @lastMatch = @dashMatch
	END

	SET @Locale = SUBSTRING(@dictionaryVersionLocaleKey, @lastMatch, LEN(@dictionaryVersionLocaleKey) - @lastMatch + 1) 

	RETURN @Locale
	
END
