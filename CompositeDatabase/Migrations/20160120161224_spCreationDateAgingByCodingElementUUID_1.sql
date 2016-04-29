IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCreationDateAgingByCodingElementUUID')
DROP PROCEDURE spCreationDateAgingByCodingElementUUID
GO

CREATE PROCEDURE spCreationDateAgingByCodingElementUUID
(
    @codingElementUUID NVARCHAR(50),
	@hoursToAge INT
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

	UPDATE CodingElements    
		SET CodingElements.Created = DATEADD(hour, - @hoursToAge, CodingElements.Created) 
		FROM CodingElements
		Where CodingElements.UUID = @codingElementUUID
END
