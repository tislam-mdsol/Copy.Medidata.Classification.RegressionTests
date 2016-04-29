IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spGetCurrentCodingElement')
DROP PROCEDURE spGetCurrentCodingElement
GO

CREATE PROCEDURE spGetCurrentCodingElement
(
    @Segment NVARCHAR(255)
)
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--production check
	IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
	BEGIN
	  PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	  RETURN
	END

	DECLARE @SegmentId INT
	
	SELECT @SegmentId = SegmentId
    FROM Segments
    WHERE SegmentName = @Segment
    
	IF @SegmentId IS NULL
    BEGIN
        PRINT N'cant find segment' + @SegmentId
    END

	SELECT Created, AutoCodeDate FROM CodingElements
	WHERE segmentid = @SegmentId
END