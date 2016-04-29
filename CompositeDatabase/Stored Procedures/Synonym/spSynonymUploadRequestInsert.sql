IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymUploadRequestInsert')
	DROP PROCEDURE spSynonymUploadRequestInsert
GO

CREATE PROCEDURE dbo.spSynonymUploadRequestInsert(
	@SynonymListId INT,
	@FileName NVARCHAR(250),
	@UserId INT,
	@Created DateTime,
	@UploadStatus INT,
	@NumberOfTotalLines INT,
	@SynonymUploadRequestId INT OUTPUT
)
AS
BEGIN 
	INSERT INTO SynonymUploadRequests
	   ([FileName],
		UserId,
		Created,
		SynonymListId,
		UploadStatus,
		TotalSynonymLines)
	Values(
		@FileName,
		@UserId,
		@Created,
		@SynonymListId,
		@UploadStatus,
		@NumberOfTotalLines)

Set @SynonymUploadRequestId = SCOPE_IDENTITY()  


END
GO