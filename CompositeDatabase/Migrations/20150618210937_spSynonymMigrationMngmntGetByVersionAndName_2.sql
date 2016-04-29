IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND NAME = 'spSynonymMigrationMngmntGetByVersionAndName')
	DROP PROCEDURE spSynonymMigrationMngmntGetByVersionAndName
GO
CREATE PROCEDURE dbo.spSynonymMigrationMngmntGetByVersionAndName
(
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100), 
	@listName NVARCHAR(100),
	@segmentId INT
)
AS

	SELECT *
	FROM SynonymMigrationMngmt 
	WHERE MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
		AND segmentId = @segmentId
		AND ListName = @listName
		AND Deleted = 0

GO 