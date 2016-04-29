IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymUploadDataCleanup')
	DROP PROCEDURE spSynonymUploadDataCleanup
GO

CREATE PROCEDURE dbo.spSynonymUploadDataCleanup(
@SynonymListId INT
)
AS
BEGIN

     --production check
	 IF EXISTS (
			SELECT NULL 
			FROM CoderAppConfiguration
			WHERE Active = 1 AND IsProduction = 1
				)
	BEGIN
		PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
		RETURN
	END

	DELETE FROM SegmentedGroupCodingPatterns
	WHERE SynonymManagementID = @SynonymListId

	DELETE FROM VolatileSynonymUploadRequestLineQueue
	WHERE SynonymUploadRequestId  IN 
	(SELECT SynonymUploadRequestId
	FROM SynonymUploadRequests
	WHERE SynonymListId = @SynonymListId)


	DELETE FROM SynonymUploadErrors
	WHERE SynonymUploadRequestId  IN 
	(SELECT SynonymUploadRequestId
	FROM SynonymUploadRequests
	WHERE SynonymListId = @SynonymListId)

	DELETE FROM SynonymUploadRequests
	WHERE SynonymListId = @SynonymListId

END
