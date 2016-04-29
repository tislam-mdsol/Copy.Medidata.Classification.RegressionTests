IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationLoadCurrent')
	DROP PROCEDURE spProjectDictionaryRegistrationLoadCurrent
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationLoadCurrent 
(
	@StudyProjectId INT
)
AS  
  
BEGIN  

	;WITH succReg
	AS
	(
		SELECT PR.*,
			ROW_NUMBER() OVER (PARTITION BY DVR.DictionaryRefId ORDER BY PR.created DESC) AS rownum
		FROM ProjectDictionaryRegistrations PR
			JOIN SynonymMigrationMngmt SMM
				ON PR.SynonymManagementID = SMM.SynonymMigrationMngmtID
			JOIN DictionaryVersionRef DVR
				ON DVR.DictionaryVersionRefID = SMM.DictionaryVersionId
		WHERE StudyProjectId = @StudyProjectId
			AND EXISTS (SELECT NULL FROM ProjectRegistrationTransms PT
				WHERE PR.ProjectRegistrationTransmissionID = PT.ProjectRegistrationTransmissionID
					AND PT.ProjectRegistrationSucceeded = 1)
	)
	
	SELECT *
	FROM succReg 
	WHERE rownum = 1 

END

GO
