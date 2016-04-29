
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CodingRequestCsvData_CodingRequests]') AND parent_object_id = OBJECT_ID(N'[dbo].[CodingRequestCsvData]'))
ALTER TABLE [dbo].[CodingRequestCsvData] DROP CONSTRAINT [FK_CodingRequestCsvData_CodingRequests]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CodingRequestCsvData]') AND type in (N'U'))
DROP TABLE [dbo].[CodingRequestCsvData]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CodingRequestCsvData](
	[CodingRequestCsvDataId] [int] IDENTITY(1,1) NOT NULL,
	[CodingRequestId] [int] NOT NULL,
	[FileName] [nvarchar](250) NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CodingRequestCsvData] PRIMARY KEY CLUSTERED 
(
	[CodingRequestCsvDataId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CodingRequestCsvData]  WITH CHECK ADD  CONSTRAINT [FK_CodingRequestCsvData_CodingRequests] FOREIGN KEY([CodingRequestId])
REFERENCES [dbo].[CodingRequests] ([CodingRequestId])
GO

ALTER TABLE [dbo].[CodingRequestCsvData] CHECK CONSTRAINT [FK_CodingRequestCsvData_CodingRequests]
GO