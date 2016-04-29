IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeListReadById')
	DROP PROCEDURE spDoNotAutoCodeListReadById
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeListReadById
	@ListId INT
AS
BEGIN

	SELECT *
	FROM  DoNotAutoCodeLists
	WHERE ListId = @ListId

END 
GO 