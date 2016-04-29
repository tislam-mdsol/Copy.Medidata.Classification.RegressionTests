IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymUploadErrorGetById')
	DROP PROCEDURE spSynonymUploadErrorGetById
GO

CREATE PROCEDURE dbo.spSynonymUploadErrorGetById(
	@SynonymUploadRequestId INT
)
AS
BEGIN 
	SELECT *
	FROM SynonymUploadErrors
	WHERE SynonymUploadRequestId = @SynonymUploadRequestId
END
GO
