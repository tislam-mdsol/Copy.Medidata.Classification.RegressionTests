-- this communication may map to more than 1 transmissionqueueitem 
-- if the a study is being handled by more than 1 sourcesystem
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'StudyRegistrationTransmissions'))
BEGIN
	CREATE TABLE [dbo].[StudyRegistrationTransmissions](
		[StudyRegistrationTransmissionID] INT IDENTITY(1,1) NOT NULL,
	
		UserID INT NOT NULL,
		TrackableObjectID INT NOT NULL,
		
		TransmissionResponses NVARCHAR(MAX), -- single?
		
		StudyRegistrationSucceeded BIT NOT NULL CONSTRAINT DF_StudyRegistrationTransmissions_StudyRegistrationSucceeded DEFAULT(0),
	
		[Created] DATETIME NOT NULL CONSTRAINT [DF_StudyRegistrationTransmissions_Created]  DEFAULT (GETUTCDATE()),
		[Updated] DATETIME NOT NULL CONSTRAINT [DF_StudyRegistrationTransmissions_Updated]  DEFAULT (GETUTCDATE()),
		
		[SegmentId] INT NOT NULL,
	 CONSTRAINT [PK_StudyRegistrationTransmissions] PRIMARY KEY CLUSTERED 
	(
		[StudyRegistrationTransmissionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO 

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'StudyDictionaryRegistrations'))
BEGIN
	CREATE TABLE [dbo].[StudyDictionaryRegistrations](
		[StudyDictionaryRegistrationID] INT IDENTITY(1,1) NOT NULL,
	
		UserID INT NOT NULL,
		InteractionID INT NOT NULL,
		
		DictionaryID INT NOT NULL,
		VersionOrdinal INT NOT NULL,
		TrackableObjectID INT NOT NULL,
		
		StudyRegistrationTransmissionID INT NOT NULL CONSTRAINT [DF_StudyDictionaryRegistrations_StudyRegistrationTransmissionID]  DEFAULT (-1),
		StudyDictionaryVersionID  INT NOT NULL CONSTRAINT [DF_StudyDictionaryRegistrations_StudyDictionaryVersionID]  DEFAULT (-1),

		[Created] DATETIME NOT NULL CONSTRAINT [DF_StudyDictionaryRegistrations_Created]  DEFAULT (GETUTCDATE()),
		[Updated] DATETIME NOT NULL CONSTRAINT [DF_StudyDictionaryRegistrations_Updated]  DEFAULT (GETUTCDATE()),
		
		[SegmentId] INT NOT NULL,
	 CONSTRAINT [PK_StudyDictionaryRegistrations] PRIMARY KEY CLUSTERED 
	(
		[StudyDictionaryRegistrationID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO 
