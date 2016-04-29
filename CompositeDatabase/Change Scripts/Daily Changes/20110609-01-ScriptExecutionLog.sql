
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- remove the old table if it exists
IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE TABLE_NAME = 'ScriptExecutionLog' AND COLUMN_NAME = 'ExecutionID')
BEGIN
	DROP TABLE ScriptExecutionLog
END

-- create two new tables

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'AppVersions'))
BEGIN

	CREATE TABLE [dbo].[AppVersions](
		[AppVersionID] [int] IDENTITY(1,1) NOT NULL,
		[Version] [varchar](50) NOT NULL,
		[Active] [bit] NOT NULL,
		[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_AppVersions] PRIMARY KEY CLUSTERED 
	(
		[AppVersionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE UNIQUE NONCLUSTERED INDEX [IX_AppVersions_Version] ON [dbo].[AppVersions] 
	(
		[Version] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ScriptExecutionLog'))
BEGIN

	CREATE TABLE [dbo].[ScriptExecutionLog](
		[ScriptExecutionLogID] [int] IDENTITY(1,1) NOT NULL,
		[AppVersionID] [int] NOT NULL,
		[ScriptName] [varchar](256) NOT NULL,
		[ScriptRunByDbLogin] [varchar](50) NOT NULL,
		[AppliedBy] [varchar](50) NOT NULL,
		[AppliedFrom] [varchar](50) NOT NULL,
		[StartTime] [datetime] NOT NULL,
		[EndTime] [datetime] NOT NULL,
		[ResultMessage] [varchar](1000) NOT NULL,
		[SQLResultCode] [varchar](20) NULL,
		[SegmentID] [int] NULL,
		[StudyID] [bigint] NULL,
	 CONSTRAINT [PK_ScriptExecutionLog] PRIMARY KEY CLUSTERED 
	(
		[ScriptExecutionLogID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[ScriptExecutionLog]  WITH CHECK ADD  CONSTRAINT [FK_ScriptExecutionLog_AppVersions] FOREIGN KEY([AppVersionID])
	REFERENCES [dbo].[AppVersions] ([AppVersionID])

END
GO