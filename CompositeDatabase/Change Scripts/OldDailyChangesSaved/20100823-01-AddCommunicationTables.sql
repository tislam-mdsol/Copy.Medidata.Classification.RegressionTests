IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CommunicationLogs'))
	CREATE TABLE [dbo].[CommunicationLogs](
		[CommunicationLogID] [int] IDENTITY(1,1) NOT NULL,
		[Active] [bit] NULL,
		WebURL NVARCHAR(1000) NOT NULL,
		IMedidataAppId INT NOT NULL,
		TransmissionStarted DATETIME NOT NULL,
		WebTimeDuration INT NOT NULL,
		OtherTimeDuration1 INT,
		OtherTimeDuration2 INT,
		OtherTimeDuration3 INT,
		HttpStatusCode INT NOT NULL,
		ErrorData NVARCHAR(1000) NOT NULL,
		WebTransmissionSize INT NOT NULL,
		WebTransmissionTypeId INT NOT NULL,
		IsSecurityCheckOK BIT NOT NULL,
		IsMessageParsedOK BIT NOT NULL,
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_CommunicationLogs_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_CommunicationLogs_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_CommunicationLogs] PRIMARY KEY CLUSTERED 
	(
		[CommunicationLogID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ServiceCommands'))
	CREATE TABLE [dbo].[ServiceCommands](
		[ServiceCommandID] [int] IDENTITY(1,1) NOT NULL,
		[Active] [bit] NULL,

		CommandName VARCHAR(100) NOT NULL,
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_ServiceCommands_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_ServiceCommands_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_ServiceCommands] PRIMARY KEY CLUSTERED 
	(
		[ServiceCommandID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ServiceCommandLogs'))
	CREATE TABLE [dbo].[ServiceCommandLogs](
		[ServiceCommandLogID] [int] IDENTITY(1,1) NOT NULL,
		[Active] [bit] NULL,

		ServiceCommandID INT NOT NULL,
		ServiceCommandParams NVARCHAR(MAX),
		UserID INT NOT NULL,
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_ServiceCommandLogs_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_ServiceCommandLogs_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_ServiceCommandLogs] PRIMARY KEY CLUSTERED 
	(
		[ServiceCommandLogID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 

IF (NOT EXISTS (SELECT NULL FROM sys.foreign_keys
	WHERE name = 'FK_ServiceCommandLogs_ServiceCommandID'))
	ALTER TABLE [dbo].[ServiceCommandLogs] WITH CHECK ADD CONSTRAINT [FK_ServiceCommandLogs_ServiceCommandID] FOREIGN KEY(ServiceCommandID)
	REFERENCES [dbo].[ServiceCommands] (ServiceCommandID)
GO


-- Command Population
IF (NOT EXISTS (SELECT NULL FROM ServiceCommands))
BEGIN
	INSERT INTO ServiceCommands (Active, CommandName)
	VALUES(1, 'RestartCron')

	INSERT INTO ServiceCommands (Active, CommandName)
	VALUES(1, 'ResetCronQueue')

	INSERT INTO ServiceCommands (Active, CommandName)
	VALUES(1, 'ResetODMRequestQueue')

	INSERT INTO ServiceCommands (Active, CommandName)
	VALUES(1, 'ResetODMRequestWorkerThreads')

	INSERT INTO ServiceCommands (Active, CommandName)
	VALUES(1, 'ApiDefinitionChange')
END