IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spGetUserNameByLogin')
DROP PROCEDURE spGetUserNameByLogin
GO

CREATE PROCEDURE spGetUserNameByLogin
(
    @Login NVARCHAR(50)
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

	SELECT FirstName + ' (' + [Login] + ')' AS UserName FROM [Users]
	WHERE [Login] = @Login
END
