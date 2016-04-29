 /****** Object:  Table [dbo].[ProductionSupportNamedQueries]    Script Date: 11/30/2011 ******/
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ProductionSupportNamedQueries'))
BEGIN
	CREATE TABLE [dbo].[ProductionSupportNamedQueries](
		[QueryID] [int] IDENTITY(1,1) NOT NULL,
		[QueryName] [varchar](200) NOT NULL,
		[SPName] [varchar](100) NOT NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
	CONSTRAINT [PK_ProductionSupportNamedQueries] PRIMARY KEY CLUSTERED 
	(
		[QueryID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO
