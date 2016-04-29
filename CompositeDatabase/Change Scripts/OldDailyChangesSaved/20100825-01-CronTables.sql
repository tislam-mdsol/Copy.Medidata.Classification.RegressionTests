IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CronActions'))
BEGIN
	CREATE TABLE [dbo].[CronActions](
		[CronActionID] [int] IDENTITY(1,1) NOT NULL,
		[Active] [bit] NULL,

		CronActionName VARCHAR(100) NOT NULL,
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_CronActions_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_CronActions_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_CronActions] PRIMARY KEY CLUSTERED 
	(
		[CronActionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)

	CREATE UNIQUE NONCLUSTERED INDEX [UIX_CronActions_UniqueName] ON [dbo].[CronActions] 
	(
		[CronActionName] ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ApiCronSchedules'))
	CREATE TABLE [dbo].[ApiCronSchedules](
		[ApiCronScheduleID] [int] IDENTITY(1,1) NOT NULL,
		[Active] [bit] NULL,

		ApiAdminId INT NOT NULL,
		CronActionID INT NOT NULL,
		Schedule VARCHAR(500) NOT NULL,
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_ApiCronSchedules_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_ApiCronSchedules_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_ApiCronSchedules] PRIMARY KEY CLUSTERED 
	(
		[ApiCronScheduleID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 

IF (NOT EXISTS (SELECT NULL FROM sys.foreign_keys
 WHERE name = 'FK_ApiCronSchedules_CronActionID'))
	ALTER TABLE [dbo].[ApiCronSchedules] WITH CHECK ADD CONSTRAINT [FK_ApiCronSchedules_CronActionID] FOREIGN KEY(CronActionID)
	REFERENCES [dbo].[CronActions] (CronActionID)
GO

IF (NOT EXISTS (SELECT NULL FROM sys.foreign_keys
 WHERE name = 'FK_ApiCronSchedules_ApiAdminId'))
	ALTER TABLE [dbo].[ApiCronSchedules] WITH CHECK ADD CONSTRAINT [FK_ApiCronSchedules_ApiAdminId] FOREIGN KEY(ApiAdminId)
	REFERENCES [dbo].[ApplicationAdmin] (ApplicationAdminId)
GO

IF (NOT EXISTS (SELECT NULL FROM CronActions))
BEGIN
	INSERT INTO CronActions (Active, CronActionName)
	VALUES(1, 'PollCodingRequests')
END
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ServiceHeartBeats'))
	CREATE TABLE [dbo].[ServiceHeartBeats](
		[ServiceHeartBeatID] [int] IDENTITY(1,1) NOT NULL,

		CommaDelimCommandIds VARCHAR(50),
		Delimeter CHAR(1),
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_ServiceHeartBeats_Created DEFAULT (GETUTCDATE())
	 CONSTRAINT [PK_ServiceHeartBeats] PRIMARY KEY CLUSTERED 
	(
		[ServiceHeartBeatID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 