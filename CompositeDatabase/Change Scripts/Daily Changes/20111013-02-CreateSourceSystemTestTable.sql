SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'SourceSystemTestTransmission'))
BEGIN
	-- new table
	CREATE TABLE [dbo].[SourceSystemTestTransmission](	
		[SourceSystemTestTransmissionID] [bigint] IDENTITY(1,1) NOT NULL,	
		[ApplicationID] [int] NOT NULL,		
		[IsSuccessful] [bit] NOT NULL,
		[ResponseStatus] [nvarchar](100) NOT NULL,
		[ResponseDetail] [nvarchar](max) NOT NULL,
		[Exception] [nvarchar](max) NULL,	
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,			
	 CONSTRAINT [PK_SourceSystemTestTransmission] PRIMARY KEY CLUSTERED 
	(
		[SourceSystemTestTransmissionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	-- index on ApplicationID
	CREATE UNIQUE NONCLUSTERED INDEX [IX_ApplicationID] ON [dbo].[SourceSystemTestTransmission] 
	(
		[ApplicationID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	-- foreign key on ApplicationID
	ALTER TABLE [dbo].[SourceSystemTestTransmission]  WITH CHECK ADD  CONSTRAINT [FK_SourceSystemTestTransmission_Application] FOREIGN KEY([ApplicationID])
	REFERENCES [dbo].[Application] ([ApplicationID])

END
GO
