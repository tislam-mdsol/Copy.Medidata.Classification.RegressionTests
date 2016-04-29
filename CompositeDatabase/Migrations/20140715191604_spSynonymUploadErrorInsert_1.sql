IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymUploadErrorInsert')
	DROP PROCEDURE spSynonymUploadErrorInsert
GO

CREATE PROCEDURE dbo.spSynonymUploadErrorInsert(
	@SynonymUploadRequestId INT,
	@CsvLine NVARCHAR(MAX),
	@DiagnosticMessage NVARCHAR(MAX),
	@SerializedErrors NVARCHAR(MAX)
)
AS
BEGIN 
	INSERT INTO SynonymUploadErrors
	   (SynonymUploadRequestId,
		CsvLine,
		DiagnosticMessage,
		SerializedErrors)
	Values(
		@SynonymUploadRequestId,
		@CsvLine,
		@DiagnosticMessage,
		@SerializedErrors)



END
GO