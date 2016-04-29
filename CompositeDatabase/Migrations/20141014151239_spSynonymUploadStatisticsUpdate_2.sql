IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymUploadStatisticsUpdate')
	DROP PROCEDURE spSynonymUploadStatisticsUpdate
GO

CREATE PROCEDURE dbo.spSynonymUploadStatisticsUpdate(
	@SynonymUploadRequestId INT,
	@UploadStatus INT,
	@SynonymAdded INT,
	@SynonymSkipped INT,
	@SynonymErrored INT
)
AS
BEGIN

    UPDATE SynonymUploadRequests
	SET SynonymAdded   = SynonymAdded + @SynonymAdded,
	    SynonymSkipped = SynonymSkipped + @SynonymSkipped,
		SynonymErrored = SynonymErrored + @SynonymErrored,
		UploadStatus   = @UploadStatus  
	WHERE SynonymUploadRequestId = @SynonymUploadRequestId



END
GO