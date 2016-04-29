IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'RaveCoderExtract')
BEGIN
	CREATE TABLE [dbo].[RaveCoderExtract](
		[RaveCoderExtractID]						[BIGINT] IDENTITY(1,1) NOT NULL,
		[ExternalObjectName] 						[nvarchar](4000) NULL,
		[EnvironmentName] 							[nvarchar](200) NULL,
		[ExternalObjectId] 							[varchar](36) NULL,
		[SiteName] 									[nvarchar](4000) NULL,
		[SiteNumber] 								[nvarchar](200) NULL,
		[SourceSubject] 							[nvarchar](200) NULL,
		[FolderName] 								[nvarchar](4000) NULL,
		[FolderOID] 								[varchar](100) NULL,
		[ParentInstance] 							[nvarchar](4000) NULL,
		[InstanceName] 								[nvarchar](4000) NULL,
		[InstanceRepeatNumber] 						[int] NULL,
		[SourceForm] 								[nvarchar](900) NULL,
		[FormOID] 									[varchar](100) NULL,
		[DataPageName] 								[nvarchar](4000) NULL,
		[PageRepeatNumber] 							[int] NULL,
		[SourceField] 								[varchar](450) NULL,
		[RecordPosition] 							[int] NULL,
		[UUID] 										[char](36) NULL,
		[DatapointID] 								[int] NULL,
		[HasContexthash] 							[bit] NULL,
		[CodingContextURI] 							[nvarchar](1000) NULL,
		[Locale]									[nvarchar](20) NULL,
		[RegistrationName]							[nvarchar](100) NULL,
		[Dataactive] 								[bit] NULL,
		[Istouched] 								[bit] NULL,
		[RecordActive] 								[bit] NULL,
		[StudyActive] 								[bit] NULL,
		[StudysiteActive] 							[bit] NULL,
		[SubjectActive]								[bit] NULL,
		[ProjectActive]								[bit] NULL,
		[VerbatimTerm] 								[nvarchar](2000) NULL,
		[SupplementalTermkey] 						[varchar](max) NULL,
		[SupplementalValue] 						[varchar](max) NULL,
		[CodedDate] 								[datetime] NULL,
		[IsCoded] 									[bit] NULL,
		[Codingpath] 								[nvarchar](max) NULL,
		[Created]									[datetime] NOT NULL CONSTRAINT [DF_EDCData_Created]  DEFAULT (getutcdate()),
        [RaveToken] 								[int] NOT NULL -- TODO : this has to be unique per Rave
	CONSTRAINT [PK_EDCData] PRIMARY KEY CLUSTERED 
	(
		[RaveCoderExtractID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	)
END