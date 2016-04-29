SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VolatileSynonymUploadRequestLineQueue_SynonymUploadRequests]') AND parent_object_id = OBJECT_ID(N'[dbo].[VolatileSynonymUploadRequestLineQueue]'))
ALTER TABLE [dbo].[VolatileSynonymUploadRequestLineQueue] DROP CONSTRAINT [FK_VolatileSynonymUploadRequestLineQueue_SynonymUploadRequests]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SynonymUploadRequests]') AND type in (N'U'))
DROP TABLE [dbo].[SynonymUploadRequests]
GO

	CREATE TABLE [dbo].[SynonymUploadRequests](
	SynonymUploadRequestId INT IDENTITY(1,1) NOT NULL,
	[FileName] NVARCHAR(250) NOT NULL,
	UserId INT NOT NULL,
	Created DATETIME NOT NULL CONSTRAINT DF_SynonymUploadRequests_Created DEFAULT (GETUTCDATE()),
	SynonymListId INT NOT NULL,
	UploadStatus TINYINT NOT NULL CONSTRAINT DF_SynonymUploadRequests_RequestState DEFAULT (0)
CONSTRAINT [PK_SynonymUploadRequests] PRIMARY KEY CLUSTERED 
(
	SynonymUploadRequestId ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VolatileSynonymUploadRequestLineQueue]') AND type in (N'U'))
DROP TABLE [dbo].[VolatileSynonymUploadRequestLineQueue]
GO

CREATE TABLE [dbo].[VolatileSynonymUploadRequestLineQueue](
	[SerializedData] NVARCHAR(MAX) NOT NULL,
	[Created] DATETIME NOT NULL,
	[SynonymUploadRequestId] INT NOT NULL,
	[LineNumber] INT NOT NULL)
GO

ALTER TABLE [dbo].[VolatileSynonymUploadRequestLineQueue]  WITH CHECK 
ADD CONSTRAINT [FK_VolatileSynonymUploadRequestLineQueue_SynonymUploadRequests] FOREIGN KEY([SynonymUploadRequestId])
REFERENCES [dbo].[SynonymUploadRequests] ([SynonymUploadRequestId])
ON DELETE CASCADE
GO




