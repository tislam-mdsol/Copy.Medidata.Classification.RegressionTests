﻿IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spVolatileSynonymUploadRequestLineQueueGetByRequestId')
	DROP PROCEDURE spVolatileSynonymUploadRequestLineQueueGetByRequestId
GO

CREATE PROCEDURE dbo.spVolatileSynonymUploadRequestLineQueueGetByRequestId(
   @SynonymUploadRequestId INT,
   @LastLineNumber INT,
   @MaxItems INT
)
AS
BEGIN 
   SELECT TOP(@MaxItems) * 
   FROM VolatileSynonymUploadRequestLineQueue
   WHERE SynonymUploadRequestId = @SynonymUploadRequestId
   AND LineNumber > @LastLineNumber
   ORDER BY LineNumber ASC

END
GO