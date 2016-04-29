IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymListGetById')
	DROP PROCEDURE spSynonymListGetById
GO

CREATE PROCEDURE dbo.spSynonymListGetById(
	@SynonymListId INT
)
AS
BEGIN 
	SELECT SL.*
	FROM SynonymMigrationMngmt SL
	WHERE SL.SynonymMigrationMngmtID=@SynonymListId
		AND SL.Deleted = 0
END
GO
