IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymListStatusUpdate')
	DROP PROCEDURE spSynonymListStatusUpdate
GO

CREATE PROCEDURE dbo.spSynonymListStatusUpdate(
	@SynonymListId INT,
	@SynonymListStatus INT
)
AS
BEGIN

    UPDATE SynonymMigrationMngmt
	SET SynonymMigrationStatusRID = @SynonymListStatus
	WHERE SynonymMigrationMngmtID = @SynonymListId



END
GO