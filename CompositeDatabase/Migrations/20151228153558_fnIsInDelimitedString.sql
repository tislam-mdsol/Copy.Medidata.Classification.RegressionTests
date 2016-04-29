IF object_id('fnIsInDelimitedString') IS NOT NULL
	DROP FUNCTION dbo.fnIsInDelimitedString
GO

CREATE FUNCTION dbo.fnIsInDelimitedString(@str nvarchar(max),@id nvarchar(max),@sep nchar(1))
RETURNS BIT
AS
BEGIN
DECLARE @ret BIT
	IF EXISTS(SELECT NULL WHERE @id in(SELECT ITEM FROM DBO.fnParseDelimitedString(@str,@sep)))
		SELECT @ret=1
	ELSE
		SELECT @ret=0

		RETURN @ret
END
