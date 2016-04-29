IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spVolatileSynonymUploadRequestLineQueueInsert')
	DROP PROCEDURE spVolatileSynonymUploadRequestLineQueueInsert
GO

CREATE PROCEDURE dbo.spVolatileSynonymUploadRequestLineQueueInsert(
	@SerializedData NVARCHAR(MAX),
	@SynonymUploadRequestId INT,
	@LineNumber INT
)
AS
BEGIN 
    DECLARE @Created DateTime =GETUTCDATE()

	INSERT INTO VolatileSynonymUploadRequestLineQueue
	   (SerializedData,
	    SynonymUploadRequestId,
		Created,
		LineNumber
		)
	Values(
	    @SerializedData,
		@SynonymUploadRequestId,
		@Created,
		@LineNumber
		)

END
GO