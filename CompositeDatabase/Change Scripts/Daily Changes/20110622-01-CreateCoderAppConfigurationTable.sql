CREATE TABLE [dbo].[CoderAppConfiguration](
	[CoderAppConfigurationID] INT IDENTITY(1,1) NOT NULL,

    IsProduction BIT NOT NULL CONSTRAINT DF_CoderAppConfiguration_IsProduction DEFAULT (0),
    Active BIT NOT NULL CONSTRAINT DF_CoderAppConfiguration_Active DEFAULT (0),

	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CoderAppConfiguration] PRIMARY KEY CLUSTERED 
(
	[CoderAppConfigurationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 

ALTER TABLE [dbo].[CoderAppConfiguration] 
ADD  CONSTRAINT [DF_CoderAppConfiguration_Created]  DEFAULT (getutcdate()) FOR [Created]
GO

ALTER TABLE [dbo].[CoderAppConfiguration]
ADD  CONSTRAINT [DF_CoderAppConfiguration_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_CoderAppConfiguration_Single')
	CREATE UNIQUE NONCLUSTERED INDEX [UIX_CoderAppConfiguration_Single] ON [dbo].[CoderAppConfiguration] 
	(
		CoderAppConfigurationID ASC
	)
	WHERE Active=1
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO