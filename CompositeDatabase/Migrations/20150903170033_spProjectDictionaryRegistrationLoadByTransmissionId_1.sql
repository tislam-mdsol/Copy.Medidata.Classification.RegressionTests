
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationLoadByTransmissionId')
	DROP PROCEDURE dbo.spProjectDictionaryRegistrationLoadByTransmissionId
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationLoadByTransmissionId 
(
	@projectRegistrationTransmissionId INT
)
AS
BEGIN  

	;WITH groupedRegistrations AS
	(
			SELECT *,
				ROW_NUMBER() OVER (PARTITION BY SynonymManagementID, StudyProjectID, RegistrationName ORDER BY ProjectDictionaryRegistrationId DESC) AS RowNum
			FROM ProjectDictionaryRegistrations
			WHERE ProjectRegistrationTransmissionId = @projectRegistrationTransmissionId
	)


	SELECT *
	FROM groupedRegistrations
	WHERE RowNum = 1

END
GO