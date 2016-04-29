IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationGetByProjectAndRegistration')
	DROP PROCEDURE spProjectDictionaryRegistrationGetByProjectAndRegistration
GO

-- EXEC spProjectDictionaryRegistrationGetByProjectAndRegistration 5, '1'

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationGetByProjectAndRegistration 
(
	@StudyProjectID INT,
	@RegistrationName NVARCHAR(200)
)  
AS  
BEGIN  

	SELECT TOP 1 *
    FROM ProjectDictionaryRegistrations
	WHERE StudyProjectID = @StudyProjectID
        AND RegistrationName = @RegistrationName

END

GO  