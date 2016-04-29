IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationLoadPendingRegistrationsByProject')
	DROP PROCEDURE spProjectDictionaryRegistrationLoadPendingRegistrationsByProject
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationLoadPendingRegistrationsByProject 
(
	@projectId INT
)
AS  
BEGIN  

	SELECT PDR.*
	FROM ProjectDictionaryRegistrations PDR
		LEFT JOIN ProjectRegistrationTransms PRT
			ON PDR.ProjectRegistrationTransmissionID = PRT.ProjectRegistrationTransmissionID
	WHERE PDR.StudyProjectID = @projectId
		AND ISNULL(PRT.ProjectRegistrationSucceeded, PDR.ProjectRegistrationTransmissionID) < 1

END

GO 