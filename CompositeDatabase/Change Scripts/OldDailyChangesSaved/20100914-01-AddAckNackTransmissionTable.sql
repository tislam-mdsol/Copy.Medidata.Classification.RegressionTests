IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'AckNackTransmissions'))
	CREATE TABLE [dbo].[AckNackTransmissions](
		[AckNackTransmissionID] BIGINT IDENTITY(1,1) NOT NULL,
		
		CodingElementID INT NOT NULL,
		TransmissionQueueItemID BIGINT NOT NULL DEFAULT (-1),
		IsSentSynchronously BIT NOT NULL DEFAULT (0),

		[Created] [datetime] NOT NULL CONSTRAINT DF_AckNackTransmissions_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_AckNackTransmissions_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_AckNackTransmissions] PRIMARY KEY CLUSTERED 
	(
		[AckNackTransmissionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 

IF (NOT EXISTS (SELECT NULL FROM sys.foreign_keys
	WHERE name = 'FK_AckNackTransmissions_CodingElementID'))
	ALTER TABLE [dbo].[AckNackTransmissions] WITH CHECK ADD CONSTRAINT [FK_AckNackTransmissions_CodingElementID] FOREIGN KEY(CodingElementID)
	REFERENCES [dbo].CodingElements (CodingElementID)
GO 


IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'OutTransmissions'))
	CREATE TABLE [dbo].[OutTransmissions](
		[OutTransmissionID] BIGINT IDENTITY(1,1) NOT NULL,
		
		SourceSystemID INT NOT NULL,
		TransmissionTypeID INT NOT NULL,
		
		Acknowledged BIT NOT NULL DEFAULT (0),
		AcknowledgeDate DATETIME,
		TransmissionSuccess BIT NOT NULL DEFAULT (0),
		TransmissionDate DATETIME,
		
		HttpStatusCode INT,
		WebExceptionStatus VARCHAR(50),
		TextToTransmit VARCHAR(MAX), -- compressed?
		ResponseText VARCHAR(MAX), -- compressed?
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_OutTransmissions_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_OutTransmissions_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_OutTransmissions] PRIMARY KEY CLUSTERED 
	(
		[OutTransmissionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 

IF (NOT EXISTS (SELECT NULL FROM sys.foreign_keys
	WHERE name = 'FK_OutTransmissions_SourceSystemID'))
	ALTER TABLE [dbo].[OutTransmissions] WITH CHECK ADD CONSTRAINT [FK_OutTransmissions_SourceSystemID] FOREIGN KEY(SourceSystemID)
	REFERENCES [dbo].SourceSystems (SourceSystemID)
GO 


IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'OutTransmissionLogs'))
	CREATE TABLE [dbo].[OutTransmissionLogs](
		[OutTransmissionLogID] BIGINT IDENTITY(1,1) NOT NULL,
		
		ObjectId BIGINT NOT NULL,
		OutTransmissionID BIGINT NOT NULL,
		TransmissionQueueItemId BIGINT NOT NULL,
		
		Succeeded BIT NOT NULL DEFAULT (0),
		ResponseVerificationCode VARCHAR(100),
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_OutTransmissionLogs_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_OutTransmissionLogs_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_OutTransmissionLogs] PRIMARY KEY CLUSTERED 
	(
		[OutTransmissionLogID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 

IF (NOT EXISTS (SELECT NULL FROM sys.foreign_keys
	WHERE name = 'FK_OutTransmissionLogs_OutTransmissionID'))
	ALTER TABLE [dbo].[OutTransmissionLogs] WITH CHECK ADD CONSTRAINT [FK_OutTransmissionLogs_OutTransmissionID] FOREIGN KEY(OutTransmissionID)
	REFERENCES [dbo].OutTransmissions (OutTransmissionID)
GO 

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'OutServiceHeartBeats'))
	CREATE TABLE [dbo].[OutServiceHeartBeats](
		[OutServiceHeartBeatID] BIGINT IDENTITY(1,1) NOT NULL,

		-- feedback data
		SourceTransmissionsReceived INT NOT NULL DEFAULT (0),
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_OutServiceHeartBeats_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_OutServiceHeartBeats_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_OutServiceHeartBeats] PRIMARY KEY CLUSTERED 
	(
		[OutServiceHeartBeatID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
GO 


 
