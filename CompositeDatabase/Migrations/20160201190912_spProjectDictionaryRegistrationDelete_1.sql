IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationDelete')
	DROP PROCEDURE spProjectDictionaryRegistrationDelete
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationDelete 
(
	@ProjectDictionaryRegistrationID BIGINT
)  
AS  
BEGIN  

    -- check that no study registration exist for this registration
	DECLARE @registrationName NVARCHAR(100), 
		@locale NVARCHAR(50),
		@segmentId INT

	SELECT
		@registrationName = PDR.RegistrationName,
		@locale = dbo.fnGetLocaleFromDictionaryVersionLocaleKey(SMM.MedicalDictionaryVersionLocaleKey),
		@segmentId = PDR.SegmentId
	FROM ProjectDictionaryRegistrations PDR
		JOIN SynonymMigrationMngmt SMM
			ON PDR.SynonymManagementID = SMM.SynonymMigrationMngmtID
	WHERE PDR.ProjectDictionaryRegistrationID = @ProjectDictionaryRegistrationID

	IF EXISTS (
		SELECT NULL 
		FROM StudyDictionaryVersion SDV
			JOIN SynonymMigrationMngmt SMM
				ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
		WHERE SDV.SegmentID = @segmentId
			AND SDV.RegistrationName = @registrationName
			AND dbo.fnGetLocaleFromDictionaryVersionLocaleKey(SMM.MedicalDictionaryVersionLocaleKey) = @locale)
	BEGIN
		RAISERROR('Unable to delete registration due to existing dependent study registrations', 1, 16)
		RETURN 0
	END

	DELETE FROM ProjectDictionaryRegistrations
	WHERE ProjectDictionaryRegistrationID = @ProjectDictionaryRegistrationID


END

GO   