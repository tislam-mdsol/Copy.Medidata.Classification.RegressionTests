IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spGetQueryUUIDByCodingElementUUID')
DROP PROCEDURE spGetQueryUUIDByCodingElementUUID
GO

CREATE PROCEDURE spGetQueryUUIDByCodingElementUUID
(
    @codingElementUUID NVARCHAR(50)
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
        RETURN
    END

    SELECT CoderQueries.QueryUUID
        FROM CoderQueries
        JOIN CodingElements
        ON CodingElements.CodingElementId = CoderQueries.CodingElementId
        Where CodingElements.UUID = @codingElementUUID
END
