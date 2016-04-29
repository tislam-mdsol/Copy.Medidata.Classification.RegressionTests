IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spVolatileSynonymUploadRequestLineQueueDelete')
	DROP PROCEDURE spVolatileSynonymUploadRequestLineQueueDelete
GO

CREATE PROCEDURE dbo.spVolatileSynonymUploadRequestLineQueueDelete(
	@SynonymUploadRequestId INT
)
AS
BEGIN 

	DELETE VolatileSynonymUploadRequestLineQueue
    WHERE SynonymUploadRequestId = @SynonymUploadRequestId

END
GO