
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spDeleteGeneralRole')
DROP PROCEDURE spDeleteGeneralRole
GO

CREATE PROCEDURE [dbo].spDeleteGeneralRole
( 
    @RoleName     NVARCHAR(255),
    @SegmentName  NVARCHAR(255)
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

    Declare @segmentID INT

    SELECT @segmentID = SegmentId
    FROM Segments
    WHERE SegmentName = @SegmentName

    IF @segmentID IS NULL
    BEGIN
        PRINT N'cant find segment'+@SegmentName
    END

	SELECT @segmentID = SegmentId
    FROM Segments
    WHERE SegmentName = @SegmentName
	DELETE FROM Roles
    WHERE SegmentID = @segmentID and RoleName = @RoleName and Active = 1 and Deleted = 0

END
