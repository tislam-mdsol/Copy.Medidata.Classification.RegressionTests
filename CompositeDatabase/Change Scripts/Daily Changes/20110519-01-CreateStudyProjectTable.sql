IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'StudyProjects'))
BEGIN
	CREATE TABLE [dbo].[StudyProjects](
		[StudyProjectId] [int] IDENTITY(1,1) NOT NULL,

		ProjectName NVARCHAR(440) NOT NULL,
		iMedidataId NVARCHAR(50) NOT NULL,
		SegmentID INT NOT NULL,
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_StudyProjects_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_StudyProjects_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_StudyProjects] PRIMARY KEY CLUSTERED 
	(
		[StudyProjectID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)

	CREATE UNIQUE NONCLUSTERED INDEX [UIX_StudyProjects_UniqueNameInSegment] ON [dbo].[StudyProjects] 
	(
		ProjectName, SegmentID
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO


IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TrackableObjects'
		 AND COLUMN_NAME = 'StudyProjectId')
	ALTER TABLE TrackableObjects
	ADD StudyProjectId INT NOT NULL CONSTRAINT DF_TrackableObjects_StudyProjectId DEFAULT (-1)
GO  


IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'))
BEGIN
	CREATE TABLE [dbo].[ProjectDictionaryRegistrations](
		[ProjectDictionaryRegistrationID] [int] IDENTITY(1,1) NOT NULL,
		[UserID] [int] NOT NULL,
		[InteractionID] [int] NOT NULL,
		[DictionaryID] [int] NOT NULL,
		[VersionOrdinal] [int] NOT NULL,
		[StudyProjectID] [int] NOT NULL,
		[ProjectRegistrationTransmissionID] [int] NOT NULL,
		[Created] [datetime] NOT NULL CONSTRAINT DF_ProjectDictionaryRegistrations_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_ProjectDictionaryRegistrations_Updated DEFAULT (GETUTCDATE()),
		[SegmentId] [int] NOT NULL,
	 CONSTRAINT [PK_ProjectDictionaryRegistrations] PRIMARY KEY CLUSTERED 
	(
		[ProjectDictionaryRegistrationID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ProjectRegistrationTransms'))
BEGIN
	CREATE TABLE [dbo].[ProjectRegistrationTransms](
		[ProjectRegistrationTransmissionID] [int] IDENTITY(1,1) NOT NULL,
		[UserID] [int] NOT NULL,
		[StudyProjectID] [int] NOT NULL,
		[TransmissionResponses] [nvarchar](max) NULL,
		ApplicationIdsUpdatedInTransmission VARCHAR(MAX) NULL,
		ProjectRegistrationSucceeded [bit] NOT NULL,
		[Created] [datetime] NOT NULL CONSTRAINT DF_ProjectRegistrationTransms_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_ProjectRegistrationTransms_Updated DEFAULT (GETUTCDATE()),
		[SegmentId] [int] NOT NULL,
	 CONSTRAINT [PK_ProjectRegistrationTransms] PRIMARY KEY CLUSTERED 
	(
		[ProjectRegistrationTransmissionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO