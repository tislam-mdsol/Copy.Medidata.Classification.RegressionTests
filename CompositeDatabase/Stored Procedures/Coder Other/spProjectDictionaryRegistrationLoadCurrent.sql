IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationLoadCurrent')
	DROP PROCEDURE spProjectDictionaryRegistrationLoadCurrent
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationLoadCurrent 
(
	@StudyProjectId INT
)
AS  
  
BEGIN  


	SELECT PR.*
	FROM ProjectDictionaryRegistrations PR
	WHERE StudyProjectId = @StudyProjectId
		AND EXISTS (SELECT NULL FROM ProjectRegistrationTransms PT
			WHERE PR.ProjectRegistrationTransmissionID = PT.ProjectRegistrationTransmissionID
				AND PT.ProjectRegistrationSucceeded = 1)

END

GO
