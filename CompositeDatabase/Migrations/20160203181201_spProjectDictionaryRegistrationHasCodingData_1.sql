IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationHasCodingData')
	DROP PROCEDURE spProjectDictionaryRegistrationHasCodingData
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationHasCodingData 
(
	@StudyProjectID INT,
	@RegistrationName NVARCHAR(200),
	@dictionaryVersionLocaleKey NVARCHAR(200),
	@hasCodingData BIT OUTPUT
)  
AS  
BEGIN  

	-- AV : hack to determine registration uniqueness within locale
	DECLARE @legacyLocale NVARCHAR(50) = dbo.fnGetLocaleFromDictionaryVersionLocaleKey(@dictionaryVersionLocaleKey)

    IF EXISTS (SELECT NULL 
                FROM TrackableObjects TOS
                    JOIN StudyDictionaryVersion SDV
                        ON TOS.TrackableObjectId = SDV.StudyId
                        AND SDV.RegistrationName = @RegistrationName
                    JOIN SynonymMigrationMngmt SMM
			            ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
                        AND CHARINDEX(@legacyLocale, SMM.MedicalDictionaryVersionLocaleKey, 0) > 0
                    JOIN CodingElements CE
                        ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
                WHERE TOS.StudyProjectId = @StudyProjectID)
        SET @hasCodingData = 1
    ELSE
        SET @hasCodingData = 0

END

GO  
