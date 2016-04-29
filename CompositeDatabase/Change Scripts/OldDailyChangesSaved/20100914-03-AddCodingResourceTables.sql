SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CodingResourceTransmission'))
BEGIN
	CREATE TABLE [dbo].[CodingResourceTransmission](
	[CodingResourceTransmissionID] [bigint] IDENTITY(1,1) NOT NULL,
	[Content] nvarchar(max),
	[SourceSystemID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_CodingResourceTransmission] PRIMARY KEY CLUSTERED 
	(
		[CodingResourceTransmissionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]	
	
	ALTER TABLE [dbo].[CodingResourceTransmission]  WITH CHECK ADD  CONSTRAINT [FK_CodingResourceTransmission_SourceSystems] FOREIGN KEY([SourceSystemID])
	REFERENCES [dbo].[SourceSystems] ([SourceSystemId])

END
GO 