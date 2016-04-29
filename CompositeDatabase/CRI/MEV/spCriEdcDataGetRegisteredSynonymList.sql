IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCriEdcDataGetRegisteredSynonymList')
	DROP PROCEDURE dbo.spCriEdcDataGetRegisteredSynonymList
GO
 
--EXEC spCriEdcDataGetRegisteredSynonymList  'MedDRA', 'ENG', '85ca3527-0bd3-4b0f-88a0-aa006d2bbe14'

CREATE PROCEDURE dbo.spCriEdcDataGetRegisteredSynonymList (  
	@RegistrationName NVARCHAR(100),
	@Locale CHAR(3),
	@StudyID VARCHAR(50)
)  
AS  
BEGIN

	SELECT TOP 1 SMM.*
	FROM StudyDictionaryVersion SDV
		JOIN TrackableObjects TOS
			ON SDV.StudyID = TOS.TrackableObjectID
			AND TOS.ExternalObjectId = @StudyID
		JOIN SynonymMigrationMngmt SMM
			ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
			AND SMM.Deleted = 0
		CROSS APPLY
		(
			SELECT LongLocale = dbo.fnGetLocaleFromDictionaryVersionLocaleKey(SMM.MedicalDictionaryVersionLocaleKey)
		) AS L
		CROSS APPLY
		(
			SELECT ShortLocale = SUBSTRING(LongLocale, 1, 3)
		) AS X
	WHERE SDV.RegistrationName = @RegistrationName
		AND X.ShortLocale = @Locale
	ORDER BY SMM.SynonymMigrationMngmtID DESC
 
END  
  
GO
