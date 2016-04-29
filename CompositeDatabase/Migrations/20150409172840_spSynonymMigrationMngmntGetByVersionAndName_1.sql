IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND NAME = 'spSynonymMigrationMngmntGetByVersionAndName')
	DROP PROCEDURE spSynonymMigrationMngmntGetByVersionAndName
GO
CREATE PROCEDURE dbo.spSynonymMigrationMngmntGetByVersionAndName
(
	@medicalDictionaryID INT, 
	@fromVersionId INT, 
	@toVersionId INT, 
	@locale CHAR(3), 
	@listName NVARCHAR(100),
	@segmentId INT
)
AS

	SELECT *
	FROM SynonymMigrationMngmt 
	WHERE DictionaryVersionId = @toVersionId
		AND locale = @locale
		AND segmentId = @segmentId
		AND ListName = @listName
		AND Deleted = 0

GO 