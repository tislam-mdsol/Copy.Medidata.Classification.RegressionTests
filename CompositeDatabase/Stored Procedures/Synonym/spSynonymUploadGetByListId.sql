IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymUploadGetByListId')
	DROP PROCEDURE spSynonymUploadGetByListId
GO

CREATE PROCEDURE dbo.spSynonymUploadGetByListId(
	@SynonymListId INT
)
AS
BEGIN 
	SELECT SUR.*, U.FirstName, U.Login
	FROM SynonymUploadRequests SUR
	JOIN Users U ON SUR.UserId = U.UserID
	WHERE SUR.SynonymListId = @SynonymListId
END
GO
