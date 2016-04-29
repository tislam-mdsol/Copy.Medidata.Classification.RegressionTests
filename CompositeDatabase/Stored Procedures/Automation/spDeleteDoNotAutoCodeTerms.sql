IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spDeleteDoNotAutoCodeTerms')
DROP PROCEDURE spDeleteDoNotAutoCodeTerms
GO

CREATE PROCEDURE [dbo].[spDeleteDoNotAutoCodeTerms]
(
	@SegmentName	 NVARCHAR(255),
	@DictionaryList  NVARCHAR(255)
)
AS
BEGIN
	--production check
    IF NOT EXISTS (
        SELECT NULL 
        FROM CoderAppConfiguration
        WHERE Active = 1 AND IsProduction = 0)
    BEGIN
        PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
        RETURN 1
    END

    DECLARE @SegmentId	INT
	DECLARE @ListId		INT

    SELECT @SegmentId = SegmentId
    FROM Segments
    WHERE SegmentName = @SegmentName

	IF @SegmentId IS NULL
    BEGIN
        PRINT N'Cant find segment: ' + @SegmentName
    END

	SELECT @ListId = ListId
    FROM DoNotAutoCodeLists
    WHERE ListName  = @DictionaryList
	AND   SegmentId = @SegmentId

    IF @ListId IS NULL
    BEGIN
        PRINT N'Cant find do not auto code list: ' + @DictionaryList
    END

	DELETE FROM DoNotAutoCodeTerms 
	WHERE SegmentId = @SegmentId
	AND	  ListId	= @ListId
END
