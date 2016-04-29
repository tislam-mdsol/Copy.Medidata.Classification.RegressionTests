SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnRemoveNonAlphaCharacters')
	DROP FUNCTION dbo.fnRemoveNonAlphaCharacters 
GO

CREATE FUNCTION [dbo].[fnRemoveNonAlphaCharacters](@Temp VARCHAR(1000))
RETURNS VARCHAR(1000)
AS
BEGIN

    DECLARE @KeepValues AS VARCHAR(50)

    SET @KeepValues = '%[^a-z]%'

    WHILE PatIndex(@KeepValues, @Temp) > 0
        SET @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')

    RETURN @Temp
END