IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationGetByProjectAndRegistration')
	DROP PROCEDURE spProjectDictionaryRegistrationGetByProjectAndRegistration
GO

-- EXEC spProjectDictionaryRegistrationGetByProjectAndRegistration 5, 'MedDRA', 'MedDRA-15_1-English'

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationGetByProjectAndRegistration 
(
	@StudyProjectID INT,
	@RegistrationName NVARCHAR(200),
	@dictionaryVersionLocaleKey NVARCHAR(200)
)  
AS  
BEGIN  

	-- AV : hack to determine registration uniqueness within locale
	DECLARE @legacyLocale NVARCHAR(50) = dbo.fnGetLocaleFromDictionaryVersionLocaleKey(@dictionaryVersionLocaleKey)

	SELECT TOP 1 PDR.*
    FROM ProjectDictionaryRegistrations PDR
	WHERE PDR.StudyProjectID = @StudyProjectID
        AND PDR.RegistrationName = @RegistrationName
		-- AV : hack to determine registration uniqueness within locale
		AND EXISTS (SELECT NULL FROM SynonymMigrationMngmt SMM
			WHERE PDR.SynonymManagementID = SMM.SynonymMigrationMngmtID
				AND CHARINDEX(@legacyLocale, SMM.MedicalDictionaryVersionLocaleKey, 0) > 0)

END

GO  
