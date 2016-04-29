IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spGetSourceSystemApplicationData')
DROP PROCEDURE spGetSourceSystemApplicationData
GO

CREATE PROCEDURE spGetSourceSystemApplicationData
(
    @ApplicationName NVARCHAR(255)
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

	SELECT a.Name AS SourceSystem, s.DefaultLocale AS SourceSystemLocale, s.ConnectionUri AS ConnectionURI FROM Application a
	INNER JOIN SourceSystems s ON a.SourceSystemID = s.SourceSystemId
	WHERE a.Name = @ApplicationName
END