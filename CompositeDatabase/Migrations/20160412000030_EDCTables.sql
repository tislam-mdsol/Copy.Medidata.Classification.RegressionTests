
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'EDCData')
BEGIN
	CREATE TABLE [dbo].[EDCData](
		[EDCDataID]						[BIGINT] IDENTITY(1,1) NOT NULL,
		[CodingRequestId]				[BIGINT] NOT NULL,
		
		[StudyUUID]						[VARCHAR](50) NOT NULL,
		[BatchOID]						[NVARCHAR](450) NOT NULL,
		[Locale]						[CHAR](3) NOT NULL,

		[Subject]						[NVARCHAR](100) NOT NULL,
		[Field]							[NVARCHAR](450) NOT NULL,
		[Form]							[NVARCHAR](450) NOT NULL,
		[VerbatimTerm]					[NVARCHAR](450) NOT NULL,
		[Event]							[NVARCHAR](256) NOT NULL,
		[Line]							[NVARCHAR](256) NOT NULL,
		[Site]							[NVARCHAR](256) NOT NULL,
		[Priority]						[TINYINT] NOT NULL,

		[SupplementFieldKey0]			[NVARCHAR](450),
		[SupplementFieldKey1]			[NVARCHAR](450),
		[SupplementFieldKey2]			[NVARCHAR](450),
		[SupplementFieldKey3]			[NVARCHAR](450),
		[SupplementFieldKey4]			[NVARCHAR](450),
                    
		[SupplementFieldVal0]			[NVARCHAR](1000),
		[SupplementFieldVal1]			[NVARCHAR](1000),
		[SupplementFieldVal2]			[NVARCHAR](1000),
		[SupplementFieldVal3]			[NVARCHAR](1000),
		[SupplementFieldVal4]			[NVARCHAR](1000),

		[MedicalDictionaryLevelKey]		[NVARCHAR](100) NULL,
		[RegistrationName]				[NVARCHAR](100) NOT NULL,
		[AssignedCodingPath]			[VARCHAR](300) NULL,
		[QueryComment]					[NVARCHAR](4000) NULL,
		[UserUUID]						[NVARCHAR](50) NULL,
				
		[Created]						[DATETIME] NOT NULL CONSTRAINT [DF_EDCData_Created]  DEFAULT (getutcdate()),
		[Updated]						[DATETIME] NOT NULL CONSTRAINT [DF_EDCData_Updated]  DEFAULT (getutcdate()),

		[TimeStamp]					    [DATETIME] NOT NULL,

		AuxiliaryID						[BIGINT] -- needed for data migration

	CONSTRAINT [PK_EDCData] PRIMARY KEY CLUSTERED 
	(
		[EDCDataID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	)
END


IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'EDCDataId')
BEGIN
	ALTER TABLE CodingElements
	ADD EDCDataId BIGINT NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_EDCDataId DEFAULT (-1)
END
GO
