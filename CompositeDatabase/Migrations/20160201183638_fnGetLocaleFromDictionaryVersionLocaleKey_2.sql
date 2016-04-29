-- AV : hack to determine registration uniqueness within locale
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

	DECLARE @reverseKey NVARCHAR(200) = REVERSE(@dictionaryVersionLocaleKey)

    RETURN 
        REVERSE(
            SUBSTRING(
                @reverseKey, 
                1, 
                CHARINDEX('-',  @reverseKey)
                    -1
                )
            )

END