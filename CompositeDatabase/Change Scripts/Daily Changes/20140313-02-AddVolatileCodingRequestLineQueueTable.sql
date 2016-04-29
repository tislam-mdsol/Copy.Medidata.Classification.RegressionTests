
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VolatileCodingRequestLineQueue_CodingRequests]') AND parent_object_id = OBJECT_ID(N'[dbo].[VolatileCodingRequestLineQueue]'))
ALTER TABLE [dbo].[VolatileCodingRequestLineQueue] DROP CONSTRAINT [FK_VolatileCodingRequestLineQueue_CodingRequests]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VolatileCodingRequestLineQueue]') AND type in (N'U'))
DROP TABLE [dbo].[VolatileCodingRequestLineQueue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[VolatileCodingRequestLineQueue](
	[SerializedData] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CodingRequestId] [int] NOT NULL,
	[LineNumber] [int] NOT NULL)
GO

ALTER TABLE [dbo].[VolatileCodingRequestLineQueue]  WITH CHECK ADD  CONSTRAINT [FK_VolatileCodingRequestLineQueue_CodingRequests] FOREIGN KEY([CodingRequestId])
REFERENCES [dbo].[CodingRequests] ([CodingRequestId])
GO

ALTER TABLE [dbo].[VolatileCodingRequestLineQueue] CHECK CONSTRAINT [FK_VolatileCodingRequestLineQueue_CodingRequests]
GO