IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymUploadRequestInsert')
	DROP PROCEDURE spSynonymUploadRequestInsert
GO

CREATE PROCEDURE dbo.spSynonymUploadRequestInsert(
	@SynonymListId INT,
	@FileName NVARCHAR(250),
	@UserId INT,
	@Created DateTime,
	@SynonymUploadRequestId INT OUTPUT
)
AS
BEGIN 
	INSERT INTO SynonymUploadRequests
	   ([FileName],
		UserId,
		Created,
		SynonymListId)
	Values(
		@FileName,
		@UserId,
		@Created,
		@SynonymListId)

Set @SynonymUploadRequestId = SCOPE_IDENTITY()  


END
GO