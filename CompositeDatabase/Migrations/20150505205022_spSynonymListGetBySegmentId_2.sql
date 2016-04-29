IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymListGetBySegmentId')
	DROP PROCEDURE spSynonymListGetBySegmentId
GO

CREATE PROCEDURE dbo.spSynonymListGetBySegmentId(
	@SegmentId BIGINT
)
AS
BEGIN 
	SELECT SL.*
	FROM SynonymMigrationMngmt SL
	WHERE SL.SegmentID=@SegmentId
	AND SL.Deleted = 0
END
GO
