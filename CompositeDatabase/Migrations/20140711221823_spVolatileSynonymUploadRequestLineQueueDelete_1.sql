IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spVolatileSynonymUploadRequestLineQueueDelete')
	DROP PROCEDURE spVolatileSynonymUploadRequestLineQueueDelete
GO

CREATE PROCEDURE dbo.spVolatileSynonymUploadRequestLineQueueDelete(
	@SynonymUploadRequestId INT,
	@LineNumber INT
)
AS
BEGIN 

	DELETE VolatileSynonymUploadRequestLineQueue
    WHERE SynonymUploadRequestId = @SynonymUploadRequestId
	AND  LineNumber = @LineNumber

END
GO