-- Background : verify data project/study registration integrity

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'dgxRegistrationIntegrity')
	DROP PROCEDURE dgxRegistrationIntegrity
GO

CREATE PROCEDURE dbo.dgxRegistrationIntegrity
AS  
BEGIN

    DECLARE @t TABLE(
	    versionId INT PRIMARY KEY, 
	    dictionaryid INT, 
	    dictionaryOid VARCHAR(50), 
	    versionOid VARCHAR(50), 
	    dictionaryKey NVARCHAR(100),
	    dictionaryVersionKey NVARCHAR(100))

    INSERT INTO @t
    EXEC dbo.spGetDictionaryAndVersions

    SELECT *
    FROM ProjectDictionaryRegistrations PDR
	    CROSS APPLY
	    (
		    SELECT Dictionary = CASE WHEN PDR.RegistrationName = 'MedDRAMedHistory' THEN 'MedDRA' ELSE PDR.RegistrationName END
	    ) AS X
	    JOIN @t t
		    ON x.Dictionary = T.dictionaryOid
	    JOIN SynonymMigrationMngmt SMM
		    ON PDR.SynonymManagementID = SMM.SynonymMigrationMngmtID
		    AND SMM.Deleted = 0
    WHERE CHARINDEX(t.DictionaryKey, SMM.MedicalDictionaryVersionLocaleKey, 1) <> 1


    SELECT *
    FROM StudyDictionaryVersion sdv
	    CROSS APPLY
	    (
		    SELECT Dictionary = CASE WHEN sdv.RegistrationName = 'MedDRAMedHistory' THEN 'MedDRA' ELSE sdv.RegistrationName END
	    ) AS X
	    JOIN @t t
		    ON x.Dictionary = T.dictionaryOid
	    JOIN SynonymMigrationMngmt SMM
		    ON sdv.SynonymManagementID = SMM.SynonymMigrationMngmtID
		    AND SMM.Deleted = 0
    WHERE CHARINDEX(t.DictionaryKey, SMM.MedicalDictionaryVersionLocaleKey, 1) <> 1					

END