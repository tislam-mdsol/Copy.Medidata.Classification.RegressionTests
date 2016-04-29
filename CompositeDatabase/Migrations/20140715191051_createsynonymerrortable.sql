IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SynonymUploadErrors]') AND type in (N'U'))
DROP TABLE [dbo].[SynonymUploadErrors]
GO

	CREATE TABLE [dbo].[SynonymUploadErrors](
	SynonymUploadErrorId INT IDENTITY(1,1) NOT NULL,
	SynonymUploadRequestId INT NOT NULL CONSTRAINT DF_SynonymUploadErrors_CodingRequestId DEFAULT (0),
	CsvLine NVARCHAR(MAX) NOT NULL CONSTRAINT DF_SynonymUploadErrors_CsvLine DEFAULT (N''),
	SerializedErrors NVARCHAR(MAX) NOT NULL CONSTRAINT DF_SynonymUploadErrors_SerializedErrors DEFAULT (N''),
	DiagnosticMessage NVARCHAR(MAX) NOT NULL CONSTRAINT DF_SynonymUploadErrors_DiagnosticMessage DEFAULT (N'')
CONSTRAINT [PK_SynonymUploadErrors] PRIMARY KEY CLUSTERED 
(
	SynonymUploadErrorId ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO