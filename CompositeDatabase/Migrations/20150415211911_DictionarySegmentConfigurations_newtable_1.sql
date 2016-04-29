IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DictionarySegmentConfigurations'))
BEGIN
		CREATE TABLE [dbo].[DictionarySegmentConfigurations](
		DictionarySegmentConfigurationId INT IDENTITY(1,1) NOT NULL,
		
		SegmentId INT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_SegmentId DEFAULT (0),
		DictionaryId INT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_DictionaryId DEFAULT (0),
		UserId INT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_UserId DEFAULT (0),

		DefaultSuggestThreshold INT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_DefaultSuggestThreshold DEFAULT (0),
		DefaultSelectThreshold INT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_DefaultSelectThreshold DEFAULT (0),
		MaxNumberofSearchResults INT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_MaxNumberofSearchResults DEFAULT (0),

		IsAutoAddSynonym BIT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_IsAutoAddSynonym DEFAULT (0),
		Active BIT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_Active DEFAULT (0),
		IsAutoApproval BIT NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_IsAutoApproval DEFAULT (0),


		Created DATETIME NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_Created DEFAULT (GETUTCDATE()),
		Updated DATETIME NOT NULL CONSTRAINT DF_DictionarySegmentConfigurations_Updated DEFAULT (GETUTCDATE()),
	CONSTRAINT [PK_DictionarySegmentConfigurations] PRIMARY KEY CLUSTERED 
	(
		DictionarySegmentConfigurationId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	-- A conditional unique constraints
	CREATE UNIQUE NONCLUSTERED INDEX [UIX_DictionarySegmentConfigurations_SegmentDictionary] 
	ON [dbo].[DictionarySegmentConfigurations] 
	(
		DictionaryId ASC,
		SegmentID ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END