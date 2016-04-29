IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spInsertDoNotAutoCodeTerms')
DROP PROCEDURE spInsertDoNotAutoCodeTerms
GO

CREATE PROCEDURE [dbo].[spInsertDoNotAutoCodeTerms]
(
	@SegmentName	 NVARCHAR(255),
	@DictionaryList  NVARCHAR(255),
	@Term			 NVARCHAR(255),
	@Dictionary      NVARCHAR(255),
	@Level			 NVARCHAR(255),
	@Login           NVARCHAR(255)
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
	DECLARE @UserId     INT
	DECLARE @MedicalDictionaryLevelKey NVARCHAR(255)

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

	SELECT @MedicalDictionaryLevelKey = @Dictionary + '-' + @Level

	SELECT @UserId = UserId
	from Users
	WHERE [Login] = @Login

	IF @UserId IS NULL
	BEGIN
		PRINT N'Cant find userId from login: ' + @Login
	END

	INSERT INTO [dbo].[DoNotAutoCodeTerms]
	(DictionaryLocale_Backup,DictionaryVersionId_Backup,Term,DictionaryLevelId_Backup,Active,UserId,SegmentId,Created,Updated,MedicalDictionaryVersionLocaleKey,MedicalDictionaryLevelKey,ListId)
	VALUES('',0,@Term,0,1,@UserId,@SegmentId,GETDATE(),GETDATE(),'',@MedicalDictionaryLevelKey,@ListId)
END
