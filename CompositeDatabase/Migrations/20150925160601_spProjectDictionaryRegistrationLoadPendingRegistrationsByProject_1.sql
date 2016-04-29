IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationLoadPendingRegistrationsByProject')
	DROP PROCEDURE spProjectDictionaryRegistrationLoadPendingRegistrationsByProject
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationLoadPendingRegistrationsByProject 
(
	@projectId INT
)
AS  
  
BEGIN  

	SELECT *
	FROM ProjectDictionaryRegistrations
	WHERE StudyProjectID = @projectId
		AND ProjectRegistrationTransmissionID < 1 -- not set

END

GO 