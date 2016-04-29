/****** Object:  FullTextCatalog [MedicalDictionaryTermCat]    Script Date: 01/04/2011 10:58:21 ******/
CREATE FULLTEXT CATALOG [MedicalDictionaryTermCat]WITH ACCENT_SENSITIVITY = ON
AUTHORIZATION [dbo]
GO
/****** Object:  FullTextCatalog [MedicalDictTermComponentsCat]    Script Date: 01/04/2011 10:58:21 ******/
CREATE FULLTEXT CATALOG [MedicalDictTermComponentsCat]WITH ACCENT_SENSITIVITY = ON
AUTHORIZATION [dbo]
GO
/****** Object:  Table [dbo].[Workflows]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Workflows](
	[WorkflowID] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[WorkflowNameID] [int] NOT NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL,
	[SegmentID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_Workflows] PRIMARY KEY CLUSTERED 
(
	[WorkflowID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserPreferences]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[UserPreferences](
	[UserPreferenceId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[SessionId] [varchar](36) NULL,
	[TaskActiveTabIndex] [int] NOT NULL,
	[BrowserActiveTabIndex] [int] NOT NULL,
	[PopupActiveTabIndex] [int] NOT NULL,
	[HideTaskPropDetailRow0] [bit] NOT NULL,
	[HideTaskPropDetailRow1] [bit] NOT NULL,
	[HideTaskPropDetailRow2] [bit] NOT NULL,
	[HideTaskPropDetailRow3] [bit] NOT NULL,
	[HideBrowserPropDetailRow0] [bit] NOT NULL,
	[HideBrowserPropDetailRow1] [bit] NOT NULL,
	[HideBrowserPropDetailRow2] [bit] NOT NULL,
	[HideBrowserPropDetailRow3] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_UserPreferences] PRIMARY KEY CLUSTERED 
(
	[UserPreferenceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WorkflowStateIcons]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowStateIcons](
	[WorkflowStateIconID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowStateIconNameID] [int] NULL,
	[Icon] [image] NULL,
	[Active] [bit] NULL,
	[SegmentID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_WorkflowStateIcons] PRIMARY KEY CLUSTERED 
(
	[WorkflowStateIconID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Segments]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Segments](
	[SegmentId] [int] IDENTITY(1,1) NOT NULL,
	[SegmentName] [nvarchar](255) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
	[IMedidataId] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Segments] PRIMARY KEY CLUSTERED 
(
	[SegmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Segments] UNIQUE NONCLUSTERED 
(
	[OID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Segments_IMedidataID] UNIQUE NONCLUSTERED 
(
	[IMedidataId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SegmentedGroupCodingPatterns]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SegmentedGroupCodingPatterns](
	[SegmentedGroupCodingPatternID] [int] IDENTITY(1,1) NOT NULL,
	[CodingElementGroupID] [int] NOT NULL,
	[CodingPatternID] [int] NOT NULL,
	[DictionaryVersionID] [smallint] NOT NULL,
	[SegmentID] [smallint] NULL,
	[MatchPercent] [decimal](18, 0) NOT NULL,
	[IsValidForAutoCode] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[AssociatedSynonymTermID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_SegmentedGroupCodingPatterns] PRIMARY KEY CLUSTERED 
(
	[SegmentedGroupCodingPatternID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRT]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRT](
	[Prodtype_Id] [nvarchar](10) NOT NULL,
	[Text] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_PRT] PRIMARY KEY CLUSTERED 
(
	[Prodtype_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRG]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRG](
	[Productgroup_Id] [nvarchar](10) NOT NULL,
	[ProductgroupName] [nvarchar](60) NOT NULL,
	[DateRecorded] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_PRG] PRIMARY KEY CLUSTERED 
(
	[Productgroup_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PP]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PP](
	[Pharmproduct_Id] [int] NOT NULL,
	[Pharmform_Id] [nvarchar](10) NULL,
	[RouteOfAdministration] [nvarchar](10) NULL,
	[Medicinalprod_Id] [int] NULL,
	[NumberOfIngredients] [nvarchar](2) NULL,
	[CreateDate] [nvarchar](8) NULL,
 CONSTRAINT [PK_PP] PRIMARY KEY CLUSTERED 
(
	[Pharmproduct_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PF]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PF](
	[Pharmform_Id] [int] NOT NULL,
	[Text] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_PF] PRIMARY KEY CLUSTERED 
(
	[Pharmform_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionR](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_PermissionR] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OutServiceHeartBeats]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OutServiceHeartBeats](
	[OutServiceHeartBeatID] [bigint] IDENTITY(1,1) NOT NULL,
	[SourceTransmissionsReceived] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_OutServiceHeartBeats] PRIMARY KEY CLUSTERED 
(
	[OutServiceHeartBeatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ORG]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORG](
	[Organization_Id] [int] NOT NULL,
	[Name] [nvarchar](80) NOT NULL,
	[CountryCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_ORG] PRIMARY KEY CLUSTERED 
(
	[Organization_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ObjRefModelR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjRefModelR](
	[ObjRefModelId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjRefModelExclusions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjRefModelExclusions](
	[ObjRefModelExclusionId] [int] IDENTITY(1,1) NOT NULL,
	[ObjRefId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
 CONSTRAINT [PK_ObjRefModelExclusions] PRIMARY KEY CLUSTERED 
(
	[ObjRefId] ASC,
	[ModelId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ObjectTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjectTypeR](
	[ObjectTypeID] [int] NOT NULL,
	[ObjectName] [varchar](100) NULL,
	[ObjectTypeNameSpace] [varchar](200) NULL,
	[ObjectTypeName] [varchar](200) NULL,
	[AssemblyName] [varchar](1000) NULL,
	[IsConjoinedSibling] [bit] NOT NULL,
	[HostTableName] [varchar](30) NULL,
 CONSTRAINT [PK_ObjectTypeR] PRIMARY KEY CLUSTERED 
(
	[ObjectTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_OBJECTTYPER_NAME] UNIQUE NONCLUSTERED 
(
	[ObjectTypeName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectSegmentAttributes]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ObjectSegmentAttributes](
	[ObjectSegmentAttributeID] [int] IDENTITY(1,1) NOT NULL,
	[ObjectSegmentID] [int] NOT NULL,
	[Tag] [varchar](50) NOT NULL,
	[Value] [nvarchar](2000) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_ObjectSegmentAttributes] PRIMARY KEY CLUSTERED 
(
	[ObjectSegmentAttributeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectiveReferences]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjectiveReferences](
	[ObjectiveReferenceID] [int] IDENTITY(1,1) NOT NULL,
	[OriginatingObjectType] [int] NOT NULL,
	[TargetObjectType] [int] NOT NULL,
	[ImplementingProperty] [varchar](100) NOT NULL,
	[Integrity] [varchar](50) NOT NULL,
	[ImplementingIDProperty] [varchar](100) NULL,
 CONSTRAINT [PK_ObjectiveReferences] PRIMARY KEY CLUSTERED 
(
	[ObjectiveReferenceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MP]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MP](
	[Medicinalprod_Id] [int] NOT NULL,
	[MedID] [nvarchar](35) NULL,
	[DrugRecordNumber] [nvarchar](6) NOT NULL,
	[SequenceNumber1] [nvarchar](2) NOT NULL,
	[SequenceNumber2] [nvarchar](3) NOT NULL,
	[SequenceNumber3] [nvarchar](10) NOT NULL,
	[SequenceNumber3Text] [nvarchar](80) NULL,
	[SequenceNumber4] [nvarchar](10) NOT NULL,
	[SequenceNumber4Text] [nvarchar](500) NULL,
	[Generic] [nvarchar](1) NOT NULL,
	[DrugName] [nvarchar](80) NOT NULL,
	[NameSpecifier] [nvarchar](30) NOT NULL,
	[MarketingAuthNumber] [nvarchar](30) NOT NULL,
	[MarketingAuthDate] [nvarchar](8) NOT NULL,
	[MarketingAuthWDate] [nvarchar](8) NOT NULL,
	[CountryCode] [varchar](3) NOT NULL,
	[CountryName] [nvarchar](80) NOT NULL,
	[Company] [int] NULL,
	[CompanyName] [nvarchar](80) NULL,
	[CompanyCountryCode] [varchar](3) NULL,
	[CompanyCountryName] [nvarchar](80) NULL,
	[MarketingAuthHolder] [nvarchar](10) NOT NULL,
	[MarketingAuthHolderName] [nvarchar](80) NULL,
	[MarketingAuthHolderCountryCode] [varchar](3) NULL,
	[MarketingAuthHolderCountryName] [nvarchar](80) NULL,
	[SourceCode] [nvarchar](10) NOT NULL,
	[Source] [nvarchar](200) NOT NULL,
	[SourceCountryCode] [varchar](3) NOT NULL,
	[SourceCountryName] [varchar](80) NULL,
	[SourceYear] [nvarchar](3) NOT NULL,
	[ProductTypeId] [varchar](10) NOT NULL,
	[ProductType] [nvarchar](80) NOT NULL,
	[ProductGroupID] [varchar](10) NOT NULL,
	[ProductGroupName] [nvarchar](60) NOT NULL,
	[ProductGroupDateRecorded] [nvarchar](8) NULL,
	[CreateDate] [nvarchar](8) NOT NULL,
	[DateChanged] [nvarchar](8) NOT NULL,
	[TermID] [int] NOT NULL,
 CONSTRAINT [PK_MP] PRIMARY KEY CLUSTERED 
(
	[Medicinalprod_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictVerTermRel]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictVerTermRel](
	[MedicalDictionaryTermRelID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[FromTermId] [int] NOT NULL,
	[ToTermId] [int] NOT NULL,
	[LevelMappingId] [smallint] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
	[RelationshipComments] [nvarchar](50) NOT NULL,
	[DictionaryVersionOrdinal] [tinyint] NOT NULL,
 CONSTRAINT [PK_MadicalDictionaryTermRel] PRIMARY KEY CLUSTERED 
(
	[MedicalDictionaryTermRelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalDictVerTerm]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictVerTerm](
	[TermId] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[DictionaryLevelId] [smallint] NULL,
	[TermStatus] [tinyint] NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Term_ENG] [nvarchar](450) NOT NULL,
	[Term_JPN] [nvarchar](450) NOT NULL,
	[Term_LOC] [nvarchar](450) NOT NULL,
	[DictionaryVersionOrdinal] [tinyint] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[Nodepath] [varchar](max) NOT NULL,
	[NodepathDepth] [tinyint] NOT NULL,
	[LevelRecursiveDepth] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedicalDictVerTerm] PRIMARY KEY CLUSTERED 
(
	[TermId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictVerStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MedicalDictVerStatusR](
	[OID] [varchar](50) NULL,
	[VersionStatus] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictionaryVersion]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictionaryVersion](
	[DictionaryVersionId] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[MedicalDictionaryId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[ExternalSQL] [nvarchar](max) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictionaryVersion] PRIMARY KEY CLUSTERED 
(
	[DictionaryVersionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictVerLocaleStatus]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictVerLocaleStatus](
	[MedicalDictVerLocaleStatusID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[NewVersionOrdinal] [int] NOT NULL,
	[OldVersionOrdinal] [int] NULL,
	[Locale] [char](3) NOT NULL,
	[VersionStatus] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[ReleaseDate] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictVerLocaleStatus] PRIMARY KEY CLUSTERED 
(
	[MedicalDictVerLocaleStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictTermTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictTermTypeR](
	[MedicalDictTermTypeID] [int] NOT NULL,
	[NameDescID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictTermTypeR] PRIMARY KEY CLUSTERED 
(
	[MedicalDictTermTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocalizationContexts]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LocalizationContexts](
	[ContextID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [nvarchar](300) NULL,
	[Cached] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_LocalizationContexts] PRIMARY KEY CLUSTERED 
(
	[ContextID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedDictLevelCmpntVerUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictLevelCmpntVerUpdates](
	[LevelCmpntVersionUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[InitialLevelComponentID] [bigint] NULL,
	[VersionLevelComponentID] [int] NOT NULL,
	[FinalLevelComponentID] [bigint] NULL,
	[ChangeTypeId] [int] NOT NULL,
	[FromVersionOrdinal] [int] NOT NULL,
	[ToVersionOrdinal] [int] NOT NULL,
	[Locale] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictLevelCmpntVerUpdates] PRIMARY KEY CLUSTERED 
(
	[LevelCmpntVersionUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictVerChangeTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictVerChangeTypeR](
	[ChangeTypeID] [int] NOT NULL,
	[NameDescID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedDictVerChangeType] PRIMARY KEY CLUSTERED 
(
	[ChangeTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictTermVerUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictTermVerUpdates](
	[TermVersionUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[InitialTermId] [int] NULL,
	[VersionTermId] [int] NOT NULL,
	[FinalTermId] [int] NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
	[ChangeTypeId] [tinyint] NULL,
	[Locale] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictTermVerUpdates] PRIMARY KEY CLUSTERED 
(
	[TermVersionUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictTermUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictTermUpdates](
	[TermUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[InitialTermId] [int] NULL,
	[VersionTermId] [int] NOT NULL,
	[FinalTermId] [int] NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
	[ChangeTypeId] [tinyint] NOT NULL,
	[Locale] [tinyint] NOT NULL,
	[ImpactAnalysisChangeTypeId] [tinyint] NOT NULL,
	[PriorTermID] [int] NOT NULL,
 CONSTRAINT [PK_MedDictTermUpdates] PRIMARY KEY CLUSTERED 
(
	[TermUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictTermStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictTermStatusR](
	[TermStatusID] [int] NOT NULL,
	[NameDescID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedDictTermStatus] PRIMARY KEY CLUSTERED 
(
	[TermStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictTermRelVerUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictTermRelVerUpdates](
	[TermRelVersionUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[InitialTermRelID] [int] NULL,
	[VersionTermRelID] [int] NOT NULL,
	[FinalTermRelID] [int] NULL,
	[ChangeTypeId] [tinyint] NOT NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictTermRelVerUpdates] PRIMARY KEY CLUSTERED 
(
	[TermRelVersionUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictTermRelUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictTermRelUpdates](
	[TermRelUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[InitialTermRelID] [int] NULL,
	[VersionTermRelID] [int] NOT NULL,
	[FinalTermRelID] [int] NULL,
	[ChangeTypeId] [tinyint] NOT NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictTermRelUpdates] PRIMARY KEY CLUSTERED 
(
	[TermRelUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalDictionaryTerm]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictionaryTerm](
	[TermId] [int] IDENTITY(1,1) NOT NULL,
	[DictionaryLevelId] [smallint] NOT NULL,
	[SegmentId] [smallint] NOT NULL,
	[MasterTermId] [int] NOT NULL,
	[NodePath] [varchar](max) NOT NULL,
	[TermType] [tinyint] NOT NULL,
	[TermStatus] [tinyint] NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Term_ENG] [nvarchar](450) NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
	[Term_JPN] [nvarchar](450) NOT NULL,
	[Term_LOC] [nvarchar](450) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[ParentId] [int] NULL,
	[IsCurrent] [bit] NOT NULL,
	[IORVersionLocaleValidity] [varbinary](100) NULL,
	[LevelRecursiveDepth] [tinyint] NOT NULL,
	[ProgrammaticAuxiliary] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictionaryTerm] PRIMARY KEY CLUSTERED 
(
	[TermId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictionaryTemplates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictionaryTemplates](
	[TemplateId] [int] IDENTITY(1,1) NOT NULL,
	[NameStringId] [int] NOT NULL,
	[DescriptionStringId] [int] NULL,
	[SegmentId] [int] NULL,
	[MedicalDictionaryId] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictionaryTemplates] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SynonymActionR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SynonymActionR](
	[SynonymActionID] [int] NOT NULL,
	[ActionOID] [varchar](50) NULL,
 CONSTRAINT [PK_SynonymActionR] PRIMARY KEY CLUSTERED 
(
	[SynonymActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SynMigrReconciledCategoryR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SynMigrReconciledCategoryR](
	[OID] [varchar](50) NULL,
	[CategoryStatus] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SUN]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SUN](
	[Substance_Id] [int] NOT NULL,
	[CASNumber] [nvarchar](10) NOT NULL,
	[LanguageCode] [nvarchar](10) NOT NULL,
	[SubstanceName] [nvarchar](110) NOT NULL,
	[SourceYear] [nvarchar](3) NOT NULL,
	[SourceCode] [nvarchar](10) NULL,
	[SourceCode_] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_SUN] PRIMARY KEY CLUSTERED 
(
	[Substance_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubscriptionLogs]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubscriptionLogs](
	[SubscriptionLogID] [int] IDENTITY(1,1) NOT NULL,
	[VersionLocaleStatusID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_SubscriptionLogs] PRIMARY KEY CLUSTERED 
(
	[SubscriptionLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudyRegistrationTransmissions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudyRegistrationTransmissions](
	[StudyRegistrationTransmissionID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[TrackableObjectID] [int] NOT NULL,
	[TransmissionResponses] [nvarchar](max) NULL,
	[StudyRegistrationSucceeded] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_StudyRegistrationTransmissions] PRIMARY KEY CLUSTERED 
(
	[StudyRegistrationTransmissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudyDictionaryRegistrations]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudyDictionaryRegistrations](
	[StudyDictionaryRegistrationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[InteractionID] [int] NOT NULL,
	[DictionaryID] [int] NOT NULL,
	[VersionOrdinal] [int] NOT NULL,
	[TrackableObjectID] [int] NOT NULL,
	[StudyRegistrationTransmissionID] [int] NOT NULL,
	[StudyDictionaryVersionID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_StudyDictionaryRegistrations] PRIMARY KEY CLUSTERED 
(
	[StudyDictionaryRegistrationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STR](
	[Strength_Id] [int] NOT NULL,
	[Text] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_STR] PRIMARY KEY CLUSTERED 
(
	[Strength_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StdStringTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StdStringTypeR](
	[StringTypeID] [int] IDENTITY(1,1) NOT NULL,
	[StringType] [varchar](50) NOT NULL,
	[ProductName] [varchar](4) NOT NULL,
	[DescriptionTag] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_StdStringTypeR] PRIMARY KEY CLUSTERED 
(
	[StringTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_StringTypes] UNIQUE NONCLUSTERED 
(
	[StringType] ASC,
	[ProductName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SRCE]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SRCE](
	[SourceCode] [nvarchar](10) NOT NULL,
	[Source] [nvarchar](80) NOT NULL,
	[CountryCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_SRCE] PRIMARY KEY CLUSTERED 
(
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SynonymLoadStaging]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SynonymLoadStaging](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SynonymManagementID] [int] NOT NULL,
	[LineNumber] [int] NOT NULL,
	[MasterTermID] [bigint] NOT NULL,
	[SynText] [nvarchar](450) NOT NULL,
	[SynLevelID] [int] NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[ActivatedStatus] [tinyint] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[ParentPath] [varchar](500) NOT NULL,
	[UsePrimary] [bit] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
	[CodingElementGroupID] [bigint] NOT NULL,
 CONSTRAINT [PK_SynonymLoadStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SynonymLoadingTable]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SynonymLoadingTable](
	[SynText] [nvarchar](450) NULL,
	[Code] [nvarchar](50) NULL,
	[Nodepath] [varchar](1000) NULL,
	[SegmentID] [int] NULL,
	[SynonymLevelID] [int] NULL,
	[VersionOrdinal] [int] NULL,
	[MedicalDictionaryID] [int] NULL,
	[Locale] [char](3) NULL,
	[ActivatedStatus] [int] NULL,
	[LineNumber] [int] NOT NULL,
	[MasterTermID] [bigint] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectSegmentStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectSegmentStatusR](
	[ObjectSegmentStatus] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
 CONSTRAINT [PK_ObjectSegmentStatusR] PRIMARY KEY CLUSTERED 
(
	[ObjectSegmentStatus] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolePermissionR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePermissionR](
	[RolePermissionID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_RolePermissionR] PRIMARY KEY CLUSTERED 
(
	[RolePermissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScriptExecutionLog]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ScriptExecutionLog](
	[ExecutionID] [int] IDENTITY(1,1) NOT NULL,
	[ScriptDate] [char](8) NOT NULL,
	[ScriptNumber] [char](2) NOT NULL,
	[ScriptName] [varchar](50) NOT NULL,
	[ScriptRevision] [int] NOT NULL,
	[RequiredForBuild] [varchar](15) NOT NULL,
	[IsRerunnable] [bit] NOT NULL,
	[ScriptCompletedDateTime] [datetime] NOT NULL,
	[ScriptRunByDbLogin] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ScriptExecutionLog] PRIMARY KEY CLUSTERED 
(
	[ScriptDate] ASC,
	[ScriptNumber] ASC,
	[ScriptCompletedDateTime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SourceSystems]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[SourceSystems](
	[SourceSystemId] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NULL,
	[SourceSystemVersion] [nvarchar](50) NOT NULL,
	[ConnectionURI] [nvarchar](2000) NULL,
	[DefaultLocale] [nchar](3) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[DefaultSegmentId] [int] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[SourceSystems] ADD [Username] [varchar](100) NULL
ALTER TABLE [dbo].[SourceSystems] ADD [Password] [varchar](100) NULL
ALTER TABLE [dbo].[SourceSystems] ADD [MarkingGroup] [nvarchar](50) NOT NULL
ALTER TABLE [dbo].[SourceSystems] ADD  CONSTRAINT [PK_SourceSystems] PRIMARY KEY CLUSTERED 
(
	[SourceSystemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ServiceHeartBeats]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ServiceHeartBeats](
	[ServiceHeartBeatID] [int] IDENTITY(1,1) NOT NULL,
	[CommaDelimCommandIds] [varchar](50) NULL,
	[Delimeter] [char](1) NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_ServiceHeartBeats] PRIMARY KEY CLUSTERED 
(
	[ServiceHeartBeatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ServiceCommands]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ServiceCommands](
	[ServiceCommandID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NULL,
	[CommandName] [varchar](100) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_ServiceCommands] PRIMARY KEY CLUSTERED 
(
	[ServiceCommandID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SynonymSourceR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SynonymSourceR](
	[SynonymSourceID] [int] NOT NULL,
	[SourceOID] [varchar](50) NULL,
 CONSTRAINT [PK_SynonymSourceR] PRIMARY KEY CLUSTERED 
(
	[SynonymSourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SynonymProvisionalStorage]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SynonymProvisionalStorage](
	[SegmentedGroupCodingPatternID] [bigint] NOT NULL,
	[SynonymManagementID] INT NOT NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_SynonymProvisionalStorage] PRIMARY KEY CLUSTERED 
(
	[SegmentedGroupCodingPatternID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SynonymMigrationStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SynonymMigrationStatusR](
	[OID] [varchar](50) NULL,
	[SynonymMigrationStatus] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SynonymMigrationMngmt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[SynonymMigrationMngmt](
	[SynonymMigrationMngmtID] [int] IDENTITY(1,1) NOT NULL,
	[SegmentID] [int] NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[FromVersionOrdinal] [int] NOT NULL,
	[Locale] [char](3) NOT NULL,
	[ToVersionOrdinal] [int] NOT NULL,
	[SynonymMigrationStatusRID] [int] NOT NULL,
	[NumberOfSynonyms] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[IsSynonymListLoadedFromFile] [bit] NOT NULL,
	[MigrationOrLoadStartDate] [datetime] NULL,
	[MigrationOrLoadEndDate] [datetime] NULL,
	[ActivationDate] [datetime] NULL,
	[MigrationUserId] [int] NULL,
	[ActivationUserId] [int] NULL,
 CONSTRAINT [PK_SynonymMigrationMngmt] PRIMARY KEY CLUSTERED 
(
	[SynonymMigrationMngmtID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserGroups]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroups](
	[UserGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Permissions] [int] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[GroupNameID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserGroups] PRIMARY KEY CLUSTERED 
(
	[UserGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAddresses]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[UserAddresses](
	[UserAddressID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[IsPrimaryAddress] [bit] NOT NULL,
	[Email] [nvarchar](255) NULL,
	[Telephone] [nvarchar](32) NULL,
	[Facsimile] [nvarchar](32) NULL,
	[Pager] [nvarchar](32) NULL,
	[MobileNumber] [nvarchar](32) NULL,
	[TimeZone] [int] NULL,
	[NetworkMask] [varchar](255) NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[AddressLine3] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[Country] [nvarchar](255) NULL,
	[URL] [nvarchar](255) NULL,
	[Active] [bit] NOT NULL,
	[InstitutionName] [nvarchar](255) NULL,
	[LocationName] [nvarchar](255) NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_UserAddresses] PRIMARY KEY CLUSTERED 
(
	[UserAddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UNIT]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UNIT](
	[Unit_Id] [nvarchar](10) NOT NULL,
	[Text] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_UNIT] PRIMARY KEY CLUSTERED 
(
	[Unit_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersBackup]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersBackup](
	[UserID] [int] NOT NULL,
	[InitialSiteGroupID] [int] NOT NULL,
	[InvestigatorNumber] [int] NULL,
	[IsInvestigator] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[THG]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THG](
	[Therapgroup_Id] [int] NOT NULL,
	[ATCCode] [nvarchar](10) NULL,
	[CreateDate] [nvarchar](8) NULL,
	[OfficialATCCode] [nvarchar](1) NULL,
	[Medicinalprod_Id] [int] NULL,
	[ATCCode_] [nvarchar](110) NOT NULL,
	[ATCTermID] [int] NOT NULL,
	[MPTermID] [int] NOT NULL,
 CONSTRAINT [PK_THG] PRIMARY KEY CLUSTERED 
(
	[Therapgroup_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TherapeuticAreaR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TherapeuticAreaR](
	[TherapeuticAreaID] [int] NOT NULL,
	[TherapeuticAreaName] [varchar](500) NOT NULL,
 CONSTRAINT [PK_TherapeuticAreaR] PRIMARY KEY CLUSTERED 
(
	[TherapeuticAreaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_TherapeuticArea_Name] UNIQUE NONCLUSTERED 
(
	[TherapeuticAreaName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ImpactAnalysisVersionDifference]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImpactAnalysisVersionDifference](
	[MedicalDictionaryID] [smallint] NOT NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
	[Locale] [tinyint] NOT NULL,
	[OldTermID] [int] NOT NULL,
	[ImpactAnalysisChangeTypeId] [tinyint] NOT NULL,
	[FinalTermID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImpactAnalysisChangeTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ImpactAnalysisChangeTypeR](
	[ImpactAnalysisChangeTypeID] [int] NOT NULL,
	[OID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ImpactAnalysisChangeTypeR] PRIMARY KEY CLUSTERED 
(
	[ImpactAnalysisChangeTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HelpContexts]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HelpContexts](
	[HelpContextId] [int] IDENTITY(1,1) NOT NULL,
	[HelpContext] [varchar](50) NOT NULL,
	[HelpPage] [nvarchar](200) NULL,
	[IsWindowsMedia] [bit] NOT NULL,
	[WindowsMediaSource] [nvarchar](100) NULL,
	[CaptivateIndex] [nvarchar](200) NULL,
	[CaptivatePlaylist] [nvarchar](100) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_HelpContexts] PRIMARY KEY CLUSTERED 
(
	[HelpContextId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ING_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ING_B](
	[DrugRecordNumber] [nvarchar](6) NOT NULL,
	[SequenceNumber1] [nvarchar](2) NOT NULL,
	[SequenceNumber2] [nvarchar](3) NOT NULL,
	[CheckDigit] [nvarchar](1) NOT NULL,
	[CASNumber] [nvarchar](10) NOT NULL,
	[LanguageCode] [nvarchar](2) NOT NULL,
	[SubstanceName] [nvarchar](45) NOT NULL,
	[SourceYear] [nvarchar](3) NOT NULL,
	[SourceCode] [nvarchar](4) NOT NULL,
	[Source_Name] [nvarchar](70) NOT NULL,
	[Source_CountryCode] [nvarchar](3) NOT NULL,
	[Source_CountryName] [nvarchar](30) NOT NULL,
	[MedicinalProd_Id] [nvarchar](max) NULL,
	[TermID] [int] NOT NULL,
	[DDTermID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ING]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ING](
	[Ingredient_Id] [int] NOT NULL,
	[IngredientCreateDate] [nvarchar](8) NOT NULL,
	[Quantity] [nvarchar](15) NOT NULL,
	[Quantity2] [nvarchar](15) NOT NULL,
	[Unit_Id] [nvarchar](10) NOT NULL,
	[Unit] [nvarchar](20) NULL,
	[Medicinalprod_Id] [int] NOT NULL,
	[Pharmproduct_Id] [int] NOT NULL,
	[Pharmform_Id] [varchar](5) NULL,
	[Pharmform] [nvarchar](80) NULL,
	[RouteOfAdministration] [nvarchar](10) NULL,
	[NumberOfIngredients] [nvarchar](4) NULL,
	[PharmProductCreateDate] [nvarchar](8) NULL,
	[Substance_Id] [int] NOT NULL,
	[SubstanceName] [nvarchar](110) NULL,
	[CASNumber] [nvarchar](15) NULL,
	[LanguageCode] [nvarchar](10) NULL,
	[SourceYear] [nvarchar](3) NULL,
	[SourceCode] [nvarchar](10) NULL,
	[Source] [nvarchar](200) NULL,
	[SourceCountryCode] [varchar](3) NULL,
	[SourceCountryName] [varchar](80) NULL,
	[TermID] [int] NOT NULL,
	[ParentTermID] [int] NOT NULL,
 CONSTRAINT [PK_ING] PRIMARY KEY CLUSTERED 
(
	[Ingredient_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[INA_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INA_B](
	[ATCCode] [nvarchar](7) NOT NULL,
	[Level] [nvarchar](1) NOT NULL,
	[Text] [nvarchar](50) NOT NULL,
	[ParentATCCode] [nvarchar](10) NOT NULL,
	[TermID] [int] NOT NULL,
	[ParentTermID] [int] NOT NULL,
 CONSTRAINT [PK_INA_B] PRIMARY KEY CLUSTERED 
(
	[ATCCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExternalObjectTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExternalObjectTypeR](
	[ExternalObjectTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectFullName] [varchar](200) NOT NULL,
	[ObjectTypeName] [varchar](200) NULL,
	[AssemblyName] [varchar](1000) NULL,
 CONSTRAINT [PK_ExternalObjectTypeR] PRIMARY KEY CLUSTERED 
(
	[ExternalObjectTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_ExternalObjectTypeID_Name] UNIQUE NONCLUSTERED 
(
	[ObjectTypeName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HealthChecksR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HealthChecksR](
	[HealthCheckID] [bigint] IDENTITY(1,1) NOT NULL,
	[SP_Detect] [varchar](256) NOT NULL,
	[SP_Fix] [varchar](256) NOT NULL,
	[Description] [varchar](256) NOT NULL,
	[IsValid] [bit] NOT NULL,
 CONSTRAINT [PK_HealthChecksR_HealthCheckID] PRIMARY KEY CLUSTERED 
(
	[HealthCheckID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_HealthChecksR_Description] UNIQUE NONCLUSTERED 
(
	[Description] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InteractionStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InteractionStatusR](
	[InteractionStatus] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
 CONSTRAINT [PK_InteractionStatusR] PRIMARY KEY CLUSTERED 
(
	[InteractionStatus] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LclDataStringProperties]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LclDataStringProperties](
	[PropertyID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyName] [nvarchar](100) NOT NULL,
	[ObjectTypeID] [tinyint] NOT NULL,
 CONSTRAINT [PK_LclDataStringProperties] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNQ_PropertyName_ObjectTypeID] UNIQUE NONCLUSTERED 
(
	[PropertyName] ASC,
	[ObjectTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DictionarySpecificLogic]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DictionarySpecificLogic](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryType] [varchar](50) NOT NULL,
	[Locale] [char](3) NOT NULL,
	[DropAndCreateStagingTablesSP] [varchar](250) NOT NULL,
	[PopulateStagingTablesSP] [varchar](250) NOT NULL,
	[LoadVersionSP] [varchar](250) NOT NULL,
	[CreateFirstVersionSP] [varchar](250) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_DictionarySpecificLogic] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LocalizedDataStrings]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LocalizedDataStrings](
	[UniqueID] [int] IDENTITY(1,1) NOT NULL,
	[StringID] [int] NOT NULL,
	[String] [nvarchar](4000) NOT NULL,
	[Locale] [char](3) NOT NULL,
	[Updated] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[TranslationStatus] [int] NOT NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_LocalizedDataStrings] PRIMARY KEY NONCLUSTERED 
(
	[UniqueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedDictComponentVerUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictComponentVerUpdates](
	[ComponentVersionUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[InitialTermComponentID] [int] NULL,
	[VersionTermComponentID] [int] NOT NULL,
	[FinalTermComponentID] [int] NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
	[Locale] [tinyint] NOT NULL,
	[ChangeTypeID] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictComponentVerUpdates] PRIMARY KEY CLUSTERED 
(
	[ComponentVersionUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictComponentUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictComponentUpdates](
	[ComponentUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[InitialTermComponentID] [int] NULL,
	[VersionTermComponentID] [int] NOT NULL,
	[FinalTermComponentID] [int] NULL,
	[FromVersionOrdinal] [tinyint] NOT NULL,
	[ToVersionOrdinal] [tinyint] NOT NULL,
	[Locale] [tinyint] NOT NULL,
	[ChangeTypeID] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictComponentUpdates] PRIMARY KEY CLUSTERED 
(
	[ComponentUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MAN_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAN_B](
	[CompanyCode] [nvarchar](5) NOT NULL,
	[Name] [nvarchar](70) NOT NULL,
	[CountryCode] [nvarchar](3) NULL,
 CONSTRAINT [PK_MAN_B] PRIMARY KEY CLUSTERED 
(
	[CompanyCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogMessages]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LogMessages](
	[LogMessageID] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Category] [varchar](200) NOT NULL,
	[Thread] [varchar](255) NOT NULL,
	[Level] [varchar](50) NOT NULL,
	[Logger] [varchar](255) NOT NULL,
	[Message] [varchar](4000) NOT NULL,
	[Exception] [varchar](4000) NULL,
 CONSTRAINT [PK_LogMessages] PRIMARY KEY CLUSTERED 
(
	[LogMessageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LoginAttempts]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LoginAttempts](
	[AttemptID] [int] IDENTITY(1,1) NOT NULL,
	[LoginName] [nvarchar](50) NOT NULL,
	[LoginID] [int] NULL,
	[Attempted] [datetime] NOT NULL,
	[NetworkAddress] [varchar](255) NOT NULL,
	[Success] [smallint] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[Guid] [char](36) NOT NULL,
 CONSTRAINT [PK_LoginAttempts] PRIMARY KEY CLUSTERED 
(
	[AttemptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictionaryLevel]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictionaryLevel](
	[DictionaryLevelId] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[MandatoryLevel] [bit] NOT NULL,
	[CodingLevel] [bit] NOT NULL,
	[PreferredLevel] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[MedicalDictionaryLevel] ADD [ImageUrl] [varchar](50) NULL
ALTER TABLE [dbo].[MedicalDictionaryLevel] ADD [DefaultLevel] [bit] NOT NULL
ALTER TABLE [dbo].[MedicalDictionaryLevel] ADD  CONSTRAINT [PK_MedicalDictionaryLevel] PRIMARY KEY CLUSTERED 
(
	[DictionaryLevelId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictionaryAlgorithm]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictionaryAlgorithm](
	[MedicalDictionaryAlgorithmID] [int] NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[SelectThreshold] [float] NOT NULL,
	[SuggestThreshold] [float] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictionaryAlgorithm] PRIMARY KEY CLUSTERED 
(
	[MedicalDictionaryAlgorithmID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictionary]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictionary](
	[MedicalDictionaryId] [smallint] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SupportsPrimaryPath] [bit] NOT NULL,
 CONSTRAINT [PK_MedicalDictionary] PRIMARY KEY CLUSTERED 
(
	[MedicalDictionaryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictComponentTypes]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictComponentTypes](
	[ComponentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
 CONSTRAINT [PK_MedicalDictComponentTypes] PRIMARY KEY CLUSTERED 
(
	[ComponentTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Meddra_spec_pt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_spec_pt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_spec]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_spec](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL,
	[Col4] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_soc_hlgt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_soc_hlgt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_soc]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_soc](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL,
	[Col4] [nvarchar](255) NULL,
	[Col5] [nvarchar](255) NULL,
	[Col6] [nvarchar](255) NULL,
	[Col7] [nvarchar](255) NULL,
	[Col8] [nvarchar](255) NULL,
	[Col9] [nvarchar](255) NULL,
	[Col10] [nvarchar](255) NULL,
	[Col11] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_pt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_pt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL,
	[Col4] [nvarchar](255) NULL,
	[Col5] [nvarchar](255) NULL,
	[Col6] [nvarchar](255) NULL,
	[Col7] [nvarchar](255) NULL,
	[Col8] [nvarchar](255) NULL,
	[Col9] [nvarchar](255) NULL,
	[Col10] [nvarchar](255) NULL,
	[Col11] [nvarchar](255) NULL,
	[Col12] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_mdhier]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_mdhier](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL,
	[Col4] [nvarchar](255) NULL,
	[Col5] [nvarchar](255) NULL,
	[Col6] [nvarchar](255) NULL,
	[Col7] [nvarchar](255) NULL,
	[Col8] [nvarchar](255) NULL,
	[Col9] [nvarchar](255) NULL,
	[Col10] [nvarchar](255) NULL,
	[Col11] [nvarchar](255) NULL,
	[Col12] [nvarchar](255) NULL,
	[Col13] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_llt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_llt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL,
	[Col4] [nvarchar](255) NULL,
	[Col5] [nvarchar](255) NULL,
	[Col6] [nvarchar](255) NULL,
	[Col7] [nvarchar](255) NULL,
	[Col8] [nvarchar](255) NULL,
	[Col9] [nvarchar](255) NULL,
	[Col10] [nvarchar](255) NULL,
	[Col11] [nvarchar](255) NULL,
	[Col12] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_intl_ord]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_intl_ord](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_hlt_pt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_hlt_pt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_hlt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_hlt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL,
	[Col4] [nvarchar](255) NULL,
	[Col5] [nvarchar](255) NULL,
	[Col6] [nvarchar](255) NULL,
	[Col7] [nvarchar](255) NULL,
	[Col8] [nvarchar](255) NULL,
	[Col9] [nvarchar](255) NULL,
	[Col10] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_hlgt_hlt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_hlgt_hlt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Meddra_hlgt]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meddra_hlgt](
	[Col1] [nvarchar](255) NULL,
	[Col2] [nvarchar](255) NULL,
	[Col3] [nvarchar](255) NULL,
	[Col4] [nvarchar](255) NULL,
	[Col5] [nvarchar](255) NULL,
	[Col6] [nvarchar](255) NULL,
	[Col7] [nvarchar](255) NULL,
	[Col8] [nvarchar](255) NULL,
	[Col9] [nvarchar](255) NULL,
	[Col10] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictVerTermComponents]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictVerTermComponents](
	[TermComponentID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[ComponentTypeID] [tinyint] NULL,
	[TermID] [int] NOT NULL,
	[ENGStringID] [int] NOT NULL,
	[JPNStringID] [int] NOT NULL,
	[LOCStringID] [int] NOT NULL,
	[DictionaryVersionOrdinal] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictVerTermComponentValues] PRIMARY KEY CLUSTERED 
(
	[TermComponentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingStatusR](
	[CodingStatusID] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Complete] [bit] NOT NULL,
	[Coded] [bit] NOT NULL,
 CONSTRAINT [PK_CodingStatusR] PRIMARY KEY CLUSTERED 
(
	[CodingStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingSourceTermSupplementals]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingSourceTermSupplementals](
	[SourceTermSupplementalID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingSourceTermID] [bigint] NOT NULL,
	[SearchOperator] [int] NOT NULL,
	[SupplementalValue] [nvarchar](1000) NOT NULL,
	[SupplementTermKey] [nvarchar](100) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_CodingSourceTermSupplementals] PRIMARY KEY CLUSTERED 
(
	[SourceTermSupplementalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingSourceTermReferences]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingSourceTermReferences](
	[SourceTermReferenceId] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingSourceTermId] [bigint] NOT NULL,
	[ReferenceName] [nvarchar](50) NOT NULL,
	[ReferenceValue] [nvarchar](1500) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_CodingSourceTermReferences] PRIMARY KEY CLUSTERED 
(
	[SourceTermReferenceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingSourceTermComponents]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingSourceTermComponents](
	[SourceTermComponentID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingSourceTermID] [bigint] NOT NULL,
	[ComponentTypeID] [int] NOT NULL,
	[ComponentName] [nvarchar](50) NOT NULL,
	[ComponentValue] [nvarchar](2000) NOT NULL,
	[SearchType] [int] NOT NULL,
	[SearchOperator] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_CodingSourceTermComponents] PRIMARY KEY CLUSTERED 
(
	[SourceTermComponentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComponentLocStrings]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComponentLocStrings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
 CONSTRAINT [PK_ComponentLocStrings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComponentJpnStrings]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComponentJpnStrings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
 CONSTRAINT [PK_ComponentJpnStrings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComponentEngStrings]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComponentEngStrings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
 CONSTRAINT [PK_ComponentEngStrings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CommunicationLogs]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommunicationLogs](
	[CommunicationLogID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NULL,
	[WebURL] [nvarchar](1000) NOT NULL,
	[IMedidataAppId] [int] NOT NULL,
	[TransmissionStarted] [datetime] NOT NULL,
	[WebTimeDuration] [int] NOT NULL,
	[OtherTimeDuration1] [int] NULL,
	[OtherTimeDuration2] [int] NULL,
	[OtherTimeDuration3] [int] NULL,
	[HttpStatusCode] [int] NOT NULL,
	[ErrorData] [nvarchar](1000) NOT NULL,
	[WebTransmissionSize] [int] NOT NULL,
	[WebTransmissionTypeId] [int] NOT NULL,
	[IsSecurityCheckOK] [bit] NOT NULL,
	[IsMessageParsedOK] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CommunicationLogs] PRIMARY KEY CLUSTERED 
(
	[CommunicationLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingTransmissions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingTransmissions](
	[CodingTransmissionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingSourceTermID] [bigint] NOT NULL,
	[CodingRequestId] [bigint] NOT NULL,
	[TransmissionDate] [datetime] NOT NULL,
	[TransmissionSuccess] [bit] NOT NULL,
	[Acknowledged] [bit] NOT NULL,
	[AcknowledgeDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingTransmissions] PRIMARY KEY CLUSTERED 
(
	[CodingTransmissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DDSOURCE_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DDSOURCE_B](
	[SourceCode] [nvarchar](4) NOT NULL,
	[Source] [nvarchar](70) NOT NULL,
	[CountryCode] [nvarchar](3) NULL,
 CONSTRAINT [PK_DDSOURCE_B] PRIMARY KEY CLUSTERED 
(
	[SourceCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DDA_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DDA_B](
	[DrugRecordNumber] [nvarchar](6) NULL,
	[SequenceNumber1] [nvarchar](2) NULL,
	[SequenceNumber2] [nvarchar](3) NULL,
	[CheckDigit] [nvarchar](1) NULL,
	[ATCCode] [nvarchar](7) NOT NULL,
	[YearQuarter] [nvarchar](3) NULL,
	[OfficialATCCode] [nvarchar](1) NOT NULL,
	[ATCCode_Level] [nvarchar](1) NOT NULL,
	[ATCCode_Text] [nvarchar](50) NOT NULL,
	[ParentATCCode] [nvarchar](7) NOT NULL,
	[MedicinalProd_Id] [nvarchar](max) NULL,
	[DDTermID] [int] NOT NULL,
	[ATCTermID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DD_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DD_B](
	[DrugRecordNumber] [nvarchar](6) NOT NULL,
	[SequenceNumber1] [nvarchar](2) NOT NULL,
	[SequenceNumber2] [nvarchar](3) NOT NULL,
	[CheckDigit] [nvarchar](1) NOT NULL,
	[Designation] [nvarchar](1) NOT NULL,
	[SourceYear] [nvarchar](2) NOT NULL,
	[SourceCode] [nvarchar](4) NOT NULL,
	[CompanyCode] [nvarchar](5) NOT NULL,
	[NumberOfIngredients] [nvarchar](2) NOT NULL,
	[SaltEsterCode] [nvarchar](1) NOT NULL,
	[YearQuarter] [nvarchar](3) NOT NULL,
	[DrugName] [nvarchar](45) NOT NULL,
	[Company_Name] [nvarchar](70) NOT NULL,
	[Company_CountryCode] [nvarchar](3) NOT NULL,
	[Company_CountryName] [nvarchar](30) NOT NULL,
	[Source_Name] [nvarchar](70) NOT NULL,
	[Source_CountryCode] [nvarchar](3) NOT NULL,
	[Source_CountryName] [nvarchar](30) NOT NULL,
	[MedicinalProd_Id] [nvarchar](max) NULL,
	[TermID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CronActions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CronActions](
	[CronActionID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NULL,
	[CronActionName] [varchar](100) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CronActions] PRIMARY KEY CLUSTERED 
(
	[CronActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CodingElementGroupSupplementals]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingElementGroupSupplementals](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingElementGroupID] [bigint] NOT NULL,
	[SearchOperator] [int] NOT NULL,
	[SupplementalValue] [nvarchar](1000) NOT NULL,
	[SupplementTermKey] [nvarchar](100) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingElementGroupSupplementals] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingElementGroups]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CodingElementGroups](
	[CodingElementGroupID] [int] IDENTITY(1,1) NOT NULL,
	[VerbatimText] [nvarchar](450) NOT NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[DictionaryLevelID] [smallint] NOT NULL,
	[DictionaryLocale] [char](3) NOT NULL,
	[SegmentID] [smallint] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[HasComponents] [bit] NOT NULL,
	[ProgrammaticAuxiliary] [bigint] NOT NULL,
	[HasSupplements] [bit] NULL,
 CONSTRAINT [PK_CodingElementGroups] PRIMARY KEY CLUSTERED 
(
	[CodingElementGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CodingElementGroupComponents]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingElementGroupComponents](
	[CodingElementGroupComponentID] [int] IDENTITY(1,1) NOT NULL,
	[CodingElementGroupID] [int] NOT NULL,
	[ComponentTypeID] [smallint] NOT NULL,
	[NameText] [nvarchar](450) NULL,
	[CodeText] [nvarchar](50) NULL,
	[SearchType] [int] NULL,
	[SearchOperator] [int] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingElementGroupComponents] PRIMARY KEY CLUSTERED 
(
	[CodingElementGroupComponentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingReasonR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingReasonR](
	[CodingReasonID] [int] NOT NULL,
	[CodingReason] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CodingReasonR] PRIMARY KEY CLUSTERED 
(
	[CodingReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingPatterns]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CodingPatterns](
	[CodingPatternID] [bigint] IDENTITY(1,1) NOT NULL,
	[DictionaryLocale] [char](3) NOT NULL,
	[IsPrimaryPath] [bit] NOT NULL,
	[MedicalDictionaryTermID] [bigint] NOT NULL,
	[CodingPath] [varchar](300) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingPatterns] PRIMARY KEY CLUSTERED 
(
	[CodingPatternID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CodingInclusionTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingInclusionTypeR](
	[CodingInclusionTypeID] [int] NOT NULL,
	[CodingInclusionType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CodingInclusionTypeR] PRIMARY KEY CLUSTERED 
(
	[CodingInclusionTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditTypeR](
	[AuditTypeId] [int] NOT NULL,
	[AuditType] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_AuditTypeR] PRIMARY KEY CLUSTERED 
(
	[AuditTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingActionR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingActionR](
	[CodingActionID] [int] NOT NULL,
	[CodingAction] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CodingActionR] PRIMARY KEY CLUSTERED 
(
	[CodingActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CoderSegmentTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CoderSegmentTypeR](
	[CoderSegmentTypeID] [int] NOT NULL,
	[CoderSegmentTypeName] [varchar](500) NOT NULL,
 CONSTRAINT [PK_CoderSegmentTypeR] PRIMARY KEY CLUSTERED 
(
	[CoderSegmentTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_CoderSegmentTypeR_Name] UNIQUE NONCLUSTERED 
(
	[CoderSegmentTypeName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CoderLocaleAddlInfo]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CoderLocaleAddlInfo](
	[ID] [tinyint] NOT NULL,
	[Locale] [char](3) NOT NULL,
	[LCID_Number] [int] NULL,
	[LocaleOffsetForIOR] [int] NULL,
 CONSTRAINT [PK_CoderLocaleAddlInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CCODE_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCODE_B](
	[CountryCode] [nvarchar](3) NOT NULL,
	[CountryName] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_CCODE_B] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCODE]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCODE](
	[CountryCode] [nvarchar](10) NOT NULL,
	[CountryName] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_CCODE] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BNA_B]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BNA_B](
	[CASNumber] [nvarchar](10) NOT NULL,
	[LanguageCode] [nvarchar](2) NOT NULL,
	[SubstanceName] [nvarchar](45) NOT NULL,
	[SourceYear] [nvarchar](2) NULL,
	[SourceCode] [nvarchar](4) NULL,
	[Source_Name] [nvarchar](70) NOT NULL,
	[Source_CountryCode] [nvarchar](3) NOT NULL,
	[Source_CountryName] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_BNA_B] PRIMARY KEY CLUSTERED 
(
	[CASNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BitMaskLookup]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BitMaskLookup](
	[BitPosition] [int] NULL,
	[BitMask] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AutoCodeStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoCodeStatusR](
	[AutoCodeStatusID] [int] NOT NULL,
	[AutoCodeStatus] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_AutoCodeStatusR] PRIMARY KEY CLUSTERED 
(
	[AutoCodeStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditCategories]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditCategories](
	[AuditCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[AuditCategoryName] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_AuditCategories] PRIMARY KEY CLUSTERED 
(
	[AuditCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ATC]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATC](
	[ATCCode] [nvarchar](10) NOT NULL,
	[Level] [nvarchar](1) NOT NULL,
	[Text] [nvarchar](110) NOT NULL,
	[ParentATCCode] [nvarchar](10) NOT NULL,
	[TermID] [int] NOT NULL,
	[ParentTermID] [int] NOT NULL,
 CONSTRAINT [PK_ATC] PRIMARY KEY CLUSTERED 
(
	[ATCCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicationType]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationType](
	[ApplicationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[IMedidataId] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[IsCoderAppType] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_ApplicationType] PRIMARY KEY CLUSTERED 
(
	[ApplicationTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditProcesses]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditProcesses](
	[AuditProcessId] [int] IDENTITY(1,1) NOT NULL,
	[AuditProcess] [nvarchar](500) NOT NULL,
	[IsDefault] [bit] NULL,
 CONSTRAINT [PK_AuditProcesses] PRIMARY KEY CLUSTERED 
(
	[AuditProcessId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicationR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationR](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ApplicationR] PRIMARY KEY CLUSTERED 
(
	[ApplicationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActionTypeR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionTypeR](
	[ActionType] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ActionTypeR] PRIMARY KEY CLUSTERED 
(
	[ActionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActionGroup]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActionGroup](
	[ActionGroupId] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NULL,
 CONSTRAINT [PK_ActionGroup] PRIMARY KEY CLUSTERED 
(
	[ActionGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ActivationStatusR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivationStatusR](
	[ActivationStatus] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
 CONSTRAINT [PK_ActivationStatusR] PRIMARY KEY CLUSTERED 
(
	[ActivationStatus] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApiClients]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApiClients](
	[ApiClientID] [int] IDENTITY(1,1) NOT NULL,
	[CertIssuers] [varchar](4000) NULL,
	[CanCreateUsers] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
 CONSTRAINT [PK_ApiClient] PRIMARY KEY CLUSTERED 
(
	[ApiClientID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Activations]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Activations](
	[ActivationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ActivationCode] [char](8) NOT NULL,
	[Created] [datetime] NULL,
	[Attempts] [int] NULL,
	[Activated] [datetime] NULL,
	[LastAttempt] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
	[ActivationStatus] [int] NOT NULL,
	[Completed] [bit] NOT NULL,
	[AlertSent] [bit] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Activations] PRIMARY KEY CLUSTERED 
(
	[ActivationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Activations] UNIQUE NONCLUSTERED 
(
	[ActivationCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Application]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Application](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[ApiID] [nvarchar](256) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[BaseUrl] [nvarchar](2000) NOT NULL,
	[PublicKey] [nvarchar](500) NOT NULL,
	[ApplicationTypeID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SourceSystemID] [int] NOT NULL,
 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[ApplicationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditSources]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AuditSources](
	[AuditSourceId] [bigint] IDENTITY(1,1) NOT NULL,
	[AuditSourceTime] [datetime] NOT NULL,
	[AuditedObjectTypeId] [int] NOT NULL,
	[AuditedObjectId] [bigint] NOT NULL,
	[InteractionId] [int] NULL,
	[Host] [varchar](50) NOT NULL,
	[ThreadName] [varchar](200) NOT NULL,
	[AuditProcessId] [int] NOT NULL,
	[Product] [varchar](200) NULL,
	[Process] [varchar](200) NULL,
	[AuditReasonNote] [nvarchar](200) NULL,
	[SegmentID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_AuditSources] PRIMARY KEY CLUSTERED 
(
	[AuditSourceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Audits]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Audits](
	[AuditId] [bigint] IDENTITY(1,1) NOT NULL,
	[AuditSourceId] [bigint] NOT NULL,
	[AuditUserId] [int] NOT NULL,
	[AuditTime] [datetime] NOT NULL,
	[AuditDetailTypeId] [int] NOT NULL,
	[BeforeData] [nvarchar](2000) NULL,
	[NewData] [nvarchar](2000) NULL,
	[PropertyName] [varchar](50) NULL,
	[AuditedObjectId] [bigint] NOT NULL,
	[AuditedObjectTypeId] [bigint] NOT NULL,
	[AuditRefernaceObjectId] [bigint] NULL,
	[AuditRefernaceObjectTypeId] [int] NULL,
	[ManualText] [nvarchar](2000) NULL,
	[Detail1] [nvarchar](2000) NULL,
	[Detail2] [nvarchar](2000) NULL,
	[Detail3] [nvarchar](2000) NULL,
	[Detail4] [nvarchar](2000) NULL,
	[Detail5] [nvarchar](2000) NULL,
	[SegmentID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Audits] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AuditDetailTypes]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AuditDetailTypes](
	[AuditDetailTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectTypeId] [int] NULL,
	[PropertyName] [varchar](100) NULL,
	[TranslationStringName] [varchar](50) NULL,
	[AuditTypeId] [int] NULL,
	[AdditionalTrackingProperties] [varchar](4000) NULL,
 CONSTRAINT [PK_AuditDetailTypes] PRIMARY KEY CLUSTERED 
(
	[AuditDetailTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CoderSegments]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CoderSegments](
	[CoderSegmentId] [int] IDENTITY(1,1) NOT NULL,
	[SegmentId] [int] NOT NULL,
	[CoderSegmentOID] [varchar](50) NOT NULL,
	[CoderSegmentName] [varchar](500) NOT NULL,
	[CoderSegmentTypeId] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CoderSegments] PRIMARY KEY CLUSTERED 
(
	[CoderSegmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_CoderSegments] UNIQUE NONCLUSTERED 
(
	[CoderSegmentOID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AuthenticationSources]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthenticationSources](
	[AuthenticationSourceID] [int] NOT NULL,
	[AuthenticationSourceName] [nvarchar](255) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
 CONSTRAINT [PK_AuthenticationSources] PRIMARY KEY CLUSTERED 
(
	[AuthenticationSourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicationSourceSystems]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationSourceSystems](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowId] [int] NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[SourceSystemId] [int] NOT NULL,
 CONSTRAINT [PK_ApplicationSourceSystems] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Configuration](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Tag] [varchar](64) NOT NULL,
	[ConfigValue] [varchar](2000) NULL,
	[StudyID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CodingSuggestions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CodingSuggestions](
	[CodingSuggestionID] [int] IDENTITY(1,1) NOT NULL,
	[CodingElementID] [bigint] NOT NULL,
	[SegmentId] [int] NULL,
	[MedicalDictionaryTermID] [int] NOT NULL,
	[DictionaryVersionId] [int] NULL,
	[AlgorithmID] [int] NOT NULL,
	[MatchPercent] [decimal](18, 0) NULL,
	[IsSelected] [bit] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SuggestionReason] [varchar](50) NULL,
 CONSTRAINT [PK_CodingSuggestions] PRIMARY KEY CLUSTERED 
(
	[CodingSuggestionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CodingResourceTransmission]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingResourceTransmission](
	[CodingResourceTransmissionID] [bigint] IDENTITY(1,1) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[SourceSystemID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingResourceTransmission] PRIMARY KEY CLUSTERED 
(
	[CodingResourceTransmissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingRequests]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[CodingRequests](
	[CodingRequestId] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystemId] [int] NULL,
	[FileOID] [nvarchar](500) NULL,
	[CreationDateTime] [varchar](50) NULL,
	[XmlContent] [ntext] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NULL,
	[ReferenceNumber] [char](36) NULL,
	[BatchOID] [nvarchar](500) NULL,
 CONSTRAINT [PK_CodingRequests] PRIMARY KEY CLUSTERED 
(
	[CodingRequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedDictVerLvlComponents]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictVerLvlComponents](
	[MedDictVerLvlComponentID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[ComponentTypeID] [int] NOT NULL,
	[DictionaryLevelId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[DictionaryVersionOrdinal] [int] NOT NULL,
	[DefaultValue_ENG] [nvarchar](50) NOT NULL,
	[DefaultValue_JPN] [nvarchar](50) NOT NULL,
	[DefaultValue_LOC] [nvarchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedDictVerLvlComponents] PRIMARY KEY CLUSTERED 
(
	[MedDictVerLvlComponentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocalizedStrings]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LocalizedStrings](
	[StringID] [int] IDENTITY(1,1) NOT NULL,
	[StringName] [varchar](50) NOT NULL,
	[String] [nvarchar](2000) NOT NULL,
	[Locale] [char](3) NOT NULL,
	[StringTypeID] [int] NOT NULL,
	[ProductName] [varchar](4) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[TranslationStatus] [int] NOT NULL,
 CONSTRAINT [PK_LocalizedStrings] PRIMARY KEY CLUSTERED 
(
	[StringName] ASC,
	[ProductName] ASC,
	[Locale] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LocalizedDataStringPKs]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LocalizedDataStringPKs](
	[StringId] [int] IDENTITY(1,1) NOT NULL,
	[InsertedInLocale] [char](3) NULL,
	[SegmentID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StringId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Localizations]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Localizations](
	[Locale] [char](3) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[HelpFolder] [varchar](50) NULL,
	[NameFormat] [varchar](50) NULL,
	[NumberFormat] [varchar](50) NULL,
	[DateFormat] [varchar](50) NULL,
	[SubmitOnEnter] [bit] NOT NULL,
	[DescriptionID] [int] NOT NULL,
	[DateTimeFormat] [varchar](50) NULL,
	[Culture] [varchar](50) NULL,
	[LocaleID] [int] IDENTITY(1,1) NOT NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_LocaleID] PRIMARY KEY CLUSTERED 
(
	[LocaleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InstalledModules]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InstalledModules](
	[ModuleID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleAbbrev] [nvarchar](50) NOT NULL,
	[ModuleName] [varchar](50) NOT NULL,
	[Options] [int] NOT NULL,
	[FirstPage] [nvarchar](225) NOT NULL,
	[Active] [bit] NOT NULL,
	[Icon] [varchar](50) NULL,
	[HelpFile] [varchar](225) NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_InstalledModules] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_InstalledModules] UNIQUE NONCLUSTERED 
(
	[ModuleAbbrev] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_InstalledModules_1] UNIQUE NONCLUSTERED 
(
	[ModuleName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DeletedConfigurations]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeletedConfigurations](
	[ConfigurationID] [int] NOT NULL,
	[DeletedDate] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_DeletedConfigurations] PRIMARY KEY CLUSTERED 
(
	[ConfigurationID] ASC,
	[DeletedDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LclDataStringContexts]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LclDataStringContexts](
	[ContextID] [int] IDENTITY(1,1) NOT NULL,
	[ObjectTypeID] [int] NOT NULL,
 CONSTRAINT [PK_LclDataStringContexts] PRIMARY KEY CLUSTERED 
(
	[ContextID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HealthCheckRuns]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HealthCheckRuns](
	[HealthCheckRunID] [bigint] IDENTITY(1,1) NOT NULL,
	[HealthCheckID] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[TimeEnded] [datetime] NOT NULL,
 CONSTRAINT [PK_HealthCheckRuns_HealthCheckRunID] PRIMARY KEY CLUSTERED 
(
	[HealthCheckRunID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImpliedActionTypes]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImpliedActionTypes](
	[ActionType] [int] NOT NULL,
	[ImpliedActionType] [int] NOT NULL,
 CONSTRAINT [PK_ImpliedActionTypes] PRIMARY KEY CLUSTERED 
(
	[ActionType] ASC,
	[ImpliedActionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WelcomeMessageTags]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WelcomeMessageTags](
	[WelcomeMessageTagID] [int] IDENTITY(1,1) NOT NULL,
	[MessageTag] [nvarchar](50) NOT NULL,
	[SQLFunction] [varchar](100) NULL,
	[IsPriority] [bit] NOT NULL,
	[DescriptionStringId] [int] NULL,
	[Active] [bit] NOT NULL,
	[SQLArgument] [nvarchar](1000) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_WelcomeMessageTags] PRIMARY KEY CLUSTERED 
(
	[WelcomeMessageTagID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WelcomeMessages]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WelcomeMessages](
	[WelcomeMessageID] [int] IDENTITY(1,1) NOT NULL,
	[WelcomeMessage] [int] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[ShowAtTopLevel] [bit] NOT NULL,
	[ShowAtStudyLevel] [bit] NOT NULL,
	[ShowAtSiteLevel] [bit] NOT NULL,
	[AllRoles] [bit] NOT NULL,
	[AllStudies] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[PriorityTag] [nvarchar](50) NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
 CONSTRAINT [PK_WelcomeMessages] PRIMARY KEY CLUSTERED 
(
	[WelcomeMessageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VariableDictUseAlgorithm]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VariableDictUseAlgorithm](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryUseID] [int] NOT NULL,
	[CodingAlgorithmId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[SelectThreshold] [float] NOT NULL,
	[SuggestThreshold] [float] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_VariableDictUseAlgorithm_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VariableDictAssignment]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VariableDictAssignment](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[VariableID] [bigint] NOT NULL,
	[MedicalDictionaryUseID] [int] NOT NULL,
	[ComponentTypeID] [int] NOT NULL,
	[IsCodingVariable] [bit] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_VariableDictAssignment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserObjectRole]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserObjectRole](
	[UserObjectRoleId] [int] IDENTITY(1,1) NOT NULL,
	[GrantToObjectId] [int] NOT NULL,
	[GrantOnObjectId] [int] NOT NULL,
	[RoleID] [smallint] NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[GrantOnObjectTypeId] [int] NULL,
	[GrantToObjectTypeId] [int] NULL,
	[DenyObjectRole] [bit] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserStudyRole] PRIMARY KEY CLUSTERED 
(
	[UserObjectRoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserModules]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserModules](
	[ModuleID] [int] NOT NULL,
	[UserGroupID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserModules] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC,
	[UserGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransmissionQueueItems]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TransmissionQueueItems](
	[TransmissionQueueItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectTypeID] [int] NOT NULL,
	[ObjectID] [bigint] NOT NULL,
	[StudyOID] [varchar](50) NOT NULL,
	[TextToTransmit] [varchar](max) NULL,
	[FailureCount] [int] NOT NULL,
	[SuccessCount] [int] NOT NULL,
	[SourceSystemID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[CumulativeFailCount] [int] NOT NULL,
	[OutTransmissionID] [bigint] NOT NULL,
	[ServiceWillContinueSending] [bit] NOT NULL,
	[IsForUnloadService] [bit] NOT NULL,
 CONSTRAINT [PK_TransmissionQueueItemID] PRIMARY KEY CLUSTERED 
(
	[TransmissionQueueItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TrackableObjects]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[TrackableObjects](
	[TrackableObjectID] [bigint] IDENTITY(1,1) NOT NULL,
	[ExternalObjectTypeId] [bigint] NOT NULL,
	[ExternalObjectId] [nvarchar](50) NOT NULL,
	[ExternalObjectOID] [varchar](50) NULL,
	[ExternalObjectName] [nvarchar](2000) NULL,
	[ProtocolName] [nvarchar](2000) NULL,
	[SegmentId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[ExternalObjectNameId] [int] NULL,
	[TaskCounter] [bigint] NOT NULL,
	[IsTestStudy] [bit] NOT NULL,
 CONSTRAINT [PK_TrackableObjects] PRIMARY KEY CLUSTERED 
(
	[TrackableObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Timezones]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Timezones](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Bias] [int] NOT NULL,
	[StandardBias] [int] NOT NULL,
	[DaylightBias] [int] NOT NULL,
	[InUse] [bit] NOT NULL,
	[Default] [bit] NOT NULL,
	[TZI] [binary](44) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[KeyName] [varchar](255) NOT NULL,
	[StdDateYear] [int] NULL,
	[StdDateMonth] [int] NULL,
	[StdDateDayOfWeek] [int] NULL,
	[StdDateDay] [int] NULL,
	[StdDateHour] [int] NULL,
	[StdDateMinute] [int] NULL,
	[StdDateSecond] [int] NULL,
	[StdDateMillisecond] [int] NULL,
	[DaylightDateYear] [int] NULL,
	[DaylightDateMonth] [int] NULL,
	[DaylightDateDayOfWeek] [int] NULL,
	[DaylightDateDay] [int] NULL,
	[DaylightDateHour] [int] NULL,
	[DaylightDateMinute] [int] NULL,
	[DaylightDateSecond] [int] NULL,
	[DaylightDateMillisecond] [int] NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_Timezones] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SynonymMigrationEntries]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[SynonymMigrationEntries](
	[SynonymMigrationEntryID] [bigint] IDENTITY(1,1) NOT NULL,
	[SynonymMigrationMngmtID] [int] NOT NULL,
	[TermID] [bigint] NOT NULL,
	[FinalMasterTermID] [bigint] NULL,
	[SynonymMigrationStatusRID] [int] NOT NULL,
	[NewNodepath] [varchar](max) NOT NULL,
	[AreSuggestionsGenerated] [bit] NOT NULL,
	[NumberOfSuggestions] [int] NULL,
	[SuggestionCategoryType] [tinyint] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_SynonymMigrationEntries] PRIMARY KEY CLUSTERED 
(
	[SynonymMigrationEntryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ServiceCommandLogs]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceCommandLogs](
	[ServiceCommandLogID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NULL,
	[ServiceCommandID] [int] NOT NULL,
	[ServiceCommandParams] [nvarchar](max) NULL,
	[UserID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_ServiceCommandLogs] PRIMARY KEY CLUSTERED 
(
	[ServiceCommandLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolesAllModules]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RolesAllModules](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[RoleNameID] [int] NOT NULL,
	[ModuleId] [int] NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[OID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RolesAllModules] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleActions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleActions](
	[RoleActionID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [smallint] NOT NULL,
	[RestrictionMask] [bigint] NOT NULL,
	[RestrictionStatus] [bigint] NOT NULL,
	[GroupID] [int] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[ModuleActionId] [int] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_RoleActions] PRIMARY KEY CLUSTERED 
(
	[RoleActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ObjectSegments]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectSegments](
	[ObjectSegmentId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectId] [int] NOT NULL,
	[ObjectTypeId] [int] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[ReadOnly] [bit] NOT NULL,
	[DefaultSegment] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ObjectSegmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Messages]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Messages](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[MessageString] [nvarchar](1024) NOT NULL,
	[MessageStringID] [int] NOT NULL,
	[Send] [datetime] NOT NULL,
	[Subject] [nvarchar](255) NOT NULL,
	[Urgency] [int] NOT NULL,
	[WhoFrom] [nvarchar](50) NOT NULL,
	[Guid] [char](36) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[MessageStringKey] [varchar](50) NULL,
	[SubjectStringKey] [varchar](50) NULL,
	[StringParameters] [nvarchar](255) NULL,
	[SegmentID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SynonymHistory]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SynonymHistory](
	[SynonymHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[SynonymTermID] [bigint] NOT NULL,
	[PriorSynonymTermID] [bigint] NOT NULL,
	[SynonymActionID] [int] NOT NULL,
	[SynonymSourceID] [int] NULL,
	[UserID] [int] NOT NULL,
	[Comment] [nvarchar](100) NULL,
	[SegmentID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_SynonymHistory] PRIMARY KEY CLUSTERED 
(
	[SynonymHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SecurityGroup]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityGroup](
	[SecurityGroupID] [int] IDENTITY(1,1) NOT NULL,
	[SecurityGroupnameID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_SecurityGroup] PRIMARY KEY CLUSTERED 
(
	[SecurityGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpugPaths]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SpugPaths](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OriginatingObjectTypeId] [int] NOT NULL,
	[TargetObjectTypeId] [int] NOT NULL,
	[ThruObjectTypeIds] [varchar](500) NULL,
 CONSTRAINT [PK_SpugPaths] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [U_SpugPaths] UNIQUE NONCLUSTERED 
(
	[OriginatingObjectTypeId] ASC,
	[TargetObjectTypeId] ASC,
	[ThruObjectTypeIds] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictionaryTemplateLevels]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictionaryTemplateLevels](
	[TemplateLevelId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateId] [int] NOT NULL,
	[DictionaryLevelId] [int] NOT NULL,
	[Ordinal] [int] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_DictionaryTemplateLevels] PRIMARY KEY CLUSTERED 
(
	[TemplateLevelId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalDictionaryLevelMapping]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedicalDictionaryLevelMapping](
	[LevelMappingId] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[FromDictionaryLevelId] [int] NOT NULL,
	[ToDictionaryLevelId] [int] NOT NULL,
	[RelationshipType] [int] NOT NULL,
	[ExternalSQL] [nvarchar](max) NULL,
 CONSTRAINT [PK_MedicalDictionaryLevelMapping] PRIMARY KEY CLUSTERED 
(
	[LevelMappingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedDictSynonymWasteBasket]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MedDictSynonymWasteBasket](
	[MedDictSynonymWasteBasketID] [bigint] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[DictionaryLevelID] [int] NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[SynonymTerm] [nvarchar](450) NOT NULL,
	[SegmentID] [int] NOT NULL,
	[ToVersionOrdinal] [int] NOT NULL,
	[FromVersionOrdinal] [int] NOT NULL,
	[Locale] [char](3) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedDictSynonymWasteBasket] PRIMARY KEY CLUSTERED 
(
	[MedDictSynonymWasteBasketID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictTermComponents]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MedicalDictTermComponents](
	[TermComponentID] [int] IDENTITY(1,1) NOT NULL,
	[ComponentTypeID] [smallint] NULL,
	[TermID] [int] NOT NULL,
	[ENGStringID] [int] NOT NULL,
	[JPNStringID] [int] NOT NULL,
	[LOCStringID] [int] NOT NULL,
	[FromVersionOrdinal] [tinyint] NULL,
	[ToVersionOrdinal] [tinyint] NULL,
	[MasterTermComponentID] [int] NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
	[IORVersionLocaleValidity] [varbinary](100) NULL,
 CONSTRAINT [PK_MedicalDictionaryComponentValues] PRIMARY KEY CLUSTERED 
(
	[TermComponentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictLevelComponents]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MedicalDictLevelComponents](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ComponentTypeID] [int] NOT NULL,
	[DictionaryLevelId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[WhatToShow] [nvarchar](2000) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[DefaultValue_ENG] [varchar](50) NULL,
	[DefaultValue_JPN] [nvarchar](100) NOT NULL,
	[DefaultValue_LOC] [nvarchar](100) NOT NULL,
	[FromVersionOrdinal] [int] NULL,
	[ToVersionOrdinal] [int] NULL,
	[MasterLevelComponentID] [int] NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[IORVersionLocaleValidity] [varbinary](100) NULL,
 CONSTRAINT [PK_MedicalDictLevelComponents_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MedicalDictionaryVersionLevelRecursion]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictionaryVersionLevelRecursion](
	[MedicalDictionaryVersionLevelRecursionID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[VersionOrdinal] [int] NOT NULL,
	[DictionaryLevelID] [int] NOT NULL,
	[MaxRecursiveDepth] [tinyint] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictionaryVersionLevelRecursion] PRIMARY KEY CLUSTERED 
(
	[MedicalDictionaryVersionLevelRecursionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalDictionaryUseAlgorithm]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictionaryUseAlgorithm](
	[MedicalDictionaryUseAlgorithmID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryAlgorithmID] [int] NOT NULL,
	[MedicalDictionaryId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[SelectThresholD] [float] NOT NULL,
	[SuggestThresholD] [float] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictionaryUseAlgorithm_1] PRIMARY KEY CLUSTERED 
(
	[MedicalDictionaryUseAlgorithmID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalDictionaryTermRel]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictionaryTermRel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FromTermId] [int] NOT NULL,
	[ToTermId] [int] NOT NULL,
	[LevelMappingId] [smallint] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
	[RelationshipComments] [nvarchar](50) NOT NULL,
	[FromVersionOrdinal] [tinyint] NULL,
	[ToVersionOrdinal] [tinyint] NULL,
	[MedicalDictionaryID] [smallint] NOT NULL,
 CONSTRAINT [PK_MedicalDictionaryTermRel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalDictVerSegmentWorkflows]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalDictVerSegmentWorkflows](
	[MedicalDictVerSegmentWorkflowId] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictVerSegmentId] [int] NULL,
	[WorkflowId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_MedicalDictVerSegmentWorkflows] PRIMARY KEY CLUSTERED 
(
	[MedicalDictVerSegmentWorkflowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModulesR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ModulesR](
	[ModuleId] [tinyint] NOT NULL,
	[ModuleName] [varchar](100) NOT NULL,
	[ObjectTypeID] [int] NULL,
	[LoadFunction] [varchar](50) NULL,
	[Active] [bit] NOT NULL,
	[DenyObjectRoleID] [smallint] NULL,
	[UserDeactivated] [bit] NOT NULL,
 CONSTRAINT [PK_ModulesR] PRIMARY KEY CLUSTERED 
(
	[ModuleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ModulePages]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ModulePages](
	[Page] [varchar](500) NOT NULL,
	[Module] [varchar](50) NOT NULL,
	[GroupPermissions] [varchar](200) NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_ModulePages] PRIMARY KEY CLUSTERED 
(
	[Page] ASC,
	[Module] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectSegmentWorkflows]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectSegmentWorkflows](
	[ObjectSegmentWorkflowId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectSegmentId] [int] NULL,
	[WorkflowId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[IsDefaultWorkflow] [bit] NOT NULL,
	[IsProd] [bit] NOT NULL,
	[AllowWorkflowChange] [bit] NOT NULL,
 CONSTRAINT [PK_ObjectSegmentWorkflows] PRIMARY KEY CLUSTERED 
(
	[ObjectSegmentWorkflowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OutTransmissions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutTransmissions](
	[OutTransmissionID] [bigint] IDENTITY(1,1) NOT NULL,
	[SourceSystemID] [int] NOT NULL,
	[TransmissionTypeID] [int] NOT NULL,
	[Acknowledged] [bit] NOT NULL,
	[AcknowledgeDate] [datetime] NULL,
	[TransmissionSuccess] [bit] NOT NULL,
	[TransmissionDate] [datetime] NULL,
	[HttpStatusCode] [int] NULL,
	[WebExceptionStatus] [varchar](50) NULL,
	[TextToTransmit] [varchar](max) NULL,
	[ResponseText] [varchar](max) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_OutTransmissions] PRIMARY KEY CLUSTERED 
(
	[OutTransmissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WorkflowVariables]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowVariables](
	[WorkflowVariableID] [int] IDENTITY(1,1) NOT NULL,
	[VariableName] [nvarchar](50) NOT NULL,
	[DataFormat] [nvarchar](255) NULL,
	[WorkflowID] [int] NOT NULL,
	[DefaultValue] [nvarchar](500) NULL,
	[ExternalObjectId] [int] NULL,
	[SegmentId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowVariables] PRIMARY KEY CLUSTERED 
(
	[WorkflowVariableID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowSystemActionR]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSystemActionR](
	[WorkflowSystemActionID] [int] IDENTITY(1,1) NOT NULL,
	[ActionName] [nvarchar](255) NOT NULL,
	[ApplicationID] [int] NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_WorkflowSystemActionR] PRIMARY KEY CLUSTERED 
(
	[WorkflowSystemActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowStates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowStates](
	[WorkflowStateID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowStateNameID] [int] NOT NULL,
	[WorkflowStateIconID] [int] NULL,
	[WorkflowID] [int] NOT NULL,
	[IsStartState] [bit] NULL,
	[IsTerminalState] [bit] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[IsReconsiderState] [bit] NOT NULL,
	[Ordinal] [int] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowStates] PRIMARY KEY CLUSTERED 
(
	[WorkflowStateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowReasons]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowReasons](
	[WorkflowReasonID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[ReasonNameId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowReasons] PRIMARY KEY CLUSTERED 
(
	[WorkflowReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowActions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[WorkflowActions](
	[WorkflowActionID] [int] IDENTITY(1,1) NOT NULL,
	[OID] [varchar](50) NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[NameID] [int] NOT NULL,
	[IsAutoAllowed] [bit] NULL,
	[IsManualAllowed] [bit] NULL,
	[ReasonRequiredType] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[ButtonStyle] [int] NOT NULL,
 CONSTRAINT [PK_WorkflowActions] PRIMARY KEY CLUSTERED 
(
	[WorkflowActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WorkflowRoles]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowRoles](
	[WorkflowRoleId] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleNameId] [bigint] NOT NULL,
	[WorkflowId] [int] NOT NULL,
	[ModuleId] [tinyint] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_WorkflowRoles] PRIMARY KEY CLUSTERED 
(
	[WorkflowRoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowRoleActions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowRoleActions](
	[WorkflowRoleActionId] [bigint] IDENTITY(1,1) NOT NULL,
	[WorkflowRoleId] [bigint] NOT NULL,
	[WorkflowActionId] [int] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_WorkflowRoleActions] PRIMARY KEY CLUSTERED 
(
	[WorkflowRoleActionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowActionReasons]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowActionReasons](
	[WorkflowActionReasonID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowActionId] [int] NOT NULL,
	[WorkflowReasonId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_WorkflowActionReasons] PRIMARY KEY CLUSTERED 
(
	[WorkflowActionReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowActionList]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowActionList](
	[WorkflowActionListID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowActionID] [int] NOT NULL,
	[ConditionExpression] [nvarchar](4000) NULL,
	[SegmentId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowActionList] PRIMARY KEY CLUSTERED 
(
	[WorkflowActionListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowStateActions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowStateActions](
	[WorkflowStateActionID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowActionID] [int] NOT NULL,
	[StateID] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_WorkflowStateActions] PRIMARY KEY CLUSTERED 
(
	[WorkflowStateActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserObjectWorkflowRole]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserObjectWorkflowRole](
	[UserObjectWorkflowRoleId] [bigint] IDENTITY(1,1) NOT NULL,
	[WorkflowRoleId] [bigint] NOT NULL,
	[GrantToObjectId] [int] NOT NULL,
	[GrantToObjectTypeId] [int] NOT NULL,
	[GrantOnObjectId] [bigint] NOT NULL,
	[GrantOnObjectTypeId] [bigint] NOT NULL,
	[DenyObjectRole] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_UserObjectWorkflowRole] PRIMARY KEY CLUSTERED 
(
	[UserObjectWorkflowRoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowVariableLookupValues]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowVariableLookupValues](
	[WorkflowVariableLookupValueID] [bigint] IDENTITY(1,1) NOT NULL,
	[WorkflowVariableID] [int] NOT NULL,
	[Value] [nvarchar](4000) NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_WorkflowVariableLookupValues] PRIMARY KEY CLUSTERED 
(
	[WorkflowVariableLookupValueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTasks]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTasks](
	[WorkflowTaskID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[WorkflowStateID] [int] NOT NULL,
	[Unlocked] [bit] NULL,
	[Blocked] [bit] NULL,
	[Comment] [nvarchar](4000) NULL,
	[OwnerID] [uniqueidentifier] NULL,
	[OwnedUntil] [datetime] NULL,
	[NextTimer] [datetime] NULL,
	[InternalStatus] [int] NULL,
	[InternalState] [image] NULL,
	[Active] [bit] NOT NULL,
	[ObjectID] [int] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_WorkflowTasks] PRIMARY KEY CLUSTERED 
(
	[WorkflowTaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SecurityGroupUser]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityGroupUser](
	[SecurityGroupUserID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[SecurityGroupID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_SecurityGroupUser] PRIMARY KEY CLUSTERED 
(
	[SecurityGroupUserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OutTransmissionLogs]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutTransmissionLogs](
	[OutTransmissionLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectId] [bigint] NOT NULL,
	[OutTransmissionID] [bigint] NOT NULL,
	[TransmissionQueueItemId] [bigint] NOT NULL,
	[Succeeded] [bit] NOT NULL,
	[ResponseVerificationCode] [varchar](100) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_OutTransmissionLogs] PRIMARY KEY CLUSTERED 
(
	[OutTransmissionLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ModuleActions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleActions](
	[ModuleActionID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleID] [tinyint] NOT NULL,
	[ActionType] [int] NOT NULL,
	[ActionGroupId] [int] NULL,
 CONSTRAINT [PK_ModuleActions] PRIMARY KEY CLUSTERED 
(
	[ModuleActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedDictLevelCmpntUpdates]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedDictLevelCmpntUpdates](
	[LevelCmpntUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[InitialLevelComponentID] [bigint] NULL,
	[VersionLevelComponentID] [int] NOT NULL,
	[FinalLevelComponentID] [bigint] NULL,
	[ChangeTypeId] [int] NOT NULL,
	[FromVersionOrdinal] [int] NOT NULL,
	[ToVersionOrdinal] [int] NOT NULL,
	[Locale] [tinyint] NOT NULL,
 CONSTRAINT [PK_MedDictLevelCmpntUpdates] PRIMARY KEY CLUSTERED 
(
	[LevelCmpntUpdateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LclDataStringReferences]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LclDataStringReferences](
	[StringReferenceID] [int] IDENTITY(1,1) NOT NULL,
	[LclStringID] [int] NOT NULL,
	[ObjectTypeID] [int] NOT NULL,
	[ObjectId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[PropertyName] [varchar](100) NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_LclDataStringReferences] PRIMARY KEY CLUSTERED 
(
	[StringReferenceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StudyDictionaryVersionHistory]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudyDictionaryVersionHistory](
	[StudyDictionaryVersionHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[StudyID] [bigint] NOT NULL,
	[FromVersionOrdinal] [int] NOT NULL,
	[ToVersionOrdinal] [int] NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[ImpactAnalysis0] [int] NOT NULL,
	[ImpactAnalysis1] [int] NOT NULL,
	[ImpactAnalysis2] [int] NOT NULL,
	[ImpactAnalysis3] [int] NOT NULL,
	[ImpactAnalysis4] [int] NOT NULL,
	[ImpactAnalysis5] [int] NOT NULL,
	[ImpactAnalysis6] [int] NOT NULL,
	[ImpactAnalysis7] [int] NOT NULL,
	[MigrationStarted] [datetime] NOT NULL,
	[MigrationEnded] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_StudyDictionaryVersionHistory] PRIMARY KEY CLUSTERED 
(
	[StudyDictionaryVersionHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudyDictionaryVersion]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudyDictionaryVersion](
	[StudyDictionaryVersionID] [bigint] IDENTITY(1,1) NOT NULL,
	[StudyID] [bigint] NOT NULL,
	[KeepCurrentVersion] [bit] NOT NULL,
	[VersionOrdinal] [int] NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[InitialVersionOrdinal] [int] NOT NULL,
	[NumberOfMigrations] [int] NOT NULL,
	[StudyLock] [tinyint] NOT NULL,
 CONSTRAINT [PK_StudyDictionaryVersion] PRIMARY KEY CLUSTERED 
(
	[StudyDictionaryVersionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_StudyDictionaryVersion_StudyIDMedDictIDSeg] UNIQUE NONCLUSTERED 
(
	[StudyID] ASC,
	[MedicalDictionaryID] ASC,
	[SegmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SynonymMigrationSuggestions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SynonymMigrationSuggestions](
	[SynonymMigrationSuggestionID] [bigint] IDENTITY(1,1) NOT NULL,
	[SynonymMigrationEntryID] [bigint] NOT NULL,
	[SynonymSuggestionReasonRID] [int] NOT NULL,
	[TermID] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SuggestedNodePath] [varchar](1000) NULL,
	[IsPrimaryPath] [bit] NOT NULL,
 CONSTRAINT [PK_SynonymMigrationSuggestionID] PRIMARY KEY CLUSTERED 
(
	[SynonymMigrationSuggestionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SystemVariables]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemVariables](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystemId] [int] NOT NULL,
	[WorkflowVariableId] [int] NOT NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_SystemVariables] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HealthCheckStatistics]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HealthCheckStatistics](
	[HealthCheckStatisticsID] [bigint] IDENTITY(1,1) NOT NULL,
	[HealthCheckRunID] [bigint] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[ErrorCount] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_HealthCheckStatistics_HealthCheckStatistics] PRIMARY KEY CLUSTERED 
(
	[HealthCheckStatisticsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingRejections]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingRejections](
	[CodingRejectionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingElementID] [bigint] NOT NULL,
	[SegmentId] [int] NULL,
	[UserID] [int] NOT NULL,
	[WorkflowReasonID] [int] NOT NULL,
	[Comment] [nvarchar](4000) NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingRejections] PRIMARY KEY CLUSTERED 
(
	[CodingRejectionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingSourceAlgorithm]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingSourceAlgorithm](
	[CodingSourceAlgorithmID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryUseAlgorithmID] [int] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[NameStringId] [int] NOT NULL,
	[DescriptionStringId] [int] NOT NULL,
	[SelectThreshold] [float] NOT NULL,
	[SuggestThreshold] [float] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingSourceAlgorithm] PRIMARY KEY CLUSTERED 
(
	[CodingSourceAlgorithmID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditTags]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditTags](
	[AuditTagId] [int] IDENTITY(1,1) NOT NULL,
	[AuditDetailTypeId] [int] NOT NULL,
	[AuditCategoryId] [int] NOT NULL,
 CONSTRAINT [PK_AuditTags] PRIMARY KEY CLUSTERED 
(
	[AuditTagId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Authenticators]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authenticators](
	[AuthenticatorID] [int] IDENTITY(1,1) NOT NULL,
	[ApiClientID] [int] NOT NULL,
	[NameID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[AutoInactivateUsers] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SegmentID] [int] NOT NULL,
	[UserDeactivated] [bit] NOT NULL,
 CONSTRAINT [PK_Authenticator] PRIMARY KEY CLUSTERED 
(
	[AuthenticatorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicationTrackableObject]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationTrackableObject](
	[ApplicationTrackableObjectID] [bigint] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL,
	[TrackableObjectID] [bigint] NOT NULL,
	[Status] [nvarchar](256) NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_ApplicationTrackableObject] PRIMARY KEY CLUSTERED 
(
	[ApplicationTrackableObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicationAdmin]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationAdmin](
	[ApplicationAdminID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL,
	[IsCoderApp] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[IsCronEnabled] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_ApplicationAdmin] PRIMARY KEY CLUSTERED 
(
	[ApplicationAdminID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApiCronSchedules]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApiCronSchedules](
	[ApiCronScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NULL,
	[ApiAdminId] [int] NOT NULL,
	[CronActionID] [int] NOT NULL,
	[Schedule] [varchar](500) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_ApiCronSchedules] PRIMARY KEY CLUSTERED 
(
	[ApiCronScheduleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CodingElements]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[CodingElements](
	[CodingElementId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTaskId] [int] NULL,
	[CodingRequestId] [int] NOT NULL,
	[SourceSystemId] [smallint] NOT NULL,
	[SegmentId] [smallint] NULL,
	[TrackableObjectId] [int] NULL,
	[CodingSourceAlgorithmID] [int] NULL,
	[DictionaryVersionId] [smallint] NOT NULL,
	[DictionaryLevelId] [int] NULL,
	[DictionaryLocale] [char](3) NULL,
	[VerbatimTerm] [nvarchar](500) NOT NULL,
	[IsClosed] [bit] NULL,
	[IsCompleted] [bit] NULL,
	[IsAutoCodeRequired] [bit] NULL,
	[AutoCodeDate] [datetime] NULL,
	[CompletionDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SearchType] [int] NOT NULL,
	[CodingElementGroupID] [int] NOT NULL,
 CONSTRAINT [PK_CodingElements] PRIMARY KEY CLUSTERED 
(
	[CodingElementId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](255) NOT NULL,
	[MiddleName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NOT NULL,
	[Title] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[Login] [nvarchar](50) NOT NULL,
	[PIN] [nvarchar](256) NULL,
	[Password] [nvarchar](256) NULL,
	[PasswordExpires] [datetime] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[IsTrainingSigned] [bit] NOT NULL,
	[Locale] [char](3) NULL,
	[GlobalRoleID] [int] NOT NULL,
	[ExternalID] [int] NULL,
	[IsSponsorApprovalRequired] [bit] NOT NULL,
	[AccountActivation] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[Credentials] [nvarchar](255) NULL,
	[Salutation] [nvarchar](32) NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[Guid] [char](36) NOT NULL,
	[DEANumber] [nvarchar](255) NULL,
	[IsTrainingOnly] [bit] NOT NULL,
	[EULADate] [datetime] NULL,
	[IsClinicalUser] [bit] NOT NULL,
	[IsReadOnly] [bit] NOT NULL,
	[AuthenticatorID] [int] NULL,
	[CreatedBy] [int] NULL,
	[AuthenticationSourceID] [int] NULL,
	[Salt] [nvarchar](50) NULL,
	[UserDeactivated] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DefaultSegmentID] [int] NULL,
	[IMedidataId] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Users_Login] UNIQUE NONCLUSTERED 
(
	[Login] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Users_IMedidataID] UNIQUE NONCLUSTERED 
(
	[IMedidataId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WorkflowTaskHistory]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTaskHistory](
	[WorkflowTaskHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[WorkflowTaskID] [int] NOT NULL,
	[WorkflowStateID] [int] NOT NULL,
	[WorkflowActionID] [int] NULL,
	[WorkflowSystemActionID] [int] NULL,
	[UserID] [int] NULL,
	[WorkflowReasonID] [int] NULL,
	[Comment] [nvarchar](4000) NULL,
	[Created] [datetime] NOT NULL,
	[SegmentId] [smallint] NOT NULL,
	[CodingAssignmentId] [int] NULL,
 CONSTRAINT [PK_WorkflowTaskHistory] PRIMARY KEY CLUSTERED 
(
	[WorkflowTaskHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTaskData]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTaskData](
	[WorkflowTaskDataID] [bigint] IDENTITY(1,1) NOT NULL,
	[WorkflowTaskID] [int] NOT NULL,
	[WorkflowVariableID] [int] NOT NULL,
	[Data] [nvarchar](4000) NOT NULL,
	[SegmentID] [smallint] NULL,
 CONSTRAINT [PK_WorkflowTaskData] PRIMARY KEY CLUSTERED 
(
	[WorkflowTaskDataID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowActionItems]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowActionItems](
	[WorkflowActionItemID] [int] IDENTITY(1,1) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[TargetStateID] [int] NULL,
	[WorkflowSystemActionID] [int] NULL,
	[WorkflowActionListID] [int] NULL,
	[SuccessFlag] [bit] NULL,
	[SegmentId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowActionItems] PRIMARY KEY CLUSTERED 
(
	[WorkflowActionItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowActionItemData]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowActionItemData](
	[WorkflowActionItemDataID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowActionItemID] [int] NOT NULL,
	[Tag] [nvarchar](200) NULL,
	[Value] [nvarchar](4000) NULL,
	[SegmentId] [int] NOT NULL,
 CONSTRAINT [PK_WorkflowActionItemData] PRIMARY KEY CLUSTERED 
(
	[WorkflowActionItemDataID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSettings]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserSettings](
	[UserSettingID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Tag] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](200) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[Guid] [char](36) NOT NULL,
	[IsUserConfigurable] [bit] NOT NULL,
	[SegmentID] [int] NULL,
 CONSTRAINT [PK_UserSettings] PRIMARY KEY CLUSTERED 
(
	[UserSettingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MessageRecipients]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MessageRecipients](
	[MessageRecipientID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[ReceiptTime] [datetime] NULL,
	[Deleted] [bit] NOT NULL,
	[DeleteTime] [datetime] NULL,
	[Updated] [datetime] NOT NULL,
	[Guid] [char](36) NOT NULL,
	[SegmentID] [int] NOT NULL,
 CONSTRAINT [PK_MessageRecipients] PRIMARY KEY CLUSTERED 
(
	[MessageRecipientID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Interactions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Interactions](
	[InteractionID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Start] [datetime] NULL,
	[LastAccess] [datetime] NULL,
	[Finish] [datetime] NULL,
	[NetWorkAddress] [varchar](255) NULL,
	[InteractionStatus] [int] NOT NULL,
	[ClickCount] [int] NOT NULL,
	[Guid] [char](36) NOT NULL,
	[EncryptionKey] [varchar](50) NULL,
	[LastSignatureDate] [datetime] NULL,
	[SessionID] [varchar](36) NULL,
	[LastAttemptedURL] [nvarchar](2000) NULL,
 CONSTRAINT [PK_Interactions] PRIMARY KEY CLUSTERED 
(
	[InteractionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DictionaryLicenceInformations]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DictionaryLicenceInformations](
	[DictionaryLicenceInformationID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryID] [int] NOT NULL,
	[DictionaryLocale] [char](3) NOT NULL,
	[SegmentID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[LicenceCode] [nvarchar](300) NULL,
	[UserID] [int] NOT NULL,
	[StartLicenceDate] [datetime] NOT NULL,
	[EndLicenceDate] [datetime] NOT NULL,
	[LicenceSubscriptionAction] [tinyint] NOT NULL,
	[IsHistoricalEntry] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_DictionaryLicenceInformations] PRIMARY KEY CLUSTERED 
(
	[DictionaryLicenceInformationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DoNotAutoCodeTerms]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DoNotAutoCodeTerms](
	[DoNotAutoCodeTermId] [int] IDENTITY(1,1) NOT NULL,
	[MedicalDictionaryId] [smallint] NOT NULL,
	[Locale] [char](3) NOT NULL,
	[DictionaryVersionId] [int] NOT NULL,
	[TermId] [int] NOT NULL,
	[Term] [nvarchar](500) NOT NULL,
	[DictionaryLevelId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[UserId] [int] NOT NULL,
	[SegmentId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DictionaryVersionSubscriptions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictionaryVersionSubscriptions](
	[DictionaryVersionSubscriptionID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[UserID] [int] NOT NULL,
	[ObjectSegmentID] [int] NOT NULL,
	[VersionSubscriptionAction] [tinyint] NOT NULL,
	[IsHistoricalEntry] [bit] NOT NULL,
	[HistoricalVersionLocaleStatusID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SubscriptionLogID] [int] NOT NULL,
 CONSTRAINT [PK_DictionaryVersionSubscriptions] PRIMARY KEY CLUSTERED 
(
	[DictionaryVersionSubscriptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingSourceTerms]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[CodingSourceTerms](
	[CodingSourceTermId] [int] IDENTITY(1,1) NOT NULL,
	[CodingElementId] [int] NOT NULL,
	[TrackableObjectId] [int] NULL,
	[SourceSystemId] [int] NOT NULL,
	[ExternalID] [nvarchar](50) NULL,
	[SegmentId] [smallint] NOT NULL,
	[CodingSourceAlgorithmID] [int] NULL,
	[DictionaryVersionId] [int] NOT NULL,
	[DictionaryLevelId] [int] NULL,
	[DictionaryLocale] [char](3) NULL,
	[Term] [nvarchar](255) NOT NULL,
	[TermLevel] [nvarchar](50) NULL,
	[Priority] [int] NOT NULL,
	[IsAutoCode] [bit] NULL,
	[IsProductionData] [bit] NULL,
	[IsAddToKnowledgeBase] [bit] NULL,
	[SubmissionDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_CodingSourceTerms] PRIMARY KEY CLUSTERED 
(
	[CodingSourceTermId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CodingAssignment]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingAssignment](
	[CodingAssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[CodingElementID] [int] NOT NULL,
	[SegmentId] [smallint] NULL,
	[UserID] [int] NOT NULL,
	[CodingSourceAlgorithmID] [int] NOT NULL,
	[DictionaryVersionId] [smallint] NULL,
	[IsSuggested] [bit] NOT NULL,
	[IsAutoCoded] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[SourceSynonymTermID] [int] NOT NULL,
	[SegmentedGroupCodingPatternID] [int] NOT NULL,
 CONSTRAINT [PK_CodingAssignment] PRIMARY KEY CLUSTERED 
(
	[CodingAssignmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AckNackTransmissions]    Script Date: 01/04/2011 10:58:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AckNackTransmissions](
	[AckNackTransmissionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingElementID] [int] NOT NULL,
	[TransmissionQueueItemID] [bigint] NOT NULL,
	[IsSentSynchronously] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_AckNackTransmissions] PRIMARY KEY CLUSTERED 
(
	[AckNackTransmissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Default [DF__AckNackTr__Trans__2042BE37]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AckNackTransmissions] ADD  DEFAULT ((-1)) FOR [TransmissionQueueItemID]
GO
/****** Object:  Default [DF__AckNackTr__IsSen__2136E270]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AckNackTransmissions] ADD  DEFAULT ((0)) FOR [IsSentSynchronously]
GO
/****** Object:  Default [DF_AckNackTransmissions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AckNackTransmissions] ADD  CONSTRAINT [DF_AckNackTransmissions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_AckNackTransmissions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AckNackTransmissions] ADD  CONSTRAINT [DF_AckNackTransmissions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Activations_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Activations] ADD  CONSTRAINT [DF_Activations_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Activations_ActivationStatus]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Activations] ADD  CONSTRAINT [DF_Activations_ActivationStatus]  DEFAULT ((0)) FOR [ActivationStatus]
GO
/****** Object:  Default [DF_Activations_Completed]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Activations] ADD  CONSTRAINT [DF_Activations_Completed]  DEFAULT ((0)) FOR [Completed]
GO
/****** Object:  Default [DF__Activatio__Alert__6501FCD8]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Activations] ADD  DEFAULT ((0)) FOR [AlertSent]
GO
/****** Object:  Default [DF_Activations_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Activations] ADD  CONSTRAINT [DF_Activations_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_ApiClients_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApiClients] ADD  CONSTRAINT [DF_ApiClients_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_ApiCronSchedules_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApiCronSchedules] ADD  CONSTRAINT [DF_ApiCronSchedules_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_ApiCronSchedules_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApiCronSchedules] ADD  CONSTRAINT [DF_ApiCronSchedules_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__Applicati__Sourc__475C8B58]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Application] ADD  DEFAULT ((-1)) FOR [SourceSystemID]
GO
/****** Object:  Default [DF__ATC__ParentATCCo__0717E911]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ATC] ADD  DEFAULT ('') FOR [ParentATCCode]
GO
/****** Object:  Default [DF__ATC__TermID__080C0D4A]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ATC] ADD  DEFAULT ((0)) FOR [TermID]
GO
/****** Object:  Default [DF__ATC__ParentTermI__09003183]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ATC] ADD  DEFAULT ((0)) FOR [ParentTermID]
GO
/****** Object:  Default [DF_Audits_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Audits] ADD  CONSTRAINT [DF_Audits_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_AuditSources_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuditSources] ADD  CONSTRAINT [DF_AuditSources_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_AuthenticationSources_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuthenticationSources] ADD  CONSTRAINT [DF_AuthenticationSources_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_AuthenticationSources_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuthenticationSources] ADD  CONSTRAINT [DF_AuthenticationSources_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_AuthenticationSources_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuthenticationSources] ADD  CONSTRAINT [DF_AuthenticationSources_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_AuthenticationSources_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuthenticationSources] ADD  CONSTRAINT [DF_AuthenticationSources_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_Authenticators_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Authenticators] ADD  CONSTRAINT [DF_Authenticators_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF__BNA_B__Source_Na__558B7A75]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[BNA_B] ADD  DEFAULT ('') FOR [Source_Name]
GO
/****** Object:  Default [DF__BNA_B__Source_Co__567F9EAE]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[BNA_B] ADD  DEFAULT ('') FOR [Source_CountryCode]
GO
/****** Object:  Default [DF__BNA_B__Source_Co__5773C2E7]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[BNA_B] ADD  DEFAULT ('') FOR [Source_CountryName]
GO
/****** Object:  Default [DF__CoderLocaleA__ID__6E8B6712]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CoderLocaleAddlInfo] ADD  DEFAULT ((1)) FOR [ID]
GO
/****** Object:  Default [DF_CoderSegments_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_CoderSegments_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_CoderSegments_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CoderSegments_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingAssignment_IsSuggested]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment] ADD  CONSTRAINT [DF_CodingAssignment_IsSuggested]  DEFAULT ((0)) FOR [IsSuggested]
GO
/****** Object:  Default [DF_CodingAssignment_IsAutoCoded]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment] ADD  CONSTRAINT [DF_CodingAssignment_IsAutoCoded]  DEFAULT ((0)) FOR [IsAutoCoded]
GO
/****** Object:  Default [DF_CodingAssignment_IsActive]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment] ADD  CONSTRAINT [DF_CodingAssignment_IsActive]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_CodingAssignment_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment] ADD  CONSTRAINT [DF_CodingAssignment_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingAssignment_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment] ADD  CONSTRAINT [DF_CodingAssignment_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__CodingAss__Sourc__7814D14C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment] ADD  DEFAULT ((-1)) FOR [SourceSynonymTermID]
GO
/****** Object:  Default [DF_CodingAssignment_SegmentedGroupCodingPatternID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment] ADD  CONSTRAINT [DF_CodingAssignment_SegmentedGroupCodingPatternID]  DEFAULT ((-1)) FOR [SegmentedGroupCodingPatternID]
GO
/****** Object:  Default [DF_CodingElementGroupComponents_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroupComponents] ADD  CONSTRAINT [DF_CodingElementGroupComponents_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingElementGroupComponents_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroupComponents] ADD  CONSTRAINT [DF_CodingElementGroupComponents_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingElementGroups_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroups] ADD  CONSTRAINT [DF_CodingElementGroups_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingElementGroups_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroups] ADD  CONSTRAINT [DF_CodingElementGroups_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingElementGroups_HasComponents]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroups] ADD  CONSTRAINT [DF_CodingElementGroups_HasComponents]  DEFAULT ((0)) FOR [HasComponents]
GO
/****** Object:  Default [DF_CodingElementGroups_ProgrammaticAuxiliary]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroups] ADD  CONSTRAINT [DF_CodingElementGroups_ProgrammaticAuxiliary]  DEFAULT ((0)) FOR [ProgrammaticAuxiliary]
GO
/****** Object:  Default [DF_CodingElementGroups_HasSupplements]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroups] ADD  CONSTRAINT [DF_CodingElementGroups_HasSupplements]  DEFAULT ((0)) FOR [HasSupplements]
GO
/****** Object:  Default [DF_CodingElementGroupSupplementals_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroupSupplementals] ADD  CONSTRAINT [DF_CodingElementGroupSupplementals_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingElementGroupSupplementals_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElementGroupSupplementals] ADD  CONSTRAINT [DF_CodingElementGroupSupplementals_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingElements_IsClosed]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements] ADD  CONSTRAINT [DF_CodingElements_IsClosed]  DEFAULT ((0)) FOR [IsClosed]
GO
/****** Object:  Default [DF_CodingElements_IsCompleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements] ADD  CONSTRAINT [DF_CodingElements_IsCompleted]  DEFAULT ((0)) FOR [IsCompleted]
GO
/****** Object:  Default [DF_CodingElements_IsAutoCodeRequired]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements] ADD  CONSTRAINT [DF_CodingElements_IsAutoCodeRequired]  DEFAULT ((0)) FOR [IsAutoCodeRequired]
GO
/****** Object:  Default [DF_CodingElements_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements] ADD  CONSTRAINT [DF_CodingElements_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingElements_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements] ADD  CONSTRAINT [DF_CodingElements_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingElements_SearchType]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements] ADD  CONSTRAINT [DF_CodingElements_SearchType]  DEFAULT ((0)) FOR [SearchType]
GO
/****** Object:  Default [DF_CodingElements_CodingElementGroupID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements] ADD  CONSTRAINT [DF_CodingElements_CodingElementGroupID]  DEFAULT ((-1)) FOR [CodingElementGroupID]
GO
/****** Object:  Default [DF_CodingPatterns_IsPrimaryPath]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingPatterns] ADD  CONSTRAINT [DF_CodingPatterns_IsPrimaryPath]  DEFAULT ((0)) FOR [IsPrimaryPath]
GO
/****** Object:  Default [DF_CodingPatterns_MedicalDictionaryTermID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingPatterns] ADD  CONSTRAINT [DF_CodingPatterns_MedicalDictionaryTermID]  DEFAULT ((-1)) FOR [MedicalDictionaryTermID]
GO
/****** Object:  Default [DF_CodingPatterns_CodingPath]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingPatterns] ADD  CONSTRAINT [DF_CodingPatterns_CodingPath]  DEFAULT ('') FOR [CodingPath]
GO
/****** Object:  Default [DF_CodingPatterns_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingPatterns] ADD  CONSTRAINT [DF_CodingPatterns_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingPatterns_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingPatterns] ADD  CONSTRAINT [DF_CodingPatterns_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingRejections_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRejections] ADD  CONSTRAINT [DF_CodingRejections_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingRejections_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRejections] ADD  CONSTRAINT [DF_CodingRejections_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingRequests_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRequests] ADD  CONSTRAINT [DF_CodingRequests_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingRequests_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRequests] ADD  CONSTRAINT [DF_CodingRequests_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__CodingReq__Batch__4668671F]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRequests] ADD  DEFAULT (NULL) FOR [BatchOID]
GO
/****** Object:  Default [DF_CodingSourceAlgorithm_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceAlgorithm] ADD  CONSTRAINT [DF_CodingSourceAlgorithm_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_CodingSourceAlgorithm_DefaultFlag]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceAlgorithm] ADD  CONSTRAINT [DF_CodingSourceAlgorithm_DefaultFlag]  DEFAULT ((0)) FOR [IsDefault]
GO
/****** Object:  Default [DF_CodingSourceAlgorithm_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceAlgorithm] ADD  CONSTRAINT [DF_CodingSourceAlgorithm_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingSourceAlgorithm_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceAlgorithm] ADD  CONSTRAINT [DF_CodingSourceAlgorithm_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingSourceTermComponents_SearchType]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermComponents] ADD  CONSTRAINT [DF_CodingSourceTermComponents_SearchType]  DEFAULT ((0)) FOR [SearchType]
GO
/****** Object:  Default [DF_CodingSourceTermComponents_SearchOperator]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermComponents] ADD  CONSTRAINT [DF_CodingSourceTermComponents_SearchOperator]  DEFAULT ((0)) FOR [SearchOperator]
GO
/****** Object:  Default [DF_CodingSourceTermComponents_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermComponents] ADD  CONSTRAINT [DF_CodingSourceTermComponents_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingSourceTermComponents_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermComponents] ADD  CONSTRAINT [DF_CodingSourceTermComponents_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingSourceTermComponents_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermComponents] ADD  CONSTRAINT [DF_CodingSourceTermComponents_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_CodingSourceTermReferences_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermReferences] ADD  CONSTRAINT [DF_CodingSourceTermReferences_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingSourceTermReferences_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermReferences] ADD  CONSTRAINT [DF_CodingSourceTermReferences_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingSourceTermReferences_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermReferences] ADD  CONSTRAINT [DF_CodingSourceTermReferences_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_CodingSourceTerms_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTerms] ADD  CONSTRAINT [DF_CodingSourceTerms_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingSourceTerms_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTerms] ADD  CONSTRAINT [DF_CodingSourceTerms_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingSourceTermSupplementals_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermSupplementals] ADD  CONSTRAINT [DF_CodingSourceTermSupplementals_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingSourceTermSupplementals_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTermSupplementals] ADD  CONSTRAINT [DF_CodingSourceTermSupplementals_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CodingSuggestions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSuggestions] ADD  CONSTRAINT [DF_CodingSuggestions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CodingSuggestions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSuggestions] ADD  CONSTRAINT [DF_CodingSuggestions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_CommunicationLogs_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CommunicationLogs] ADD  CONSTRAINT [DF_CommunicationLogs_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CommunicationLogs_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CommunicationLogs] ADD  CONSTRAINT [DF_CommunicationLogs_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__ComponentE__Code__589C25F3]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ComponentEngStrings] ADD  DEFAULT ('') FOR [Code]
GO
/****** Object:  Default [DF__ComponentE__Name__59904A2C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ComponentEngStrings] ADD  DEFAULT ('') FOR [Name]
GO
/****** Object:  Default [DF__ComponentJ__Code__5C6CB6D7]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ComponentJpnStrings] ADD  DEFAULT ('') FOR [Code]
GO
/****** Object:  Default [DF__ComponentJ__Name__5D60DB10]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ComponentJpnStrings] ADD  DEFAULT ('') FOR [Name]
GO
/****** Object:  Default [DF__ComponentL__Code__603D47BB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ComponentLocStrings] ADD  DEFAULT ('') FOR [Code]
GO
/****** Object:  Default [DF__ComponentL__Name__61316BF4]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ComponentLocStrings] ADD  DEFAULT ('') FOR [Name]
GO
/****** Object:  Default [DF_Configuration_StudyID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_StudyID]  DEFAULT ((-1)) FOR [StudyID]
GO
/****** Object:  Default [DF_Configuration_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Configuration_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Configuration_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_CronActions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CronActions] ADD  CONSTRAINT [DF_CronActions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_CronActions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CronActions] ADD  CONSTRAINT [DF_CronActions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__DD_B__DrugRecord__595C0B59]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [DrugRecordNumber]
GO
/****** Object:  Default [DF__DD_B__SequenceNu__5A502F92]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [SequenceNumber1]
GO
/****** Object:  Default [DF__DD_B__SequenceNu__5B4453CB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [SequenceNumber2]
GO
/****** Object:  Default [DF__DD_B__CheckDigit__5C387804]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [CheckDigit]
GO
/****** Object:  Default [DF__DD_B__Designatio__5D2C9C3D]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [Designation]
GO
/****** Object:  Default [DF__DD_B__SourceYear__5E20C076]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [SourceYear]
GO
/****** Object:  Default [DF__DD_B__SourceCode__5F14E4AF]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [SourceCode]
GO
/****** Object:  Default [DF__DD_B__CompanyCod__600908E8]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [CompanyCode]
GO
/****** Object:  Default [DF__DD_B__NumberOfIn__60FD2D21]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [NumberOfIngredients]
GO
/****** Object:  Default [DF__DD_B__SaltEsterC__61F1515A]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [SaltEsterCode]
GO
/****** Object:  Default [DF__DD_B__YearQuarte__62E57593]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [YearQuarter]
GO
/****** Object:  Default [DF__DD_B__DrugName__63D999CC]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [DrugName]
GO
/****** Object:  Default [DF__DD_B__Company_Na__64CDBE05]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [Company_Name]
GO
/****** Object:  Default [DF__DD_B__Company_Co__65C1E23E]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [Company_CountryCode]
GO
/****** Object:  Default [DF__DD_B__Company_Co__66B60677]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [Company_CountryName]
GO
/****** Object:  Default [DF__DD_B__Source_Nam__67AA2AB0]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [Source_Name]
GO
/****** Object:  Default [DF__DD_B__Source_Cou__689E4EE9]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [Source_CountryCode]
GO
/****** Object:  Default [DF__DD_B__Source_Cou__69927322]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ('') FOR [Source_CountryName]
GO
/****** Object:  Default [DF__DD_B__TermID__6A86975B]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DD_B] ADD  DEFAULT ((0)) FOR [TermID]
GO
/****** Object:  Default [DF__DDA_B__OfficialA__6C6EDFCD]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DDA_B] ADD  DEFAULT ('') FOR [OfficialATCCode]
GO
/****** Object:  Default [DF__DDA_B__ATCCode_L__6D630406]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DDA_B] ADD  DEFAULT ('') FOR [ATCCode_Level]
GO
/****** Object:  Default [DF__DDA_B__ATCCode_T__6E57283F]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DDA_B] ADD  DEFAULT ('') FOR [ATCCode_Text]
GO
/****** Object:  Default [DF__DDA_B__ParentATC__6F4B4C78]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DDA_B] ADD  DEFAULT ('') FOR [ParentATCCode]
GO
/****** Object:  Default [DF__DDA_B__DDTermID__703F70B1]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DDA_B] ADD  DEFAULT ((0)) FOR [DDTermID]
GO
/****** Object:  Default [DF__DDA_B__ATCTermID__713394EA]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DDA_B] ADD  DEFAULT ((0)) FOR [ATCTermID]
GO
/****** Object:  Default [DF_DictionaryVersionSubscriptions_SubscriptionLogID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DictionaryVersionSubscriptions] ADD  CONSTRAINT [DF_DictionaryVersionSubscriptions_SubscriptionLogID]  DEFAULT ((-1)) FOR [SubscriptionLogID]
GO
/****** Object:  Default [DF_DoNotAutoCodeTerms_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms] ADD  CONSTRAINT [DF_DoNotAutoCodeTerms_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_DoNotAutoCodeTerms_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms] ADD  CONSTRAINT [DF_DoNotAutoCodeTerms_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_DoNotAutoCodeTerms_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms] ADD  CONSTRAINT [DF_DoNotAutoCodeTerms_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_HealthCheckRuns_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HealthCheckRuns] ADD  CONSTRAINT [DF_HealthCheckRuns_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_HealthCheckRuns_TimeEnded]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HealthCheckRuns] ADD  CONSTRAINT [DF_HealthCheckRuns_TimeEnded]  DEFAULT (getutcdate()) FOR [TimeEnded]
GO
/****** Object:  Default [DF_HealthChecksR_IsValid]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HealthChecksR] ADD  CONSTRAINT [DF_HealthChecksR_IsValid]  DEFAULT ((1)) FOR [IsValid]
GO
/****** Object:  Default [DF_HealthCheckStatistics_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HealthCheckStatistics] ADD  CONSTRAINT [DF_HealthCheckStatistics_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_HealthCheckStatistics_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HealthCheckStatistics] ADD  CONSTRAINT [DF_HealthCheckStatistics_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_HelpContexts_IsWindowsMedia]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HelpContexts] ADD  CONSTRAINT [DF_HelpContexts_IsWindowsMedia]  DEFAULT ((0)) FOR [IsWindowsMedia]
GO
/****** Object:  Default [DF_HelpContexts_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HelpContexts] ADD  CONSTRAINT [DF_HelpContexts_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_HelpContexts_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HelpContexts] ADD  CONSTRAINT [DF_HelpContexts_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__INA_B__ParentATC__50C6C558]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[INA_B] ADD  DEFAULT ('') FOR [ParentATCCode]
GO
/****** Object:  Default [DF__INA_B__TermID__51BAE991]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[INA_B] ADD  DEFAULT ((0)) FOR [TermID]
GO
/****** Object:  Default [DF__INA_B__ParentTer__52AF0DCA]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[INA_B] ADD  DEFAULT ((0)) FOR [ParentTermID]
GO
/****** Object:  Default [DF__ING__IngredientC__48E5AC6E]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [IngredientCreateDate]
GO
/****** Object:  Default [DF__ING__Quantity__49D9D0A7]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [Quantity]
GO
/****** Object:  Default [DF__ING__Quantity2__4ACDF4E0]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [Quantity2]
GO
/****** Object:  Default [DF__ING__Unit_Id__4BC21919]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [Unit_Id]
GO
/****** Object:  Default [DF__ING__Unit__4CB63D52]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [Unit]
GO
/****** Object:  Default [DF__ING__Pharmform_I__4DAA618B]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [Pharmform_Id]
GO
/****** Object:  Default [DF__ING__Pharmform__4E9E85C4]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [Pharmform]
GO
/****** Object:  Default [DF__ING__RouteOfAdmi__4F92A9FD]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [RouteOfAdministration]
GO
/****** Object:  Default [DF__ING__NumberOfIng__5086CE36]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [NumberOfIngredients]
GO
/****** Object:  Default [DF__ING__PharmProduc__517AF26F]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [PharmProductCreateDate]
GO
/****** Object:  Default [DF__ING__SubstanceNa__526F16A8]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [SubstanceName]
GO
/****** Object:  Default [DF__ING__CASNumber__53633AE1]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [CASNumber]
GO
/****** Object:  Default [DF__ING__LanguageCod__54575F1A]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [LanguageCode]
GO
/****** Object:  Default [DF__ING__SourceYear__554B8353]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [SourceYear]
GO
/****** Object:  Default [DF__ING__SourceCode__563FA78C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [SourceCode]
GO
/****** Object:  Default [DF__ING__Source__5733CBC5]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [Source]
GO
/****** Object:  Default [DF__ING__SourceCount__5827EFFE]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [SourceCountryCode]
GO
/****** Object:  Default [DF__ING__SourceCount__591C1437]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ('') FOR [SourceCountryName]
GO
/****** Object:  Default [DF__ING__TermID__5A103870]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ((0)) FOR [TermID]
GO
/****** Object:  Default [DF__ING__ParentTermI__5B045CA9]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING] ADD  DEFAULT ((0)) FOR [ParentTermID]
GO
/****** Object:  Default [DF__ING_B__DrugRecor__731BDD5C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [DrugRecordNumber]
GO
/****** Object:  Default [DF__ING_B__SequenceN__74100195]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [SequenceNumber1]
GO
/****** Object:  Default [DF__ING_B__SequenceN__750425CE]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [SequenceNumber2]
GO
/****** Object:  Default [DF__ING_B__CheckDigi__75F84A07]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [CheckDigit]
GO
/****** Object:  Default [DF__ING_B__CASNumber__76EC6E40]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [CASNumber]
GO
/****** Object:  Default [DF__ING_B__LanguageC__77E09279]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [LanguageCode]
GO
/****** Object:  Default [DF__ING_B__Substance__78D4B6B2]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [SubstanceName]
GO
/****** Object:  Default [DF__ING_B__SourceYea__79C8DAEB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [SourceYear]
GO
/****** Object:  Default [DF__ING_B__SourceCod__7ABCFF24]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [SourceCode]
GO
/****** Object:  Default [DF__ING_B__Source_Na__7BB1235D]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [Source_Name]
GO
/****** Object:  Default [DF__ING_B__Source_Co__7CA54796]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [Source_CountryCode]
GO
/****** Object:  Default [DF__ING_B__Source_Co__7D996BCF]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ('') FOR [Source_CountryName]
GO
/****** Object:  Default [DF__ING_B__TermID__7E8D9008]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ((0)) FOR [TermID]
GO
/****** Object:  Default [DF__ING_B__DDTermID__7F81B441]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ING_B] ADD  DEFAULT ((0)) FOR [DDTermID]
GO
/****** Object:  Default [DF_InstalledModules_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[InstalledModules] ADD  CONSTRAINT [DF_InstalledModules_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_installedmodules_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[InstalledModules] ADD  CONSTRAINT [DF_installedmodules_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_installedmodules_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[InstalledModules] ADD  CONSTRAINT [DF_installedmodules_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_Interactions_ClickCount]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Interactions] ADD  CONSTRAINT [DF_Interactions_ClickCount]  DEFAULT ((0)) FOR [ClickCount]
GO
/****** Object:  Default [DF_Interactions_GUID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Interactions] ADD  CONSTRAINT [DF_Interactions_GUID]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF_LclDataStringReference_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LclDataStringReferences] ADD  CONSTRAINT [DF_LclDataStringReference_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_LclDataStringReference_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LclDataStringReferences] ADD  CONSTRAINT [DF_LclDataStringReference_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_LocalizationContexts_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LocalizationContexts] ADD  CONSTRAINT [DF_LocalizationContexts_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Localizations_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Localizations] ADD  CONSTRAINT [DF_Localizations_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Localizations_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Localizations] ADD  CONSTRAINT [DF_Localizations_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Localizations_SubmitOnEnter]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Localizations] ADD  CONSTRAINT [DF_Localizations_SubmitOnEnter]  DEFAULT ((1)) FOR [SubmitOnEnter]
GO
/****** Object:  Default [DF_LocalizedDataStrings_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LocalizedDataStrings] ADD  CONSTRAINT [DF_LocalizedDataStrings_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_LocalizedDataStrings_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LocalizedDataStrings] ADD  CONSTRAINT [DF_LocalizedDataStrings_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_LocalizedStrings_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LocalizedStrings] ADD  CONSTRAINT [DF_LocalizedStrings_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_LocalizedStrings_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LocalizedStrings] ADD  CONSTRAINT [DF_LocalizedStrings_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_LoginAttempts_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LoginAttempts] ADD  CONSTRAINT [DF_LoginAttempts_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_LoginAttempts_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LoginAttempts] ADD  CONSTRAINT [DF_LoginAttempts_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_LoginAttempts_GUID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LoginAttempts] ADD  CONSTRAINT [DF_LoginAttempts_GUID]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF__MedDictSy__Synon__3CBF0154]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictSynonymWasteBasket] ADD  DEFAULT ('') FOR [SynonymTerm]
GO
/****** Object:  Default [MedDictSynonymWasteBasket_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictSynonymWasteBasket] ADD  CONSTRAINT [MedDictSynonymWasteBasket_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [MedDictSynonymWasteBasket_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictSynonymWasteBasket] ADD  CONSTRAINT [MedDictSynonymWasteBasket_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_TermStatusR_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictTermStatusR] ADD  CONSTRAINT [DF_TermStatusR_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_TermStatusR_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictTermStatusR] ADD  CONSTRAINT [DF_TermStatusR_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__MedDictTe__Impac__4183B671]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictTermUpdates] ADD  DEFAULT ((0)) FOR [ImpactAnalysisChangeTypeId]
GO
/****** Object:  Default [DF__MedDictTe__Prior__4277DAAA]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictTermUpdates] ADD  DEFAULT ((-1)) FOR [PriorTermID]
GO
/****** Object:  Default [MedDictVerChangeType_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerChangeTypeR] ADD  CONSTRAINT [MedDictVerChangeType_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [MedDictVerChangeType_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerChangeTypeR] ADD  CONSTRAINT [MedDictVerChangeType_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__MedDictVe__Defau__45544755]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerLvlComponents] ADD  DEFAULT ('') FOR [DefaultValue_ENG]
GO
/****** Object:  Default [DF__MedDictVe__Defau__46486B8E]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerLvlComponents] ADD  DEFAULT ('') FOR [DefaultValue_JPN]
GO
/****** Object:  Default [DF__MedDictVe__Defau__473C8FC7]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerLvlComponents] ADD  DEFAULT ('') FOR [DefaultValue_LOC]
GO
/****** Object:  Default [MedDictVerLvlComponents_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerLvlComponents] ADD  CONSTRAINT [MedDictVerLvlComponents_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [MedDictVerLvlComponents_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerLvlComponents] ADD  CONSTRAINT [MedDictVerLvlComponents_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__MedicalDi__Creat__2B3F6F97]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictComponentTypes] ADD  CONSTRAINT [DF__MedicalDi__Creat__2B3F6F97]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF__MedicalDi__Updat__2C3393D0]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictComponentTypes] ADD  CONSTRAINT [DF__MedicalDi__Updat__2C3393D0]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_MedicalDictionary_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionary] ADD  CONSTRAINT [DF_MedicalDictionary_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictionary_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionary] ADD  CONSTRAINT [DF_MedicalDictionary_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_MedicalDictionary_SupportsPrimaryPath]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionary] ADD  CONSTRAINT [DF_MedicalDictionary_SupportsPrimaryPath]  DEFAULT ((0)) FOR [SupportsPrimaryPath]
GO
/****** Object:  Default [DF_MedicalDictionaryAlgorithm_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryAlgorithm] ADD  CONSTRAINT [DF_MedicalDictionaryAlgorithm_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictionaryAlgorithm_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryAlgorithm] ADD  CONSTRAINT [DF_MedicalDictionaryAlgorithm_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_MedicalDictionaryLevel_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryLevel] ADD  CONSTRAINT [DF_MedicalDictionaryLevel_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictionaryLevel_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryLevel] ADD  CONSTRAINT [DF_MedicalDictionaryLevel_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_DictionaryTemplateLevels_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTemplateLevels] ADD  CONSTRAINT [DF_DictionaryTemplateLevels_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_DictionaryTemplateLevels_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTemplateLevels] ADD  CONSTRAINT [DF_DictionaryTemplateLevels_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_MedicalDictionaryTemplates_IsDefault]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTemplates] ADD  CONSTRAINT [DF_MedicalDictionaryTemplates_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
/****** Object:  Default [DF_MedicalDictionaryTemplates_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTemplates] ADD  CONSTRAINT [DF_MedicalDictionaryTemplates_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictionaryTemplates_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTemplates] ADD  CONSTRAINT [DF_MedicalDictionaryTemplates_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__MedicalDi__Medic__5772F790]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTerm] ADD  DEFAULT ((-1)) FOR [MedicalDictionaryID]
GO
/****** Object:  Default [DF_MedicalDictionaryTermIsCurrent]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTerm] ADD  CONSTRAINT [DF_MedicalDictionaryTermIsCurrent]  DEFAULT ((1)) FOR [IsCurrent]
GO
/****** Object:  Default [DF_TrackableObjects_LevelRecursiveDepth]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTerm] ADD  CONSTRAINT [DF_TrackableObjects_LevelRecursiveDepth]  DEFAULT ((1)) FOR [LevelRecursiveDepth]
GO
/****** Object:  Default [DF_MedicalDictionaryTerm_ProgrammaticAuxiliary]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTerm] ADD  CONSTRAINT [DF_MedicalDictionaryTerm_ProgrammaticAuxiliary]  DEFAULT ((0)) FOR [ProgrammaticAuxiliary]
GO
/****** Object:  Default [DF_MedicalDictionaryTerm_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTerm] ADD  CONSTRAINT [DF_MedicalDictionaryTerm_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictionaryTerm_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTerm] ADD  CONSTRAINT [DF_MedicalDictionaryTerm_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__MedicalDi__Medic__5B438874]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTermRel] ADD  DEFAULT ((-1)) FOR [MedicalDictionaryID]
GO
/****** Object:  Default [DF_MedicalDictionaryUseAlgorithm_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryUseAlgorithm] ADD  CONSTRAINT [DF_MedicalDictionaryUseAlgorithm_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictionaryUseAlgorithm_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryUseAlgorithm] ADD  CONSTRAINT [DF_MedicalDictionaryUseAlgorithm_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_MedicalDictionaryVersion_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryVersion] ADD  CONSTRAINT [DF_MedicalDictionaryVersion_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictionaryVersion_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryVersion] ADD  CONSTRAINT [DF_MedicalDictionaryVersion_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_MedicalDictLevelComponents_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictLevelComponents] ADD  CONSTRAINT [DF_MedicalDictLevelComponents_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_MedicalDictLevelComponents_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictLevelComponents] ADD  CONSTRAINT [DF_MedicalDictLevelComponents_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [MedicalDictTermTypeR_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictTermTypeR] ADD  CONSTRAINT [MedicalDictTermTypeR_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [MedicalDictTermTypeR_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictTermTypeR] ADD  CONSTRAINT [MedicalDictTermTypeR_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [MedicalDictVerLocaleStatus_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerLocaleStatus] ADD  CONSTRAINT [MedicalDictVerLocaleStatus_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [MedicalDictVerLocaleStatus_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerLocaleStatus] ADD  CONSTRAINT [MedicalDictVerLocaleStatus_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_DictVerSegmentWorkflows_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerSegmentWorkflows] ADD  CONSTRAINT [DF_DictVerSegmentWorkflows_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_DictVerSegmentWorkflows_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerSegmentWorkflows] ADD  CONSTRAINT [DF_DictVerSegmentWorkflows_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__MedicalDi__Creat__65C116E7]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerStatusR] ADD  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF__MedicalDi__Updat__66B53B20]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerStatusR] ADD  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__MedicalDi__Term___67A95F59]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTerm] ADD  DEFAULT ('') FOR [Term_ENG]
GO
/****** Object:  Default [DF__MedicalDi__Term___689D8392]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTerm] ADD  DEFAULT ('') FOR [Term_JPN]
GO
/****** Object:  Default [DF__MedicalDi__Term___6991A7CB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTerm] ADD  DEFAULT ('') FOR [Term_LOC]
GO
/****** Object:  Default [DF_MedicalDictVerTermIsCurrent]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTerm] ADD  CONSTRAINT [DF_MedicalDictVerTermIsCurrent]  DEFAULT ((1)) FOR [IsCurrent]
GO
/****** Object:  Default [DF_MedicalDictVerTermNodepath]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTerm] ADD  CONSTRAINT [DF_MedicalDictVerTermNodepath]  DEFAULT ('') FOR [Nodepath]
GO
/****** Object:  Default [DF_MedicalDictVerTermNodepathDepth]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTerm] ADD  CONSTRAINT [DF_MedicalDictVerTermNodepathDepth]  DEFAULT ((1)) FOR [NodepathDepth]
GO
/****** Object:  Default [DF_MedicalDictVerTerm_LevelRecursiveDepth]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTerm] ADD  CONSTRAINT [DF_MedicalDictVerTerm_LevelRecursiveDepth]  DEFAULT ((1)) FOR [LevelRecursiveDepth]
GO
/****** Object:  Default [DF__MedicalDi__Relat__6E565CE8]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerTermRel] ADD  DEFAULT ('') FOR [RelationshipComments]
GO
/****** Object:  Default [DF_MessageRecipients_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MessageRecipients] ADD  CONSTRAINT [DF_MessageRecipients_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_MessageRecipients_InserTime]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MessageRecipients] ADD  CONSTRAINT [DF_MessageRecipients_InserTime]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_MessageRecipients_GUID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MessageRecipients] ADD  CONSTRAINT [DF_MessageRecipients_GUID]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF_Messages_GUID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Messages] ADD  CONSTRAINT [DF_Messages_GUID]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF_Messages_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Messages] ADD  CONSTRAINT [DF_Messages_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Messages_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Messages] ADD  CONSTRAINT [DF_Messages_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Messages_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Messages] ADD  CONSTRAINT [DF_Messages_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF__ModulePag__Updat__75F77EB0]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ModulePages] ADD  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_ModulesR_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ModulesR] ADD  CONSTRAINT [DF_ModulesR_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF__MP__DrugRecordNu__1DFB4E69]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [DrugRecordNumber]
GO
/****** Object:  Default [DF__MP__SequenceNumb__1EEF72A2]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SequenceNumber1]
GO
/****** Object:  Default [DF__MP__SequenceNumb__1FE396DB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SequenceNumber2]
GO
/****** Object:  Default [DF__MP__SequenceNumb__20D7BB14]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SequenceNumber3]
GO
/****** Object:  Default [DF__MP__SequenceNumb__21CBDF4D]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SequenceNumber3Text]
GO
/****** Object:  Default [DF__MP__SequenceNumb__22C00386]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SequenceNumber4]
GO
/****** Object:  Default [DF__MP__SequenceNumb__23B427BF]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SequenceNumber4Text]
GO
/****** Object:  Default [DF__MP__Generic__24A84BF8]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [Generic]
GO
/****** Object:  Default [DF__MP__DrugName__259C7031]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [DrugName]
GO
/****** Object:  Default [DF__MP__NameSpecifie__2690946A]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [NameSpecifier]
GO
/****** Object:  Default [DF__MP__MarketingAut__2784B8A3]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [MarketingAuthNumber]
GO
/****** Object:  Default [DF__MP__MarketingAut__2878DCDC]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [MarketingAuthDate]
GO
/****** Object:  Default [DF__MP__MarketingAut__296D0115]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [MarketingAuthWDate]
GO
/****** Object:  Default [DF__MP__CountryCode__2A61254E]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [CountryCode]
GO
/****** Object:  Default [DF__MP__CountryName__2B554987]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [CountryName]
GO
/****** Object:  Default [DF__MP__CompanyName__2C496DC0]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [CompanyName]
GO
/****** Object:  Default [DF__MP__CompanyCount__2D3D91F9]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [CompanyCountryCode]
GO
/****** Object:  Default [DF__MP__CompanyCount__2E31B632]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [CompanyCountryName]
GO
/****** Object:  Default [DF__MP__MarketingAut__2F25DA6B]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [MarketingAuthHolder]
GO
/****** Object:  Default [DF__MP__MarketingAut__3019FEA4]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [MarketingAuthHolderName]
GO
/****** Object:  Default [DF__MP__MarketingAut__310E22DD]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [MarketingAuthHolderCountryCode]
GO
/****** Object:  Default [DF__MP__MarketingAut__32024716]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [MarketingAuthHolderCountryName]
GO
/****** Object:  Default [DF__MP__SourceCode__32F66B4F]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SourceCode]
GO
/****** Object:  Default [DF__MP__Source__33EA8F88]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [Source]
GO
/****** Object:  Default [DF__MP__SourceCountr__34DEB3C1]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SourceCountryCode]
GO
/****** Object:  Default [DF__MP__SourceCountr__35D2D7FA]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SourceCountryName]
GO
/****** Object:  Default [DF__MP__SourceYear__36C6FC33]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [SourceYear]
GO
/****** Object:  Default [DF__MP__ProductTypeI__37BB206C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [ProductTypeId]
GO
/****** Object:  Default [DF__MP__ProductType__38AF44A5]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [ProductType]
GO
/****** Object:  Default [DF__MP__ProductGroup__39A368DE]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [ProductGroupID]
GO
/****** Object:  Default [DF__MP__ProductGroup__3A978D17]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [ProductGroupName]
GO
/****** Object:  Default [DF__MP__ProductGroup__3B8BB150]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [ProductGroupDateRecorded]
GO
/****** Object:  Default [DF__MP__CreateDate__3C7FD589]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [CreateDate]
GO
/****** Object:  Default [DF__MP__DateChanged__3D73F9C2]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ('') FOR [DateChanged]
GO
/****** Object:  Default [DF__MP__TermID__3E681DFB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MP] ADD  DEFAULT ((0)) FOR [TermID]
GO
/****** Object:  Default [DF_ObjectSegmentAttributes_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentAttributes] ADD  CONSTRAINT [DF_ObjectSegmentAttributes_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_ObjectSegmentAttributes_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentAttributes] ADD  CONSTRAINT [DF_ObjectSegmentAttributes_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_ObjectSegments_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegments] ADD  CONSTRAINT [DF_ObjectSegments_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_ObjectSegments_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegments] ADD  CONSTRAINT [DF_ObjectSegments_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_ObjectSegments_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegments] ADD  CONSTRAINT [DF_ObjectSegments_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_ObjectSegmentWorkflows_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentWorkflows] ADD  CONSTRAINT [DF_ObjectSegmentWorkflows_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_ObjectSegmentWorkflows_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentWorkflows] ADD  CONSTRAINT [DF_ObjectSegmentWorkflows_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_ObjectSegmentWorkflows_IsDefaultWorkflow]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentWorkflows] ADD  CONSTRAINT [DF_ObjectSegmentWorkflows_IsDefaultWorkflow]  DEFAULT ((0)) FOR [IsDefaultWorkflow]
GO
/****** Object:  Default [DF_ObjectSegmentWorkflows_IsProd]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentWorkflows] ADD  CONSTRAINT [DF_ObjectSegmentWorkflows_IsProd]  DEFAULT ((0)) FOR [IsProd]
GO
/****** Object:  Default [DF_ObjectSegmentWorkflows_AllowWorkflowChange]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentWorkflows] ADD  CONSTRAINT [DF_ObjectSegmentWorkflows_AllowWorkflowChange]  DEFAULT ((0)) FOR [AllowWorkflowChange]
GO
/****** Object:  Default [DF_ObjectTypeR_IsConjoinedSibling]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectTypeR] ADD  CONSTRAINT [DF_ObjectTypeR_IsConjoinedSibling]  DEFAULT ((0)) FOR [IsConjoinedSibling]
GO
/****** Object:  Default [DF__OutServic__Sourc__335592AB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutServiceHeartBeats] ADD  DEFAULT ((0)) FOR [SourceTransmissionsReceived]
GO
/****** Object:  Default [DF_OutServiceHeartBeats_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutServiceHeartBeats] ADD  CONSTRAINT [DF_OutServiceHeartBeats_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_OutServiceHeartBeats_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutServiceHeartBeats] ADD  CONSTRAINT [DF_OutServiceHeartBeats_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__OutTransm__Succe__2D9CB955]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissionLogs] ADD  DEFAULT ((0)) FOR [Succeeded]
GO
/****** Object:  Default [DF_OutTransmissionLogs_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissionLogs] ADD  CONSTRAINT [DF_OutTransmissionLogs_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_OutTransmissionLogs_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissionLogs] ADD  CONSTRAINT [DF_OutTransmissionLogs_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__OutTransm__Ackno__26EFBBC6]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissions] ADD  DEFAULT ((0)) FOR [Acknowledged]
GO
/****** Object:  Default [DF__OutTransm__Trans__27E3DFFF]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissions] ADD  DEFAULT ((0)) FOR [TransmissionSuccess]
GO
/****** Object:  Default [DF_OutTransmissions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissions] ADD  CONSTRAINT [DF_OutTransmissions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_OutTransmissions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissions] ADD  CONSTRAINT [DF_OutTransmissions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_RoleActions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RoleActions] ADD  CONSTRAINT [DF_RoleActions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_RoleActions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RoleActions] ADD  CONSTRAINT [DF_RoleActions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_RoleActions_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RoleActions] ADD  CONSTRAINT [DF_RoleActions_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_RolesAllModules_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RolesAllModules] ADD  CONSTRAINT [DF_RolesAllModules_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_RolesAllModules_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RolesAllModules] ADD  CONSTRAINT [DF_RolesAllModules_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_RolesAllModules_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RolesAllModules] ADD  CONSTRAINT [DF_RolesAllModules_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__RolesAllM__Modul__08162EEB]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RolesAllModules] ADD  DEFAULT ((1)) FOR [ModuleId]
GO
/****** Object:  Default [DF_RolesAllModules_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RolesAllModules] ADD  CONSTRAINT [DF_RolesAllModules_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_RolesAllModules_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RolesAllModules] ADD  CONSTRAINT [DF_RolesAllModules_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_SecurityGroup_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SecurityGroup] ADD  CONSTRAINT [DF_SecurityGroup_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_SecurityGroup_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SecurityGroup] ADD  CONSTRAINT [DF_SecurityGroup_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_SecurityGroupUser_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SecurityGroupUser] ADD  CONSTRAINT [DF_SecurityGroupUser_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_GroupCodingPatterns_CodingElementGroupID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SegmentedGroupCodingPatterns] ADD  CONSTRAINT [DF_GroupCodingPatterns_CodingElementGroupID]  DEFAULT ((-1)) FOR [CodingElementGroupID]
GO
/****** Object:  Default [DF_GroupCodingPatterns_MatchPercent]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SegmentedGroupCodingPatterns] ADD  CONSTRAINT [DF_GroupCodingPatterns_MatchPercent]  DEFAULT ((0)) FOR [MatchPercent]
GO
/****** Object:  Default [DF_GroupCodingPatterns_IsValidForAutoCode]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SegmentedGroupCodingPatterns] ADD  CONSTRAINT [DF_GroupCodingPatterns_IsValidForAutoCode]  DEFAULT ((0)) FOR [IsValidForAutoCode]
GO
/****** Object:  Default [DF_GroupCodingPatterns_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SegmentedGroupCodingPatterns] ADD  CONSTRAINT [DF_GroupCodingPatterns_Active]  DEFAULT ((0)) FOR [Active]
GO
/****** Object:  Default [DF_GroupCodingPatterns_AssociatedSynonymTermID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SegmentedGroupCodingPatterns] ADD  CONSTRAINT [DF_GroupCodingPatterns_AssociatedSynonymTermID]  DEFAULT ((-1)) FOR [AssociatedSynonymTermID]
GO
/****** Object:  Default [DF_SegmentedGroupCodingPatterns_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SegmentedGroupCodingPatterns] ADD  CONSTRAINT [DF_SegmentedGroupCodingPatterns_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_SegmentedGroupCodingPatterns_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SegmentedGroupCodingPatterns] ADD  CONSTRAINT [DF_SegmentedGroupCodingPatterns_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Segments_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Segments] ADD  CONSTRAINT [DF_Segments_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_Segments_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Segments] ADD  CONSTRAINT [DF_Segments_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_Segments_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Segments] ADD  CONSTRAINT [DF_Segments_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Segments_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Segments] ADD  CONSTRAINT [DF_Segments_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Segments_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Segments] ADD  CONSTRAINT [DF_Segments_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_ServiceCommandLogs_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ServiceCommandLogs] ADD  CONSTRAINT [DF_ServiceCommandLogs_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_ServiceCommandLogs_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ServiceCommandLogs] ADD  CONSTRAINT [DF_ServiceCommandLogs_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_ServiceCommands_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ServiceCommands] ADD  CONSTRAINT [DF_ServiceCommands_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_ServiceCommands_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ServiceCommands] ADD  CONSTRAINT [DF_ServiceCommands_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_ServiceHeartBeats_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ServiceHeartBeats] ADD  CONSTRAINT [DF_ServiceHeartBeats_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_SourceSystems_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SourceSystems] ADD  CONSTRAINT [DF_SourceSystems_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_SourceSystems_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SourceSystems] ADD  CONSTRAINT [DF_SourceSystems_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_StdStringTypeR_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StdStringTypeR] ADD  CONSTRAINT [DF_StdStringTypeR_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_StdStringTypeR_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StdStringTypeR] ADD  CONSTRAINT [DF_StdStringTypeR_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_StudyDictionaryRegistrations_StudyRegistrationTransmissionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryRegistrations] ADD  CONSTRAINT [DF_StudyDictionaryRegistrations_StudyRegistrationTransmissionID]  DEFAULT ((-1)) FOR [StudyRegistrationTransmissionID]
GO
/****** Object:  Default [DF_StudyDictionaryRegistrations_StudyDictionaryVersionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryRegistrations] ADD  CONSTRAINT [DF_StudyDictionaryRegistrations_StudyDictionaryVersionID]  DEFAULT ((-1)) FOR [StudyDictionaryVersionID]
GO
/****** Object:  Default [DF_StudyDictionaryRegistrations_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryRegistrations] ADD  CONSTRAINT [DF_StudyDictionaryRegistrations_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_StudyDictionaryRegistrations_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryRegistrations] ADD  CONSTRAINT [DF_StudyDictionaryRegistrations_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__StudyDict__KeepC__1D114BD1]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersion] ADD  DEFAULT ((0)) FOR [KeepCurrentVersion]
GO
/****** Object:  Default [DF_StudyDictionaryVersion_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersion] ADD  CONSTRAINT [DF_StudyDictionaryVersion_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_StudyDictionaryVersion_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersion] ADD  CONSTRAINT [DF_StudyDictionaryVersion_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__StudyDict__Initi__1FEDB87C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersion] ADD  DEFAULT ((-1)) FOR [InitialVersionOrdinal]
GO
/****** Object:  Default [DF__StudyDict__Numbe__20E1DCB5]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersion] ADD  DEFAULT ((0)) FOR [NumberOfMigrations]
GO
/****** Object:  Default [DF_StudyDictionaryVersion_StudyLock]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersion] ADD  CONSTRAINT [DF_StudyDictionaryVersion_StudyLock]  DEFAULT ((1)) FOR [StudyLock]
GO
/****** Object:  Default [DF_StudyDictionaryVersionHistory_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersionHistory] ADD  CONSTRAINT [DF_StudyDictionaryVersionHistory_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_StudyDictionaryVersionHistory_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersionHistory] ADD  CONSTRAINT [DF_StudyDictionaryVersionHistory_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_StudyRegistrationTransmissions_StudyRegistrationSucceeded]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyRegistrationTransmissions] ADD  CONSTRAINT [DF_StudyRegistrationTransmissions_StudyRegistrationSucceeded]  DEFAULT ((0)) FOR [StudyRegistrationSucceeded]
GO
/****** Object:  Default [DF_StudyRegistrationTransmissions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyRegistrationTransmissions] ADD  CONSTRAINT [DF_StudyRegistrationTransmissions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_StudyRegistrationTransmissions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyRegistrationTransmissions] ADD  CONSTRAINT [DF_StudyRegistrationTransmissions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__SUN__SourceCode___1936994C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SUN] ADD  DEFAULT ('') FOR [SourceCode_]
GO
/****** Object:  Default [DF__SynMigrRe__Creat__24B26D99]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynMigrReconciledCategoryR] ADD  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF__SynMigrRe__Updat__25A691D2]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynMigrReconciledCategoryR] ADD  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__SynonymHi__Prior__269AB60B]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymHistory] ADD  DEFAULT ((-1)) FOR [PriorSynonymTermID]
GO
/****** Object:  Default [DF_SynonymHistory_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymHistory] ADD  CONSTRAINT [DF_SynonymHistory_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_SynonymHistory_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymHistory] ADD  CONSTRAINT [DF_SynonymHistory_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__SynonymLo__Nodep__297722B6]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadingTable] ADD  DEFAULT ('') FOR [Nodepath]
GO
/****** Object:  Default [DF__SynonymLo__Activ__2A6B46EF]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadingTable] ADD  DEFAULT ((0)) FOR [ActivatedStatus]
GO
/****** Object:  Default [DF_SynonymLoadingTable_LineNumber]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadingTable] ADD  CONSTRAINT [DF_SynonymLoadingTable_LineNumber]  DEFAULT ((0)) FOR [LineNumber]
GO
/****** Object:  Default [DF_SynonymLoadingTable_MasterTermID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadingTable] ADD  CONSTRAINT [DF_SynonymLoadingTable_MasterTermID]  DEFAULT ((-1)) FOR [MasterTermID]
GO
/****** Object:  Default [DF_SynonymLoadStaging_MasterTermID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_MasterTermID]  DEFAULT ((-1)) FOR [MasterTermID]
GO
/****** Object:  Default [DF_SynonymLoadStaging_ActivatedStatus]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_ActivatedStatus]  DEFAULT ((0)) FOR [ActivatedStatus]
GO
/****** Object:  Default [DF_SynonymLoadStaging_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_SynonymLoadStaging_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_SynonymLoadStaging_ParentPath]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_ParentPath]  DEFAULT ('') FOR [ParentPath]
GO
/****** Object:  Default [DF_SynonymLoadStaging_UsePrimary]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_UsePrimary]  DEFAULT ((0)) FOR [UsePrimary]
GO
/****** Object:  Default [DF_SynonymLoadStaging_IsPrimary]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_IsPrimary]  DEFAULT ((0)) FOR [IsPrimary]
GO
/****** Object:  Default [DF_SynonymLoadStaging_CodingElementGroupID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymLoadStaging] ADD  CONSTRAINT [DF_SynonymLoadStaging_CodingElementGroupID]  DEFAULT ((0)) FOR [CodingElementGroupID]
GO
/****** Object:  Default [DF__SynonymMi__Final__34E8D562]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationEntries] ADD  DEFAULT (NULL) FOR [FinalMasterTermID]
GO
/****** Object:  Default [DF__SynonymMi__AreSu__35DCF99B]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationEntries] ADD  DEFAULT ((0)) FOR [AreSuggestionsGenerated]
GO
/****** Object:  Default [SynonymMigrationEntries_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationEntries] ADD  CONSTRAINT [SynonymMigrationEntries_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [SynonymMigrationEntries_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationEntries] ADD  CONSTRAINT [SynonymMigrationEntries_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__SynonymMi__UserI__38B96646]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationEntries] ADD  DEFAULT ((-2)) FOR [UserID]
GO
/****** Object:  Default [DF_SynonymMigrationMngmtNumberOfSynonyms]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationMngmt] ADD  CONSTRAINT [DF_SynonymMigrationMngmtNumberOfSynonyms]  DEFAULT ((0)) FOR [NumberOfSynonyms]
GO
/****** Object:  Default [SynonymMigrationMngmt_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationMngmt] ADD  CONSTRAINT [SynonymMigrationMngmt_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [SynonymMigrationMngmt_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationMngmt] ADD  CONSTRAINT [SynonymMigrationMngmt_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__SynonymMi__IsSyn__3C89F72A]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationMngmt] ADD  DEFAULT ((0)) FOR [IsSynonymListLoadedFromFile]
GO
/****** Object:  Default [DF__SynonymMi__Creat__3D7E1B63]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationStatusR] ADD  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF__SynonymMi__Updat__3E723F9C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationStatusR] ADD  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [SynonymMigrationSuggestions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationSuggestions] ADD  CONSTRAINT [SynonymMigrationSuggestions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [SynonymMigrationSuggestions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationSuggestions] ADD  CONSTRAINT [SynonymMigrationSuggestions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_SynonymMigrationSuggestions_IsPrimaryPath]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationSuggestions] ADD  CONSTRAINT [DF_SynonymMigrationSuggestions_IsPrimaryPath]  DEFAULT ((0)) FOR [IsPrimaryPath]
GO
/****** Object:  Default [DF_SystemVariables_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SystemVariables] ADD  CONSTRAINT [DF_SystemVariables_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF__THG__ATCCode___432CD318]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[THG] ADD  DEFAULT ('') FOR [ATCCode_]
GO
/****** Object:  Default [DF__THG__ATCTermID__4420F751]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[THG] ADD  DEFAULT ((0)) FOR [ATCTermID]
GO
/****** Object:  Default [DF__THG__MPTermID__45151B8A]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[THG] ADD  DEFAULT ((0)) FOR [MPTermID]
GO
/****** Object:  Default [DF_Timezones_InUse]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Timezones] ADD  CONSTRAINT [DF_Timezones_InUse]  DEFAULT ((1)) FOR [InUse]
GO
/****** Object:  Default [DF_Timezones_Default]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Timezones] ADD  CONSTRAINT [DF_Timezones_Default]  DEFAULT ((0)) FOR [Default]
GO
/****** Object:  Default [DF_Timezones_TZI]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Timezones] ADD  CONSTRAINT [DF_Timezones_TZI]  DEFAULT ((0)) FOR [TZI]
GO
/****** Object:  Default [DF_Timezones_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Timezones] ADD  CONSTRAINT [DF_Timezones_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Timezones_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Timezones] ADD  CONSTRAINT [DF_Timezones_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_TrackableObjects_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TrackableObjects] ADD  CONSTRAINT [DF_TrackableObjects_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_TrackableObjects_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TrackableObjects] ADD  CONSTRAINT [DF_TrackableObjects_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_TransmissionQueueItems_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems] ADD  CONSTRAINT [DF_TransmissionQueueItems_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_TransmissionQueueItems_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems] ADD  CONSTRAINT [DF_TransmissionQueueItems_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF__Transmiss__Cumul__3631FF56]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems] ADD  DEFAULT ((0)) FOR [CumulativeFailCount]
GO
/****** Object:  Default [DF__Transmiss__OutTr__3726238F]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems] ADD  DEFAULT ((-1)) FOR [OutTransmissionID]
GO
/****** Object:  Default [DF__Transmiss__Servi__381A47C8]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems] ADD  DEFAULT ((1)) FOR [ServiceWillContinueSending]
GO
/****** Object:  Default [DF__Transmiss__IsFor__390E6C01]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems] ADD  DEFAULT ((0)) FOR [IsForUnloadService]
GO
/****** Object:  Default [DF_UserAddresses_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserAddresses] ADD  CONSTRAINT [DF_UserAddresses_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_UserGroups_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserGroups] ADD  CONSTRAINT [DF_UserGroups_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_usergroups_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserGroups] ADD  CONSTRAINT [DF_usergroups_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_usermodules_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserModules] ADD  CONSTRAINT [DF_usermodules_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_UserStudyRole_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole] ADD  CONSTRAINT [DF_UserStudyRole_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_UserStudyRole_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole] ADD  CONSTRAINT [DF_UserStudyRole_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_UserStudyRole_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole] ADD  CONSTRAINT [DF_UserStudyRole_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_UserObjectRole_GrantOnObjectTypeId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole] ADD  CONSTRAINT [DF_UserObjectRole_GrantOnObjectTypeId]  DEFAULT ((7)) FOR [GrantOnObjectTypeId]
GO
/****** Object:  Default [DF_UserObjectRole_GrantToObjectTypeId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole] ADD  CONSTRAINT [DF_UserObjectRole_GrantToObjectTypeId]  DEFAULT ((17)) FOR [GrantToObjectTypeId]
GO
/****** Object:  Default [DF_UserObjectRole_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole] ADD  CONSTRAINT [DF_UserObjectRole_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_UserObjectRole_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole] ADD  CONSTRAINT [DF_UserObjectRole_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_UserObjectWorkflowRole_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectWorkflowRole] ADD  CONSTRAINT [DF_UserObjectWorkflowRole_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_UserObjectWorkflowRole_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectWorkflowRole] ADD  CONSTRAINT [DF_UserObjectWorkflowRole_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_UserObjectWorkflowRole_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectWorkflowRole] ADD  CONSTRAINT [DF_UserObjectWorkflowRole_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_UserPreferences_TaskActiveTabIndex]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_TaskActiveTabIndex]  DEFAULT ((1)) FOR [TaskActiveTabIndex]
GO
/****** Object:  Default [DF_UserPreferences_BrowserActiveTabIndex]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_BrowserActiveTabIndex]  DEFAULT ((0)) FOR [BrowserActiveTabIndex]
GO
/****** Object:  Default [DF_UserPreferences_PopupActiveTabIndex]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_PopupActiveTabIndex]  DEFAULT ((0)) FOR [PopupActiveTabIndex]
GO
/****** Object:  Default [DF_UserPreferences_HideTaskPropDetailRow0]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideTaskPropDetailRow0]  DEFAULT ((0)) FOR [HideTaskPropDetailRow0]
GO
/****** Object:  Default [DF_UserPreferences_HideTaskPropDetailRow1]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideTaskPropDetailRow1]  DEFAULT ((0)) FOR [HideTaskPropDetailRow1]
GO
/****** Object:  Default [DF_UserPreferences_HideTaskPropDetailRow2]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideTaskPropDetailRow2]  DEFAULT ((0)) FOR [HideTaskPropDetailRow2]
GO
/****** Object:  Default [DF_UserPreferences_HideTaskPropDetailRow3]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideTaskPropDetailRow3]  DEFAULT ((0)) FOR [HideTaskPropDetailRow3]
GO
/****** Object:  Default [DF_UserPreferences_HideBrowserPropDetailRow0]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideBrowserPropDetailRow0]  DEFAULT ((0)) FOR [HideBrowserPropDetailRow0]
GO
/****** Object:  Default [DF_UserPreferences_HideBrowserPropDetailRow1]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideBrowserPropDetailRow1]  DEFAULT ((0)) FOR [HideBrowserPropDetailRow1]
GO
/****** Object:  Default [DF_UserPreferences_HideBrowserPropDetailRow2]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideBrowserPropDetailRow2]  DEFAULT ((0)) FOR [HideBrowserPropDetailRow2]
GO
/****** Object:  Default [DF_UserPreferences_HideBrowserPropDetailRow3]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_HideBrowserPropDetailRow3]  DEFAULT ((0)) FOR [HideBrowserPropDetailRow3]
GO
/****** Object:  Default [DF_UserPreferences_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_UserPreferences_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserPreferences] ADD  CONSTRAINT [DF_UserPreferences_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Users_UserGroup]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UserGroup]  DEFAULT ((0)) FOR [GlobalRoleID]
GO
/****** Object:  Default [DF_Users_SponsorApproval]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_SponsorApproval]  DEFAULT ((0)) FOR [IsSponsorApprovalRequired]
GO
/****** Object:  Default [DF_Users_AccountActivation]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_AccountActivation]  DEFAULT ((0)) FOR [AccountActivation]
GO
/****** Object:  Default [DF_Users_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Users_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Users_GUID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_GUID]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF__Users__IsTrainin__6B44E613]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsTrainingOnly]
GO
/****** Object:  Default [DF__Users__IsClinica__6C390A4C]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsClinicalUser]
GO
/****** Object:  Default [DF_Users_IsReadOnly]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsReadOnly]  DEFAULT ((0)) FOR [IsReadOnly]
GO
/****** Object:  Default [DF_Users_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_Users_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_UserSettings_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserSettings] ADD  CONSTRAINT [DF_UserSettings_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_UserSettings_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserSettings] ADD  CONSTRAINT [DF_UserSettings_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_UserSettings_GUID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserSettings] ADD  CONSTRAINT [DF_UserSettings_GUID]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF_VariableDictAssignment_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[VariableDictAssignment] ADD  CONSTRAINT [DF_VariableDictAssignment_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_VariableDictAssignment_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[VariableDictAssignment] ADD  CONSTRAINT [DF_VariableDictAssignment_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_VariableDictUseAlgorithm_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[VariableDictUseAlgorithm] ADD  CONSTRAINT [DF_VariableDictUseAlgorithm_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_VariableDictUseAlgorithm_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[VariableDictUseAlgorithm] ADD  CONSTRAINT [DF_VariableDictUseAlgorithm_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WelcomeMessages_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessages] ADD  CONSTRAINT [DF_WelcomeMessages_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_WelcomeMessages_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessages] ADD  CONSTRAINT [DF_WelcomeMessages_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WelcomeMessages_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessages] ADD  CONSTRAINT [DF_WelcomeMessages_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WelcomeMessages_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessages] ADD  CONSTRAINT [DF_WelcomeMessages_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_WelcomeMessageTags_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessageTags] ADD  CONSTRAINT [DF_WelcomeMessageTags_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WelcomeMessageTags_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessageTags] ADD  CONSTRAINT [DF_WelcomeMessageTags_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WelcomeMessageTags_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessageTags] ADD  CONSTRAINT [DF_WelcomeMessageTags_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WelcomeMessageTags_UserDeactivated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessageTags] ADD  CONSTRAINT [DF_WelcomeMessageTags_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO
/****** Object:  Default [DF_WelcomeMessageTags_Deleted]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessageTags] ADD  CONSTRAINT [DF_WelcomeMessageTags_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_WorkflowActionItemData_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionItemData] ADD  CONSTRAINT [DF_WorkflowActionItemData_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowActionItems_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionItems] ADD  CONSTRAINT [DF_WorkflowActionItems_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowActionItems_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionItems] ADD  CONSTRAINT [DF_WorkflowActionItems_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowActionList_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionList] ADD  CONSTRAINT [DF_WorkflowActionList_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowActionList_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionList] ADD  CONSTRAINT [DF_WorkflowActionList_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowActionReasons_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionReasons] ADD  CONSTRAINT [DF_WorkflowActionReasons_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowActionReasons_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionReasons] ADD  CONSTRAINT [DF_WorkflowActionReasons_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowActionReasons_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionReasons] ADD  CONSTRAINT [DF_WorkflowActionReasons_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowActions_ReasonRequiredType]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActions] ADD  CONSTRAINT [DF_WorkflowActions_ReasonRequiredType]  DEFAULT ((0)) FOR [ReasonRequiredType]
GO
/****** Object:  Default [DF_WorkflowActions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActions] ADD  CONSTRAINT [DF_WorkflowActions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowActions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActions] ADD  CONSTRAINT [DF_WorkflowActions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowActions_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActions] ADD  CONSTRAINT [DF_WorkflowActions_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowActions_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActions] ADD  CONSTRAINT [DF_WorkflowActions_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowActions_ButtonStyle]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActions] ADD  CONSTRAINT [DF_WorkflowActions_ButtonStyle]  DEFAULT ((0)) FOR [ButtonStyle]
GO
/****** Object:  Default [DF_WorkflowReasons_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowReasons] ADD  CONSTRAINT [DF_WorkflowReasons_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowReasons_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowReasons] ADD  CONSTRAINT [DF_WorkflowReasons_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowReasons_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowReasons] ADD  CONSTRAINT [DF_WorkflowReasons_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowReasons_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowReasons] ADD  CONSTRAINT [DF_WorkflowReasons_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowRoleActions_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoleActions] ADD  CONSTRAINT [DF_WorkflowRoleActions_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowRoleActions_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoleActions] ADD  CONSTRAINT [DF_WorkflowRoleActions_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowRoles_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoles] ADD  CONSTRAINT [DF_WorkflowRoles_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowRoles_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoles] ADD  CONSTRAINT [DF_WorkflowRoles_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowRoles_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoles] ADD  CONSTRAINT [DF_WorkflowRoles_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_Workflows_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Workflows] ADD  CONSTRAINT [DF_Workflows_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_Workflows_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Workflows] ADD  CONSTRAINT [DF_Workflows_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowStateActions_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStateActions] ADD  CONSTRAINT [DF_WorkflowStateActions_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowStateIcons_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStateIcons] ADD  CONSTRAINT [DF_WorkflowStateIcons_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowStateIcons_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStateIcons] ADD  CONSTRAINT [DF_WorkflowStateIcons_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowStates_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStates] ADD  CONSTRAINT [DF_WorkflowStates_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowStates_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStates] ADD  CONSTRAINT [DF_WorkflowStates_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowStates_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStates] ADD  CONSTRAINT [DF_WorkflowStates_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF__WorkflowS__IsRec__1CDC41A7]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStates] ADD  DEFAULT ((0)) FOR [IsReconsiderState]
GO
/****** Object:  Default [DF_WorkflowStates_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStates] ADD  CONSTRAINT [DF_WorkflowStates_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowSystemActionR_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowSystemActionR] ADD  CONSTRAINT [DF_WorkflowSystemActionR_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowSystemActionR_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowSystemActionR] ADD  CONSTRAINT [DF_WorkflowSystemActionR_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowSystemActionR_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowSystemActionR] ADD  CONSTRAINT [DF_WorkflowSystemActionR_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowTaskHistory_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTaskHistory] ADD  CONSTRAINT [DF_WorkflowTaskHistory_Updated]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowTaskHistory_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTaskHistory] ADD  CONSTRAINT [DF_WorkflowTaskHistory_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowTasks_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTasks] ADD  CONSTRAINT [DF_WorkflowTasks_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_WorkflowTasks_Created]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTasks] ADD  CONSTRAINT [DF_WorkflowTasks_Created]  DEFAULT (getutcdate()) FOR [Created]
GO
/****** Object:  Default [DF_WorkflowTasks_Updated]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTasks] ADD  CONSTRAINT [DF_WorkflowTasks_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
/****** Object:  Default [DF_WorkflowTasks_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTasks] ADD  CONSTRAINT [DF_WorkflowTasks_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowVariableLookupValues_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowVariableLookupValues] ADD  CONSTRAINT [DF_WorkflowVariableLookupValues_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowVariables_SegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowVariables] ADD  CONSTRAINT [DF_WorkflowVariables_SegmentId]  DEFAULT ((1)) FOR [SegmentId]
GO
/****** Object:  Default [DF_WorkflowVariables_Active]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowVariables] ADD  CONSTRAINT [DF_WorkflowVariables_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  ForeignKey [FK_AckNackTransmissions_CodingElementID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AckNackTransmissions]  WITH CHECK ADD  CONSTRAINT [FK_AckNackTransmissions_CodingElementID] FOREIGN KEY([CodingElementID])
REFERENCES [dbo].[CodingElements] ([CodingElementId])
GO
ALTER TABLE [dbo].[AckNackTransmissions] CHECK CONSTRAINT [FK_AckNackTransmissions_CodingElementID]
GO
/****** Object:  ForeignKey [FK_Activations_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Activations]  WITH CHECK ADD  CONSTRAINT [FK_Activations_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[Activations] CHECK CONSTRAINT [FK_Activations_Segments]
GO
/****** Object:  ForeignKey [FK_ApiClients_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApiClients]  WITH CHECK ADD  CONSTRAINT [FK_ApiClients_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[ApiClients] CHECK CONSTRAINT [FK_ApiClients_Segments]
GO
/****** Object:  ForeignKey [FK_ApiCronSchedules_ApiAdminId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApiCronSchedules]  WITH CHECK ADD  CONSTRAINT [FK_ApiCronSchedules_ApiAdminId] FOREIGN KEY([ApiAdminId])
REFERENCES [dbo].[ApplicationAdmin] ([ApplicationAdminID])
GO
ALTER TABLE [dbo].[ApiCronSchedules] CHECK CONSTRAINT [FK_ApiCronSchedules_ApiAdminId]
GO
/****** Object:  ForeignKey [FK_ApiCronSchedules_CronActionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApiCronSchedules]  WITH CHECK ADD  CONSTRAINT [FK_ApiCronSchedules_CronActionID] FOREIGN KEY([CronActionID])
REFERENCES [dbo].[CronActions] ([CronActionID])
GO
ALTER TABLE [dbo].[ApiCronSchedules] CHECK CONSTRAINT [FK_ApiCronSchedules_CronActionID]
GO
/****** Object:  ForeignKey [FK_Application_ApplicationType]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Application]  WITH CHECK ADD  CONSTRAINT [FK_Application_ApplicationType] FOREIGN KEY([ApplicationTypeID])
REFERENCES [dbo].[ApplicationType] ([ApplicationTypeID])
GO
ALTER TABLE [dbo].[Application] CHECK CONSTRAINT [FK_Application_ApplicationType]
GO
/****** Object:  ForeignKey [FK_ApplicationAdmin_Application]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApplicationAdmin]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationAdmin_Application] FOREIGN KEY([ApplicationID])
REFERENCES [dbo].[Application] ([ApplicationID])
GO
ALTER TABLE [dbo].[ApplicationAdmin] CHECK CONSTRAINT [FK_ApplicationAdmin_Application]
GO
/****** Object:  ForeignKey [FK_AppSourceSystems_ApplicationId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApplicationSourceSystems]  WITH CHECK ADD  CONSTRAINT [FK_AppSourceSystems_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[ApplicationR] ([ApplicationID])
GO
ALTER TABLE [dbo].[ApplicationSourceSystems] CHECK CONSTRAINT [FK_AppSourceSystems_ApplicationId]
GO
/****** Object:  ForeignKey [FK_AppSourceSystems_SourceSystemId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApplicationSourceSystems]  WITH CHECK ADD  CONSTRAINT [FK_AppSourceSystems_SourceSystemId] FOREIGN KEY([SourceSystemId])
REFERENCES [dbo].[SourceSystems] ([SourceSystemId])
GO
ALTER TABLE [dbo].[ApplicationSourceSystems] CHECK CONSTRAINT [FK_AppSourceSystems_SourceSystemId]
GO
/****** Object:  ForeignKey [FK_AppSourceSystems_WorkflowId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApplicationSourceSystems]  WITH CHECK ADD  CONSTRAINT [FK_AppSourceSystems_WorkflowId] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[ApplicationSourceSystems] CHECK CONSTRAINT [FK_AppSourceSystems_WorkflowId]
GO
/****** Object:  ForeignKey [FK_ApplicationTrackableObject_Application]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApplicationTrackableObject]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationTrackableObject_Application] FOREIGN KEY([ApplicationID])
REFERENCES [dbo].[Application] ([ApplicationID])
GO
ALTER TABLE [dbo].[ApplicationTrackableObject] CHECK CONSTRAINT [FK_ApplicationTrackableObject_Application]
GO
/****** Object:  ForeignKey [FK_ApplicationTrackableObject_TrackableObjects]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ApplicationTrackableObject]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationTrackableObject_TrackableObjects] FOREIGN KEY([TrackableObjectID])
REFERENCES [dbo].[TrackableObjects] ([TrackableObjectID])
GO
ALTER TABLE [dbo].[ApplicationTrackableObject] CHECK CONSTRAINT [FK_ApplicationTrackableObject_TrackableObjects]
GO
/****** Object:  ForeignKey [FK_AuditDetailTypes_AuditTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuditDetailTypes]  WITH CHECK ADD  CONSTRAINT [FK_AuditDetailTypes_AuditTypeR] FOREIGN KEY([AuditTypeId])
REFERENCES [dbo].[AuditTypeR] ([AuditTypeId])
GO
ALTER TABLE [dbo].[AuditDetailTypes] CHECK CONSTRAINT [FK_AuditDetailTypes_AuditTypeR]
GO
/****** Object:  ForeignKey [FK_Audits_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Audits]  WITH CHECK ADD  CONSTRAINT [FK_Audits_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[Audits] CHECK CONSTRAINT [FK_Audits_Segments]
GO
/****** Object:  ForeignKey [FK_AuditSources_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuditSources]  WITH CHECK ADD  CONSTRAINT [FK_AuditSources_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[AuditSources] CHECK CONSTRAINT [FK_AuditSources_Segments]
GO
/****** Object:  ForeignKey [FK_AuditTags_AuditCategories]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuditTags]  WITH CHECK ADD  CONSTRAINT [FK_AuditTags_AuditCategories] FOREIGN KEY([AuditCategoryId])
REFERENCES [dbo].[AuditCategories] ([AuditCategoryId])
GO
ALTER TABLE [dbo].[AuditTags] CHECK CONSTRAINT [FK_AuditTags_AuditCategories]
GO
/****** Object:  ForeignKey [FK_AuditTags_AuditDetailTypes]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuditTags]  WITH CHECK ADD  CONSTRAINT [FK_AuditTags_AuditDetailTypes] FOREIGN KEY([AuditDetailTypeId])
REFERENCES [dbo].[AuditDetailTypes] ([AuditDetailTypeId])
GO
ALTER TABLE [dbo].[AuditTags] CHECK CONSTRAINT [FK_AuditTags_AuditDetailTypes]
GO
/****** Object:  ForeignKey [FK_AuthenticationSources_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[AuthenticationSources]  WITH CHECK ADD  CONSTRAINT [FK_AuthenticationSources_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[AuthenticationSources] CHECK CONSTRAINT [FK_AuthenticationSources_Segments]
GO
/****** Object:  ForeignKey [FK_Authenticators_ApiClients]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Authenticators]  WITH CHECK ADD  CONSTRAINT [FK_Authenticators_ApiClients] FOREIGN KEY([ApiClientID])
REFERENCES [dbo].[ApiClients] ([ApiClientID])
GO
ALTER TABLE [dbo].[Authenticators] CHECK CONSTRAINT [FK_Authenticators_ApiClients]
GO
/****** Object:  ForeignKey [FK_Authenticators_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Authenticators]  WITH CHECK ADD  CONSTRAINT [FK_Authenticators_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[Authenticators] CHECK CONSTRAINT [FK_Authenticators_Segments]
GO
/****** Object:  ForeignKey [FK_CoderSegments_CoderSegmentTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CoderSegments]  WITH CHECK ADD  CONSTRAINT [FK_CoderSegments_CoderSegmentTypeR] FOREIGN KEY([CoderSegmentTypeId])
REFERENCES [dbo].[CoderSegmentTypeR] ([CoderSegmentTypeID])
GO
ALTER TABLE [dbo].[CoderSegments] CHECK CONSTRAINT [FK_CoderSegments_CoderSegmentTypeR]
GO
/****** Object:  ForeignKey [FK_CoderSegments_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CoderSegments]  WITH CHECK ADD  CONSTRAINT [FK_CoderSegments_Segments] FOREIGN KEY([SegmentId])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[CoderSegments] CHECK CONSTRAINT [FK_CoderSegments_Segments]
GO
/****** Object:  ForeignKey [FK_Assignment_CodingElements]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingAssignment]  WITH CHECK ADD  CONSTRAINT [FK_Assignment_CodingElements] FOREIGN KEY([CodingElementID])
REFERENCES [dbo].[CodingElements] ([CodingElementId])
GO
ALTER TABLE [dbo].[CodingAssignment] CHECK CONSTRAINT [FK_Assignment_CodingElements]
GO
/****** Object:  ForeignKey [FK_CodingElements_CodingRequest]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements]  WITH CHECK ADD  CONSTRAINT [FK_CodingElements_CodingRequest] FOREIGN KEY([CodingRequestId])
REFERENCES [dbo].[CodingRequests] ([CodingRequestId])
GO
ALTER TABLE [dbo].[CodingElements] CHECK CONSTRAINT [FK_CodingElements_CodingRequest]
GO
/****** Object:  ForeignKey [FK_CodingElements_DictionaryLevel]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements]  WITH CHECK ADD  CONSTRAINT [FK_CodingElements_DictionaryLevel] FOREIGN KEY([DictionaryLevelId])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[CodingElements] CHECK CONSTRAINT [FK_CodingElements_DictionaryLevel]
GO
/****** Object:  ForeignKey [FK_CodingElements_WorkflowTasks]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingElements]  WITH CHECK ADD  CONSTRAINT [FK_CodingElements_WorkflowTasks] FOREIGN KEY([WorkflowTaskId])
REFERENCES [dbo].[WorkflowTasks] ([WorkflowTaskID])
GO
ALTER TABLE [dbo].[CodingElements] CHECK CONSTRAINT [FK_CodingElements_WorkflowTasks]
GO
/****** Object:  ForeignKey [FK_CodingRejections_Segment]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRejections]  WITH CHECK ADD  CONSTRAINT [FK_CodingRejections_Segment] FOREIGN KEY([SegmentId])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[CodingRejections] CHECK CONSTRAINT [FK_CodingRejections_Segment]
GO
/****** Object:  ForeignKey [FK_CodingRejections_WorkflowReasons]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRejections]  WITH CHECK ADD  CONSTRAINT [FK_CodingRejections_WorkflowReasons] FOREIGN KEY([WorkflowReasonID])
REFERENCES [dbo].[WorkflowReasons] ([WorkflowReasonID])
GO
ALTER TABLE [dbo].[CodingRejections] CHECK CONSTRAINT [FK_CodingRejections_WorkflowReasons]
GO
/****** Object:  ForeignKey [FK_CodingRequest_SourceSystem]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingRequests]  WITH CHECK ADD  CONSTRAINT [FK_CodingRequest_SourceSystem] FOREIGN KEY([SourceSystemId])
REFERENCES [dbo].[SourceSystems] ([SourceSystemId])
GO
ALTER TABLE [dbo].[CodingRequests] CHECK CONSTRAINT [FK_CodingRequest_SourceSystem]
GO
/****** Object:  ForeignKey [FK_CodingResourceTransmission_SourceSystems]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingResourceTransmission]  WITH CHECK ADD  CONSTRAINT [FK_CodingResourceTransmission_SourceSystems] FOREIGN KEY([SourceSystemID])
REFERENCES [dbo].[SourceSystems] ([SourceSystemId])
GO
ALTER TABLE [dbo].[CodingResourceTransmission] CHECK CONSTRAINT [FK_CodingResourceTransmission_SourceSystems]
GO
/****** Object:  ForeignKey [FK_Dict_CodingAlgorithm]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceAlgorithm]  WITH CHECK ADD  CONSTRAINT [FK_Dict_CodingAlgorithm] FOREIGN KEY([MedicalDictionaryUseAlgorithmID])
REFERENCES [dbo].[MedicalDictionaryUseAlgorithm] ([MedicalDictionaryUseAlgorithmID])
GO
ALTER TABLE [dbo].[CodingSourceAlgorithm] CHECK CONSTRAINT [FK_Dict_CodingAlgorithm]
GO
/****** Object:  ForeignKey [FK_CodingSourceTerms_CodingElement]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTerms]  WITH CHECK ADD  CONSTRAINT [FK_CodingSourceTerms_CodingElement] FOREIGN KEY([CodingElementId])
REFERENCES [dbo].[CodingElements] ([CodingElementId])
GO
ALTER TABLE [dbo].[CodingSourceTerms] CHECK CONSTRAINT [FK_CodingSourceTerms_CodingElement]
GO
/****** Object:  ForeignKey [FK_CodingSourceTerms_DictionaryLevel]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTerms]  WITH CHECK ADD  CONSTRAINT [FK_CodingSourceTerms_DictionaryLevel] FOREIGN KEY([DictionaryLevelId])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[CodingSourceTerms] CHECK CONSTRAINT [FK_CodingSourceTerms_DictionaryLevel]
GO
/****** Object:  ForeignKey [FK_CodingSourceTerms_DictionaryVersion]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTerms]  WITH CHECK ADD  CONSTRAINT [FK_CodingSourceTerms_DictionaryVersion] FOREIGN KEY([DictionaryVersionId])
REFERENCES [dbo].[MedicalDictionaryVersion] ([DictionaryVersionId])
GO
ALTER TABLE [dbo].[CodingSourceTerms] CHECK CONSTRAINT [FK_CodingSourceTerms_DictionaryVersion]
GO
/****** Object:  ForeignKey [FK_CodingSourceTerms_SourceSystem]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSourceTerms]  WITH CHECK ADD  CONSTRAINT [FK_CodingSourceTerms_SourceSystem] FOREIGN KEY([SourceSystemId])
REFERENCES [dbo].[SourceSystems] ([SourceSystemId])
GO
ALTER TABLE [dbo].[CodingSourceTerms] CHECK CONSTRAINT [FK_CodingSourceTerms_SourceSystem]
GO
/****** Object:  ForeignKey [FK_Suggestion_DictionaryVersion]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSuggestions]  WITH CHECK ADD  CONSTRAINT [FK_Suggestion_DictionaryVersion] FOREIGN KEY([DictionaryVersionId])
REFERENCES [dbo].[MedicalDictionaryVersion] ([DictionaryVersionId])
GO
ALTER TABLE [dbo].[CodingSuggestions] CHECK CONSTRAINT [FK_Suggestion_DictionaryVersion]
GO
/****** Object:  ForeignKey [FK_Suggestions_DictionaryTerm]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[CodingSuggestions]  WITH CHECK ADD  CONSTRAINT [FK_Suggestions_DictionaryTerm] FOREIGN KEY([MedicalDictionaryTermID])
REFERENCES [dbo].[MedicalDictionaryTerm] ([TermId])
GO
ALTER TABLE [dbo].[CodingSuggestions] CHECK CONSTRAINT [FK_Suggestions_DictionaryTerm]
GO
/****** Object:  ForeignKey [FK_Configuration_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Configuration]  WITH CHECK ADD  CONSTRAINT [FK_Configuration_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[Configuration] CHECK CONSTRAINT [FK_Configuration_Segments]
GO
/****** Object:  ForeignKey [FK_DeletedConfigurations_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DeletedConfigurations]  WITH CHECK ADD  CONSTRAINT [FK_DeletedConfigurations_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[DeletedConfigurations] CHECK CONSTRAINT [FK_DeletedConfigurations_Segments]
GO
/****** Object:  ForeignKey [FK_DictionaryLicenceInformations_SegmentID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DictionaryLicenceInformations]  WITH CHECK ADD  CONSTRAINT [FK_DictionaryLicenceInformations_SegmentID] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[DictionaryLicenceInformations] CHECK CONSTRAINT [FK_DictionaryLicenceInformations_SegmentID]
GO
/****** Object:  ForeignKey [FK_DictionaryLicenceInformations_UserId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DictionaryLicenceInformations]  WITH CHECK ADD  CONSTRAINT [FK_DictionaryLicenceInformations_UserId] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DictionaryLicenceInformations] CHECK CONSTRAINT [FK_DictionaryLicenceInformations_UserId]
GO
/****** Object:  ForeignKey [FK_DictionaryVersionSubscriptions_ObjectSegmentId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DictionaryVersionSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_DictionaryVersionSubscriptions_ObjectSegmentId] FOREIGN KEY([ObjectSegmentID])
REFERENCES [dbo].[ObjectSegments] ([ObjectSegmentId])
GO
ALTER TABLE [dbo].[DictionaryVersionSubscriptions] CHECK CONSTRAINT [FK_DictionaryVersionSubscriptions_ObjectSegmentId]
GO
/****** Object:  ForeignKey [FK_DictionaryVersionSubscriptions_UserId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DictionaryVersionSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_DictionaryVersionSubscriptions_UserId] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DictionaryVersionSubscriptions] CHECK CONSTRAINT [FK_DictionaryVersionSubscriptions_UserId]
GO
/****** Object:  ForeignKey [FK_DoNotAutoCodeTerms_MedicalDictionary]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms]  WITH CHECK ADD  CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionary] FOREIGN KEY([MedicalDictionaryId])
REFERENCES [dbo].[MedicalDictionary] ([MedicalDictionaryId])
GO
ALTER TABLE [dbo].[DoNotAutoCodeTerms] CHECK CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionary]
GO
/****** Object:  ForeignKey [FK_DoNotAutoCodeTerms_MedicalDictionaryLevel]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms]  WITH CHECK ADD  CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryLevel] FOREIGN KEY([DictionaryLevelId])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[DoNotAutoCodeTerms] CHECK CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryLevel]
GO
/****** Object:  ForeignKey [FK_DoNotAutoCodeTerms_MedicalDictionaryTerm]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms]  WITH CHECK ADD  CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryTerm] FOREIGN KEY([TermId])
REFERENCES [dbo].[MedicalDictionaryTerm] ([TermId])
GO
ALTER TABLE [dbo].[DoNotAutoCodeTerms] CHECK CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryTerm]
GO
/****** Object:  ForeignKey [FK_DoNotAutoCodeTerms_MedicalDictionaryVersion]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms]  WITH CHECK ADD  CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryVersion] FOREIGN KEY([DictionaryVersionId])
REFERENCES [dbo].[MedicalDictionaryVersion] ([DictionaryVersionId])
GO
ALTER TABLE [dbo].[DoNotAutoCodeTerms] CHECK CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryVersion]
GO
/****** Object:  ForeignKey [FK_DoNotAutoCodeTerms_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms]  WITH CHECK ADD  CONSTRAINT [FK_DoNotAutoCodeTerms_Segments] FOREIGN KEY([SegmentId])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[DoNotAutoCodeTerms] CHECK CONSTRAINT [FK_DoNotAutoCodeTerms_Segments]
GO
/****** Object:  ForeignKey [FK_DoNotAutoCodeTerms_Users]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[DoNotAutoCodeTerms]  WITH CHECK ADD  CONSTRAINT [FK_DoNotAutoCodeTerms_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DoNotAutoCodeTerms] CHECK CONSTRAINT [FK_DoNotAutoCodeTerms_Users]
GO
/****** Object:  ForeignKey [FK_HealthCheckRuns_HealthCheckID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HealthCheckRuns]  WITH CHECK ADD  CONSTRAINT [FK_HealthCheckRuns_HealthCheckID] FOREIGN KEY([HealthCheckID])
REFERENCES [dbo].[HealthChecksR] ([HealthCheckID])
GO
ALTER TABLE [dbo].[HealthCheckRuns] CHECK CONSTRAINT [FK_HealthCheckRuns_HealthCheckID]
GO
/****** Object:  ForeignKey [FK_HealthCheckStatistics_HealthCheckRunID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[HealthCheckStatistics]  WITH CHECK ADD  CONSTRAINT [FK_HealthCheckStatistics_HealthCheckRunID] FOREIGN KEY([HealthCheckRunID])
REFERENCES [dbo].[HealthCheckRuns] ([HealthCheckRunID])
GO
ALTER TABLE [dbo].[HealthCheckStatistics] CHECK CONSTRAINT [FK_HealthCheckStatistics_HealthCheckRunID]
GO
/****** Object:  ForeignKey [FK_ImpliedActionTypes_ActionTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ImpliedActionTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_ImpliedActionTypes_ActionTypeR] FOREIGN KEY([ActionType])
REFERENCES [dbo].[ActionTypeR] ([ActionType])
GO
ALTER TABLE [dbo].[ImpliedActionTypes] CHECK CONSTRAINT [FK_ImpliedActionTypes_ActionTypeR]
GO
/****** Object:  ForeignKey [FK_ImpliedActionTypes_ActionTypeR1]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ImpliedActionTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_ImpliedActionTypes_ActionTypeR1] FOREIGN KEY([ImpliedActionType])
REFERENCES [dbo].[ActionTypeR] ([ActionType])
GO
ALTER TABLE [dbo].[ImpliedActionTypes] CHECK CONSTRAINT [FK_ImpliedActionTypes_ActionTypeR1]
GO
/****** Object:  ForeignKey [FK_installedmodules_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[InstalledModules]  WITH CHECK ADD  CONSTRAINT [FK_installedmodules_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[InstalledModules] CHECK CONSTRAINT [FK_installedmodules_Segments]
GO
/****** Object:  ForeignKey [FK_Interactions_Users]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Interactions]  WITH CHECK ADD  CONSTRAINT [FK_Interactions_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Interactions] CHECK CONSTRAINT [FK_Interactions_Users]
GO
/****** Object:  ForeignKey [FK_LclDataStringContexts_ObjectTypeId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LclDataStringContexts]  WITH CHECK ADD  CONSTRAINT [FK_LclDataStringContexts_ObjectTypeId] FOREIGN KEY([ObjectTypeID])
REFERENCES [dbo].[ObjectTypeR] ([ObjectTypeID])
GO
ALTER TABLE [dbo].[LclDataStringContexts] CHECK CONSTRAINT [FK_LclDataStringContexts_ObjectTypeId]
GO
/****** Object:  ForeignKey [FK_LclDataStringReferences_LclStringID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LclDataStringReferences]  WITH CHECK ADD  CONSTRAINT [FK_LclDataStringReferences_LclStringID] FOREIGN KEY([LclStringID])
REFERENCES [dbo].[LocalizedDataStringPKs] ([StringId])
GO
ALTER TABLE [dbo].[LclDataStringReferences] CHECK CONSTRAINT [FK_LclDataStringReferences_LclStringID]
GO
/****** Object:  ForeignKey [FK_LclDataStringReferences_ObjectTypeId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LclDataStringReferences]  WITH CHECK ADD  CONSTRAINT [FK_LclDataStringReferences_ObjectTypeId] FOREIGN KEY([ObjectTypeID])
REFERENCES [dbo].[ObjectTypeR] ([ObjectTypeID])
GO
ALTER TABLE [dbo].[LclDataStringReferences] CHECK CONSTRAINT [FK_LclDataStringReferences_ObjectTypeId]
GO
/****** Object:  ForeignKey [FK_LclDataStringReferences_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LclDataStringReferences]  WITH CHECK ADD  CONSTRAINT [FK_LclDataStringReferences_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[LclDataStringReferences] CHECK CONSTRAINT [FK_LclDataStringReferences_Segments]
GO
/****** Object:  ForeignKey [FK_Localizations_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Localizations]  WITH CHECK ADD  CONSTRAINT [FK_Localizations_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[Localizations] CHECK CONSTRAINT [FK_Localizations_Segments]
GO
/****** Object:  ForeignKey [FK_LocalizedDataStringPKs_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LocalizedDataStringPKs]  WITH CHECK ADD  CONSTRAINT [FK_LocalizedDataStringPKs_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[LocalizedDataStringPKs] CHECK CONSTRAINT [FK_LocalizedDataStringPKs_Segments]
GO
/****** Object:  ForeignKey [FK_LocalizedStrings_StdStringTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[LocalizedStrings]  WITH CHECK ADD  CONSTRAINT [FK_LocalizedStrings_StdStringTypeR] FOREIGN KEY([StringTypeID])
REFERENCES [dbo].[StdStringTypeR] ([StringTypeID])
GO
ALTER TABLE [dbo].[LocalizedStrings] CHECK CONSTRAINT [FK_LocalizedStrings_StdStringTypeR]
GO
/****** Object:  ForeignKey [FK_MedDictLevelCmpntUpdates_Fn_MedicalDictLevelComponents]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictLevelCmpntUpdates]  WITH CHECK ADD  CONSTRAINT [FK_MedDictLevelCmpntUpdates_Fn_MedicalDictLevelComponents] FOREIGN KEY([FinalLevelComponentID])
REFERENCES [dbo].[MedicalDictLevelComponents] ([ID])
GO
ALTER TABLE [dbo].[MedDictLevelCmpntUpdates] CHECK CONSTRAINT [FK_MedDictLevelCmpntUpdates_Fn_MedicalDictLevelComponents]
GO
/****** Object:  ForeignKey [FK_MedDictLevelCmpntUpdates_In_MedicalDictLevelComponents]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictLevelCmpntUpdates]  WITH CHECK ADD  CONSTRAINT [FK_MedDictLevelCmpntUpdates_In_MedicalDictLevelComponents] FOREIGN KEY([InitialLevelComponentID])
REFERENCES [dbo].[MedicalDictLevelComponents] ([ID])
GO
ALTER TABLE [dbo].[MedDictLevelCmpntUpdates] CHECK CONSTRAINT [FK_MedDictLevelCmpntUpdates_In_MedicalDictLevelComponents]
GO
/****** Object:  ForeignKey [FK_MedDictSynonymWasteBasket_MedicalDictionaryLevel]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictSynonymWasteBasket]  WITH CHECK ADD  CONSTRAINT [FK_MedDictSynonymWasteBasket_MedicalDictionaryLevel] FOREIGN KEY([DictionaryLevelID])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[MedDictSynonymWasteBasket] CHECK CONSTRAINT [FK_MedDictSynonymWasteBasket_MedicalDictionaryLevel]
GO
/****** Object:  ForeignKey [FK_MedDictVerLvlComponents_MedicalDictComponentTypes]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedDictVerLvlComponents]  WITH CHECK ADD  CONSTRAINT [FK_MedDictVerLvlComponents_MedicalDictComponentTypes] FOREIGN KEY([ComponentTypeID])
REFERENCES [dbo].[MedicalDictComponentTypes] ([ComponentTypeID])
GO
ALTER TABLE [dbo].[MedDictVerLvlComponents] CHECK CONSTRAINT [FK_MedDictVerLvlComponents_MedicalDictComponentTypes]
GO
/****** Object:  ForeignKey [FK_LevelMapping_FromLevel]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryLevelMapping]  WITH CHECK ADD  CONSTRAINT [FK_LevelMapping_FromLevel] FOREIGN KEY([FromDictionaryLevelId])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[MedicalDictionaryLevelMapping] CHECK CONSTRAINT [FK_LevelMapping_FromLevel]
GO
/****** Object:  ForeignKey [FK_LevelMapping_ToLevel]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryLevelMapping]  WITH CHECK ADD  CONSTRAINT [FK_LevelMapping_ToLevel] FOREIGN KEY([ToDictionaryLevelId])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[MedicalDictionaryLevelMapping] CHECK CONSTRAINT [FK_LevelMapping_ToLevel]
GO
/****** Object:  ForeignKey [FK_MedicalDictionaryTemplateLevels_DictionaryLevelId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTemplateLevels]  WITH CHECK ADD  CONSTRAINT [FK_MedicalDictionaryTemplateLevels_DictionaryLevelId] FOREIGN KEY([DictionaryLevelId])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[MedicalDictionaryTemplateLevels] CHECK CONSTRAINT [FK_MedicalDictionaryTemplateLevels_DictionaryLevelId]
GO
/****** Object:  ForeignKey [FK_MedicalDictionaryTemplateLevels_TemplateId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTemplateLevels]  WITH CHECK ADD  CONSTRAINT [FK_MedicalDictionaryTemplateLevels_TemplateId] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[MedicalDictionaryTemplates] ([TemplateId])
GO
ALTER TABLE [dbo].[MedicalDictionaryTemplateLevels] CHECK CONSTRAINT [FK_MedicalDictionaryTemplateLevels_TemplateId]
GO
/****** Object:  ForeignKey [FK_TermRel_FromDictionaryTerm]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTermRel]  WITH CHECK ADD  CONSTRAINT [FK_TermRel_FromDictionaryTerm] FOREIGN KEY([FromTermId])
REFERENCES [dbo].[MedicalDictionaryTerm] ([TermId])
GO
ALTER TABLE [dbo].[MedicalDictionaryTermRel] CHECK CONSTRAINT [FK_TermRel_FromDictionaryTerm]
GO
/****** Object:  ForeignKey [FK_TermRel_ToDictionaryTerm]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryTermRel]  WITH CHECK ADD  CONSTRAINT [FK_TermRel_ToDictionaryTerm] FOREIGN KEY([ToTermId])
REFERENCES [dbo].[MedicalDictionaryTerm] ([TermId])
GO
ALTER TABLE [dbo].[MedicalDictionaryTermRel] CHECK CONSTRAINT [FK_TermRel_ToDictionaryTerm]
GO
/****** Object:  ForeignKey [FK_Use_Algorithm]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryUseAlgorithm]  WITH CHECK ADD  CONSTRAINT [FK_Use_Algorithm] FOREIGN KEY([MedicalDictionaryAlgorithmID])
REFERENCES [dbo].[MedicalDictionaryAlgorithm] ([MedicalDictionaryAlgorithmID])
GO
ALTER TABLE [dbo].[MedicalDictionaryUseAlgorithm] CHECK CONSTRAINT [FK_Use_Algorithm]
GO
/****** Object:  ForeignKey [FK_MedicalDictionaryVersionLevelRecursion_DictionaryLevelID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictionaryVersionLevelRecursion]  WITH CHECK ADD  CONSTRAINT [FK_MedicalDictionaryVersionLevelRecursion_DictionaryLevelID] FOREIGN KEY([DictionaryLevelID])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[MedicalDictionaryVersionLevelRecursion] CHECK CONSTRAINT [FK_MedicalDictionaryVersionLevelRecursion_DictionaryLevelID]
GO
/****** Object:  ForeignKey [FK_LevelComponents_Level]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictLevelComponents]  WITH CHECK ADD  CONSTRAINT [FK_LevelComponents_Level] FOREIGN KEY([DictionaryLevelId])
REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId])
GO
ALTER TABLE [dbo].[MedicalDictLevelComponents] CHECK CONSTRAINT [FK_LevelComponents_Level]
GO
/****** Object:  ForeignKey [FK_LevelComponents_Types]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictLevelComponents]  WITH CHECK ADD  CONSTRAINT [FK_LevelComponents_Types] FOREIGN KEY([ComponentTypeID])
REFERENCES [dbo].[MedicalDictComponentTypes] ([ComponentTypeID])
GO
ALTER TABLE [dbo].[MedicalDictLevelComponents] CHECK CONSTRAINT [FK_LevelComponents_Types]
GO
/****** Object:  ForeignKey [FK_TermComponents_Term]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictTermComponents]  WITH CHECK ADD  CONSTRAINT [FK_TermComponents_Term] FOREIGN KEY([TermID])
REFERENCES [dbo].[MedicalDictionaryTerm] ([TermId])
GO
ALTER TABLE [dbo].[MedicalDictTermComponents] CHECK CONSTRAINT [FK_TermComponents_Term]
GO
/****** Object:  ForeignKey [FK_MedicalDictVerSegmentWorkflow_Workflow]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MedicalDictVerSegmentWorkflows]  WITH CHECK ADD  CONSTRAINT [FK_MedicalDictVerSegmentWorkflow_Workflow] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[MedicalDictVerSegmentWorkflows] CHECK CONSTRAINT [FK_MedicalDictVerSegmentWorkflow_Workflow]
GO
/****** Object:  ForeignKey [FK_MessageRecipients_Messages]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MessageRecipients]  WITH CHECK ADD  CONSTRAINT [FK_MessageRecipients_Messages] FOREIGN KEY([MessageID])
REFERENCES [dbo].[Messages] ([MessageID])
GO
ALTER TABLE [dbo].[MessageRecipients] CHECK CONSTRAINT [FK_MessageRecipients_Messages]
GO
/****** Object:  ForeignKey [FK_MessageRecipients_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MessageRecipients]  WITH CHECK ADD  CONSTRAINT [FK_MessageRecipients_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[MessageRecipients] CHECK CONSTRAINT [FK_MessageRecipients_Segments]
GO
/****** Object:  ForeignKey [FK_MessageRecipients_Users]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[MessageRecipients]  WITH CHECK ADD  CONSTRAINT [FK_MessageRecipients_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[MessageRecipients] CHECK CONSTRAINT [FK_MessageRecipients_Users]
GO
/****** Object:  ForeignKey [FK_Messages_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[Messages] CHECK CONSTRAINT [FK_Messages_Segments]
GO
/****** Object:  ForeignKey [FK_ModuleActions_ActionGroup]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ModuleActions]  WITH CHECK ADD  CONSTRAINT [FK_ModuleActions_ActionGroup] FOREIGN KEY([ActionGroupId])
REFERENCES [dbo].[ActionGroup] ([ActionGroupId])
GO
ALTER TABLE [dbo].[ModuleActions] CHECK CONSTRAINT [FK_ModuleActions_ActionGroup]
GO
/****** Object:  ForeignKey [FK_ModuleActions_ActionTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ModuleActions]  WITH NOCHECK ADD  CONSTRAINT [FK_ModuleActions_ActionTypeR] FOREIGN KEY([ActionType])
REFERENCES [dbo].[ActionTypeR] ([ActionType])
GO
ALTER TABLE [dbo].[ModuleActions] CHECK CONSTRAINT [FK_ModuleActions_ActionTypeR]
GO
/****** Object:  ForeignKey [FK_ModuleActions_ModulesR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ModuleActions]  WITH NOCHECK ADD  CONSTRAINT [FK_ModuleActions_ModulesR] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[ModulesR] ([ModuleId])
GO
ALTER TABLE [dbo].[ModuleActions] CHECK CONSTRAINT [FK_ModuleActions_ModulesR]
GO
/****** Object:  ForeignKey [FK_ModulePages_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ModulePages]  WITH CHECK ADD  CONSTRAINT [FK_ModulePages_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[ModulePages] CHECK CONSTRAINT [FK_ModulePages_Segments]
GO
/****** Object:  ForeignKey [FK_ModulesR_ObjectTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ModulesR]  WITH NOCHECK ADD  CONSTRAINT [FK_ModulesR_ObjectTypeR] FOREIGN KEY([ObjectTypeID])
REFERENCES [dbo].[ObjectTypeR] ([ObjectTypeID])
GO
ALTER TABLE [dbo].[ModulesR] CHECK CONSTRAINT [FK_ModulesR_ObjectTypeR]
GO
/****** Object:  ForeignKey [FK_ObjectSegments_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegments]  WITH CHECK ADD  CONSTRAINT [FK_ObjectSegments_Segments] FOREIGN KEY([SegmentId])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[ObjectSegments] CHECK CONSTRAINT [FK_ObjectSegments_Segments]
GO
/****** Object:  ForeignKey [FK_ObjectSegmentWorkflow_Workflow]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ObjectSegmentWorkflows]  WITH CHECK ADD  CONSTRAINT [FK_ObjectSegmentWorkflow_Workflow] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[ObjectSegmentWorkflows] CHECK CONSTRAINT [FK_ObjectSegmentWorkflow_Workflow]
GO
/****** Object:  ForeignKey [FK_OutTransmissionLogs_OutTransmissionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissionLogs]  WITH CHECK ADD  CONSTRAINT [FK_OutTransmissionLogs_OutTransmissionID] FOREIGN KEY([OutTransmissionID])
REFERENCES [dbo].[OutTransmissions] ([OutTransmissionID])
GO
ALTER TABLE [dbo].[OutTransmissionLogs] CHECK CONSTRAINT [FK_OutTransmissionLogs_OutTransmissionID]
GO
/****** Object:  ForeignKey [FK_OutTransmissions_SourceSystemID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[OutTransmissions]  WITH CHECK ADD  CONSTRAINT [FK_OutTransmissions_SourceSystemID] FOREIGN KEY([SourceSystemID])
REFERENCES [dbo].[SourceSystems] ([SourceSystemId])
GO
ALTER TABLE [dbo].[OutTransmissions] CHECK CONSTRAINT [FK_OutTransmissions_SourceSystemID]
GO
/****** Object:  ForeignKey [FK_RoleActions_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RoleActions]  WITH CHECK ADD  CONSTRAINT [FK_RoleActions_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[RoleActions] CHECK CONSTRAINT [FK_RoleActions_Segments]
GO
/****** Object:  ForeignKey [FK_RolesAllModules_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[RolesAllModules]  WITH CHECK ADD  CONSTRAINT [FK_RolesAllModules_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[RolesAllModules] CHECK CONSTRAINT [FK_RolesAllModules_Segments]
GO
/****** Object:  ForeignKey [FK_SecurityGroup_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_SecurityGroup_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[SecurityGroup] CHECK CONSTRAINT [FK_SecurityGroup_Segments]
GO
/****** Object:  ForeignKey [FK_SecurityGroupUser_SecurityGroup]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SecurityGroupUser]  WITH CHECK ADD  CONSTRAINT [FK_SecurityGroupUser_SecurityGroup] FOREIGN KEY([SecurityGroupID])
REFERENCES [dbo].[SecurityGroup] ([SecurityGroupID])
GO
ALTER TABLE [dbo].[SecurityGroupUser] CHECK CONSTRAINT [FK_SecurityGroupUser_SecurityGroup]
GO
/****** Object:  ForeignKey [FK_SecurityGroupUser_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SecurityGroupUser]  WITH CHECK ADD  CONSTRAINT [FK_SecurityGroupUser_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[SecurityGroupUser] CHECK CONSTRAINT [FK_SecurityGroupUser_Segments]
GO
/****** Object:  ForeignKey [FK_ServiceCommandLogs_ServiceCommandID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[ServiceCommandLogs]  WITH CHECK ADD  CONSTRAINT [FK_ServiceCommandLogs_ServiceCommandID] FOREIGN KEY([ServiceCommandID])
REFERENCES [dbo].[ServiceCommands] ([ServiceCommandID])
GO
ALTER TABLE [dbo].[ServiceCommandLogs] CHECK CONSTRAINT [FK_ServiceCommandLogs_ServiceCommandID]
GO
/****** Object:  ForeignKey [fk_SpugPathsTarget]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SpugPaths]  WITH CHECK ADD  CONSTRAINT [fk_SpugPathsTarget] FOREIGN KEY([TargetObjectTypeId])
REFERENCES [dbo].[ObjectTypeR] ([ObjectTypeID])
GO
ALTER TABLE [dbo].[SpugPaths] CHECK CONSTRAINT [fk_SpugPathsTarget]
GO
/****** Object:  ForeignKey [FK_StudyDictionaryVersion_Study]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersion]  WITH CHECK ADD  CONSTRAINT [FK_StudyDictionaryVersion_Study] FOREIGN KEY([StudyID])
REFERENCES [dbo].[TrackableObjects] ([TrackableObjectID])
GO
ALTER TABLE [dbo].[StudyDictionaryVersion] CHECK CONSTRAINT [FK_StudyDictionaryVersion_Study]
GO
/****** Object:  ForeignKey [FK_StudyDictionaryVersionHistory_Study]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[StudyDictionaryVersionHistory]  WITH CHECK ADD  CONSTRAINT [FK_StudyDictionaryVersionHistory_Study] FOREIGN KEY([StudyID])
REFERENCES [dbo].[TrackableObjects] ([TrackableObjectID])
GO
ALTER TABLE [dbo].[StudyDictionaryVersionHistory] CHECK CONSTRAINT [FK_StudyDictionaryVersionHistory_Study]
GO
/****** Object:  ForeignKey [FK_SynonymHistory_SynonymActionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymHistory]  WITH CHECK ADD  CONSTRAINT [FK_SynonymHistory_SynonymActionID] FOREIGN KEY([SynonymActionID])
REFERENCES [dbo].[SynonymActionR] ([SynonymActionID])
GO
ALTER TABLE [dbo].[SynonymHistory] CHECK CONSTRAINT [FK_SynonymHistory_SynonymActionID]
GO
/****** Object:  ForeignKey [FK_SynonymMigrationEntries_SynonymMigrationMngmt]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationEntries]  WITH CHECK ADD  CONSTRAINT [FK_SynonymMigrationEntries_SynonymMigrationMngmt] FOREIGN KEY([SynonymMigrationMngmtID])
REFERENCES [dbo].[SynonymMigrationMngmt] ([SynonymMigrationMngmtID])
GO
ALTER TABLE [dbo].[SynonymMigrationEntries] CHECK CONSTRAINT [FK_SynonymMigrationEntries_SynonymMigrationMngmt]
GO
/****** Object:  ForeignKey [FK_SynonymMigrationSuggestions_SynonymMigrationEntries]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SynonymMigrationSuggestions]  WITH CHECK ADD  CONSTRAINT [FK_SynonymMigrationSuggestions_SynonymMigrationEntries] FOREIGN KEY([SynonymMigrationEntryID])
REFERENCES [dbo].[SynonymMigrationEntries] ([SynonymMigrationEntryID])
GO
ALTER TABLE [dbo].[SynonymMigrationSuggestions] CHECK CONSTRAINT [FK_SynonymMigrationSuggestions_SynonymMigrationEntries]
GO
/****** Object:  ForeignKey [FK_SystemVariables_SourceSystemId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SystemVariables]  WITH CHECK ADD  CONSTRAINT [FK_SystemVariables_SourceSystemId] FOREIGN KEY([SourceSystemId])
REFERENCES [dbo].[SourceSystems] ([SourceSystemId])
GO
ALTER TABLE [dbo].[SystemVariables] CHECK CONSTRAINT [FK_SystemVariables_SourceSystemId]
GO
/****** Object:  ForeignKey [FK_SystemVariables_WorkflowVariableId]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[SystemVariables]  WITH CHECK ADD  CONSTRAINT [FK_SystemVariables_WorkflowVariableId] FOREIGN KEY([WorkflowVariableId])
REFERENCES [dbo].[WorkflowVariables] ([WorkflowVariableID])
GO
ALTER TABLE [dbo].[SystemVariables] CHECK CONSTRAINT [FK_SystemVariables_WorkflowVariableId]
GO
/****** Object:  ForeignKey [FK_Timezones_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Timezones]  WITH CHECK ADD  CONSTRAINT [FK_Timezones_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[Timezones] CHECK CONSTRAINT [FK_Timezones_Segments]
GO
/****** Object:  ForeignKey [FK_TrackableObjects_ExternalObjectTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TrackableObjects]  WITH CHECK ADD  CONSTRAINT [FK_TrackableObjects_ExternalObjectTypeR] FOREIGN KEY([ExternalObjectTypeId])
REFERENCES [dbo].[ExternalObjectTypeR] ([ExternalObjectTypeID])
GO
ALTER TABLE [dbo].[TrackableObjects] CHECK CONSTRAINT [FK_TrackableObjects_ExternalObjectTypeR]
GO
/****** Object:  ForeignKey [FK_TransmissionQueueItems_ObjectTypeR]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems]  WITH CHECK ADD  CONSTRAINT [FK_TransmissionQueueItems_ObjectTypeR] FOREIGN KEY([ObjectTypeID])
REFERENCES [dbo].[ObjectTypeR] ([ObjectTypeID])
GO
ALTER TABLE [dbo].[TransmissionQueueItems] CHECK CONSTRAINT [FK_TransmissionQueueItems_ObjectTypeR]
GO
/****** Object:  ForeignKey [FK_TransmissionQueueItems_SourceSystems]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[TransmissionQueueItems]  WITH CHECK ADD  CONSTRAINT [FK_TransmissionQueueItems_SourceSystems] FOREIGN KEY([SourceSystemID])
REFERENCES [dbo].[SourceSystems] ([SourceSystemId])
GO
ALTER TABLE [dbo].[TransmissionQueueItems] CHECK CONSTRAINT [FK_TransmissionQueueItems_SourceSystems]
GO
/****** Object:  ForeignKey [FK_UserModules_UserGroups]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserModules]  WITH NOCHECK ADD  CONSTRAINT [FK_UserModules_UserGroups] FOREIGN KEY([UserGroupID])
REFERENCES [dbo].[UserGroups] ([UserGroupID])
GO
ALTER TABLE [dbo].[UserModules] CHECK CONSTRAINT [FK_UserModules_UserGroups]
GO
/****** Object:  ForeignKey [FK_UserObjectRole_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectRole]  WITH CHECK ADD  CONSTRAINT [FK_UserObjectRole_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[UserObjectRole] CHECK CONSTRAINT [FK_UserObjectRole_Segments]
GO
/****** Object:  ForeignKey [FK_UserObjectWorkflowRole_WorkflowRole]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserObjectWorkflowRole]  WITH CHECK ADD  CONSTRAINT [FK_UserObjectWorkflowRole_WorkflowRole] FOREIGN KEY([WorkflowRoleId])
REFERENCES [dbo].[WorkflowRoles] ([WorkflowRoleId])
GO
ALTER TABLE [dbo].[UserObjectWorkflowRole] CHECK CONSTRAINT [FK_UserObjectWorkflowRole_WorkflowRole]
GO
/****** Object:  ForeignKey [FK_Users_Authenticators]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Authenticators] FOREIGN KEY([AuthenticatorID])
REFERENCES [dbo].[Authenticators] ([AuthenticatorID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Authenticators]
GO
/****** Object:  ForeignKey [FK_UserSettings_Users]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[UserSettings]  WITH CHECK ADD  CONSTRAINT [FK_UserSettings_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[UserSettings] CHECK CONSTRAINT [FK_UserSettings_Users]
GO
/****** Object:  ForeignKey [FK_VariableAssignment_Types]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[VariableDictAssignment]  WITH CHECK ADD  CONSTRAINT [FK_VariableAssignment_Types] FOREIGN KEY([ComponentTypeID])
REFERENCES [dbo].[MedicalDictComponentTypes] ([ComponentTypeID])
GO
ALTER TABLE [dbo].[VariableDictAssignment] CHECK CONSTRAINT [FK_VariableAssignment_Types]
GO
/****** Object:  ForeignKey [FK_VarDictUse_DictAlgorithm]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[VariableDictUseAlgorithm]  WITH CHECK ADD  CONSTRAINT [FK_VarDictUse_DictAlgorithm] FOREIGN KEY([CodingAlgorithmId])
REFERENCES [dbo].[MedicalDictionaryAlgorithm] ([MedicalDictionaryAlgorithmID])
GO
ALTER TABLE [dbo].[VariableDictUseAlgorithm] CHECK CONSTRAINT [FK_VarDictUse_DictAlgorithm]
GO
/****** Object:  ForeignKey [FK_WelcomeMessages_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessages]  WITH CHECK ADD  CONSTRAINT [FK_WelcomeMessages_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[WelcomeMessages] CHECK CONSTRAINT [FK_WelcomeMessages_Segments]
GO
/****** Object:  ForeignKey [FK_WelcomeMessageTags_Segments]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WelcomeMessageTags]  WITH CHECK ADD  CONSTRAINT [FK_WelcomeMessageTags_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO
ALTER TABLE [dbo].[WelcomeMessageTags] CHECK CONSTRAINT [FK_WelcomeMessageTags_Segments]
GO
/****** Object:  ForeignKey [FK_WorkflowActionItemData_WorkflowActionItemID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionItemData]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowActionItemData_WorkflowActionItemID] FOREIGN KEY([WorkflowActionItemID])
REFERENCES [dbo].[WorkflowActionItems] ([WorkflowActionItemID])
GO
ALTER TABLE [dbo].[WorkflowActionItemData] CHECK CONSTRAINT [FK_WorkflowActionItemData_WorkflowActionItemID]
GO
/****** Object:  ForeignKey [FK_WorkflowActionItems_WorkflowActionListID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionItems]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowActionItems_WorkflowActionListID] FOREIGN KEY([WorkflowActionListID])
REFERENCES [dbo].[WorkflowActionList] ([WorkflowActionListID])
GO
ALTER TABLE [dbo].[WorkflowActionItems] CHECK CONSTRAINT [FK_WorkflowActionItems_WorkflowActionListID]
GO
/****** Object:  ForeignKey [FK_WorkflowActionItems_WorkflowSystemActionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionItems]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowActionItems_WorkflowSystemActionID] FOREIGN KEY([WorkflowSystemActionID])
REFERENCES [dbo].[WorkflowSystemActionR] ([WorkflowSystemActionID])
GO
ALTER TABLE [dbo].[WorkflowActionItems] CHECK CONSTRAINT [FK_WorkflowActionItems_WorkflowSystemActionID]
GO
/****** Object:  ForeignKey [FK_WorkflowActionList_WorkflowActionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionList]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowActionList_WorkflowActionID] FOREIGN KEY([WorkflowActionID])
REFERENCES [dbo].[WorkflowActions] ([WorkflowActionID])
GO
ALTER TABLE [dbo].[WorkflowActionList] CHECK CONSTRAINT [FK_WorkflowActionList_WorkflowActionID]
GO
/****** Object:  ForeignKey [FK_WorkflowActionReasons_WorkflowActionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionReasons]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowActionReasons_WorkflowActionID] FOREIGN KEY([WorkflowActionId])
REFERENCES [dbo].[WorkflowActions] ([WorkflowActionID])
GO
ALTER TABLE [dbo].[WorkflowActionReasons] CHECK CONSTRAINT [FK_WorkflowActionReasons_WorkflowActionID]
GO
/****** Object:  ForeignKey [FK_WorkflowActionReasons_WorkflowReasonID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActionReasons]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowActionReasons_WorkflowReasonID] FOREIGN KEY([WorkflowReasonId])
REFERENCES [dbo].[WorkflowReasons] ([WorkflowReasonID])
GO
ALTER TABLE [dbo].[WorkflowActionReasons] CHECK CONSTRAINT [FK_WorkflowActionReasons_WorkflowReasonID]
GO
/****** Object:  ForeignKey [FK_WorkflowActions_WorkflowID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowActions]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowActions_WorkflowID] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[WorkflowActions] CHECK CONSTRAINT [FK_WorkflowActions_WorkflowID]
GO
/****** Object:  ForeignKey [FK_WorkflowReasons_WorkflowID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowReasons]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowReasons_WorkflowID] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[WorkflowReasons] CHECK CONSTRAINT [FK_WorkflowReasons_WorkflowID]
GO
/****** Object:  ForeignKey [FK_WorkflowRoleActions_WorkflowAction]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoleActions]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowRoleActions_WorkflowAction] FOREIGN KEY([WorkflowActionId])
REFERENCES [dbo].[WorkflowActions] ([WorkflowActionID])
GO
ALTER TABLE [dbo].[WorkflowRoleActions] CHECK CONSTRAINT [FK_WorkflowRoleActions_WorkflowAction]
GO
/****** Object:  ForeignKey [FK_WorkflowRoleActions_WorkflowRole]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoleActions]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowRoleActions_WorkflowRole] FOREIGN KEY([WorkflowRoleId])
REFERENCES [dbo].[WorkflowRoles] ([WorkflowRoleId])
GO
ALTER TABLE [dbo].[WorkflowRoleActions] CHECK CONSTRAINT [FK_WorkflowRoleActions_WorkflowRole]
GO
/****** Object:  ForeignKey [FK_WorkflowRoles_Workflow]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowRoles]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowRoles_Workflow] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[WorkflowRoles] CHECK CONSTRAINT [FK_WorkflowRoles_Workflow]
GO
/****** Object:  ForeignKey [FK_WorkflowStateActions_StateID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStateActions]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowStateActions_StateID] FOREIGN KEY([StateID])
REFERENCES [dbo].[WorkflowStates] ([WorkflowStateID])
GO
ALTER TABLE [dbo].[WorkflowStateActions] CHECK CONSTRAINT [FK_WorkflowStateActions_StateID]
GO
/****** Object:  ForeignKey [FK_WorkflowStateActions_Workflow]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStateActions]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowStateActions_Workflow] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[WorkflowStateActions] CHECK CONSTRAINT [FK_WorkflowStateActions_Workflow]
GO
/****** Object:  ForeignKey [FK_WorkflowStateActions_WorkflowActionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStateActions]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowStateActions_WorkflowActionID] FOREIGN KEY([WorkflowActionID])
REFERENCES [dbo].[WorkflowActions] ([WorkflowActionID])
GO
ALTER TABLE [dbo].[WorkflowStateActions] CHECK CONSTRAINT [FK_WorkflowStateActions_WorkflowActionID]
GO
/****** Object:  ForeignKey [FK_WorkflowStates_IconID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStates]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowStates_IconID] FOREIGN KEY([WorkflowStateIconID])
REFERENCES [dbo].[WorkflowStateIcons] ([WorkflowStateIconID])
GO
ALTER TABLE [dbo].[WorkflowStates] CHECK CONSTRAINT [FK_WorkflowStates_IconID]
GO
/****** Object:  ForeignKey [FK_WorkflowStates_WorkflowID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowStates]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowStates_WorkflowID] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[WorkflowStates] CHECK CONSTRAINT [FK_WorkflowStates_WorkflowID]
GO
/****** Object:  ForeignKey [FK_WorkflowSystemActionR_ApplicationID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowSystemActionR]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSystemActionR_ApplicationID] FOREIGN KEY([ApplicationID])
REFERENCES [dbo].[ApplicationR] ([ApplicationID])
GO
ALTER TABLE [dbo].[WorkflowSystemActionR] CHECK CONSTRAINT [FK_WorkflowSystemActionR_ApplicationID]
GO
/****** Object:  ForeignKey [FK_WorkflowTaskData_WorkflowTaskID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTaskData]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTaskData_WorkflowTaskID] FOREIGN KEY([WorkflowTaskID])
REFERENCES [dbo].[WorkflowTasks] ([WorkflowTaskID])
GO
ALTER TABLE [dbo].[WorkflowTaskData] CHECK CONSTRAINT [FK_WorkflowTaskData_WorkflowTaskID]
GO
/****** Object:  ForeignKey [FK_WorkflowTaskData_WorkflowVariables]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTaskData]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTaskData_WorkflowVariables] FOREIGN KEY([WorkflowVariableID])
REFERENCES [dbo].[WorkflowVariables] ([WorkflowVariableID])
GO
ALTER TABLE [dbo].[WorkflowTaskData] CHECK CONSTRAINT [FK_WorkflowTaskData_WorkflowVariables]
GO
/****** Object:  ForeignKey [FK_WorkflowTaskHistory_WorkflowActionID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTaskHistory]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTaskHistory_WorkflowActionID] FOREIGN KEY([WorkflowActionID])
REFERENCES [dbo].[WorkflowActions] ([WorkflowActionID])
GO
ALTER TABLE [dbo].[WorkflowTaskHistory] CHECK CONSTRAINT [FK_WorkflowTaskHistory_WorkflowActionID]
GO
/****** Object:  ForeignKey [FK_WorkflowTaskHistory_WorkflowStateID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTaskHistory]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTaskHistory_WorkflowStateID] FOREIGN KEY([WorkflowStateID])
REFERENCES [dbo].[WorkflowStates] ([WorkflowStateID])
GO
ALTER TABLE [dbo].[WorkflowTaskHistory] CHECK CONSTRAINT [FK_WorkflowTaskHistory_WorkflowStateID]
GO
/****** Object:  ForeignKey [FK_WorkflowTaskHistory_WorkflowTaskID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTaskHistory]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTaskHistory_WorkflowTaskID] FOREIGN KEY([WorkflowTaskID])
REFERENCES [dbo].[WorkflowTasks] ([WorkflowTaskID])
GO
ALTER TABLE [dbo].[WorkflowTaskHistory] CHECK CONSTRAINT [FK_WorkflowTaskHistory_WorkflowTaskID]
GO
/****** Object:  ForeignKey [FK_WorkflowTasks_WorkflowID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTasks]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTasks_WorkflowID] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[WorkflowTasks] CHECK CONSTRAINT [FK_WorkflowTasks_WorkflowID]
GO
/****** Object:  ForeignKey [FK_WorkflowTasks_WorkflowStateID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowTasks]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTasks_WorkflowStateID] FOREIGN KEY([WorkflowStateID])
REFERENCES [dbo].[WorkflowStates] ([WorkflowStateID])
GO
ALTER TABLE [dbo].[WorkflowTasks] CHECK CONSTRAINT [FK_WorkflowTasks_WorkflowStateID]
GO
/****** Object:  ForeignKey [FK_WorkflowVariableLookupValues_WorkflowVariableID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowVariableLookupValues]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowVariableLookupValues_WorkflowVariableID] FOREIGN KEY([WorkflowVariableID])
REFERENCES [dbo].[WorkflowVariables] ([WorkflowVariableID])
GO
ALTER TABLE [dbo].[WorkflowVariableLookupValues] CHECK CONSTRAINT [FK_WorkflowVariableLookupValues_WorkflowVariableID]
GO
/****** Object:  ForeignKey [FK_WorkflowVariables_WorkflowID]    Script Date: 01/04/2011 10:58:11 ******/
ALTER TABLE [dbo].[WorkflowVariables]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowVariables_WorkflowID] FOREIGN KEY([WorkflowID])
REFERENCES [dbo].[Workflows] ([WorkflowID])
GO
ALTER TABLE [dbo].[WorkflowVariables] CHECK CONSTRAINT [FK_WorkflowVariables_WorkflowID]
GO
/****** Object:  UserDefinedTableType [dbo].[ActionGroups_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[ActionGroups_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ActionGroupId] [int] NULL,
	[OID] [varchar](50) NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ActionGroupsOut_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[ActionGroupsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ActionTypes_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[ActionTypes_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ActionType] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ActionTypesOut_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[ActionTypesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Activations_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[Activations_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ActivationID] [int] NULL,
	[UserID] [int] NULL,
	[ActivationCode] [char](8) NULL,
	[Attempts] [int] NULL,
	[Activated] [datetime] NULL,
	[LastAttempt] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
	[ActivationStatus] [int] NULL,
	[Completed] [bit] NULL,
	[AlertSent] [bit] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ActivationsOut_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[ActivationsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AuditDetailTypes_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[AuditDetailTypes_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[AuditDetailTypeId] [int] NULL,
	[AuditTypeId] [int] NULL,
	[ObjectTypeId] [int] NULL,
	[PropertyName] [varchar](100) NULL,
	[AdditionalTrackingProperties] [varchar](4000) NULL,
	[TranslationStringName] [varchar](50) NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AuditDetailTypesOut_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[AuditDetailTypesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AuditProcesss_T]    Script Date: 01/04/2011 10:58:12 ******/
CREATE TYPE [dbo].[AuditProcesss_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[AuditProcessId] [int] NULL,
	[AuditProcess] [nvarchar](500) NULL,
	[IsDefault] [bit] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AuditProcesssOut_T]    Script Date: 01/04/2011 10:58:13 ******/
CREATE TYPE [dbo].[AuditProcesssOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Audits_T]    Script Date: 01/04/2011 10:58:13 ******/
CREATE TYPE [dbo].[Audits_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[AuditId] [bigint] NULL,
	[AuditSourceId] [bigint] NULL,
	[AuditDetailTypeId] [int] NULL,
	[AuditUserId] [int] NULL,
	[AuditTime] [datetime] NULL,
	[BeforeData] [nvarchar](2000) NULL,
	[NewData] [nvarchar](2000) NULL,
	[PropertyName] [varchar](50) NULL,
	[AuditedObjectTypeId] [bigint] NULL,
	[AuditedObjectId] [bigint] NULL,
	[ManualText] [nvarchar](2000) NULL,
	[AuditRefernaceObjectId] [bigint] NULL,
	[AuditRefernaceObjectTypeId] [int] NULL,
	[Detail1] [nvarchar](2000) NULL,
	[Detail2] [nvarchar](2000) NULL,
	[Detail3] [nvarchar](2000) NULL,
	[Detail4] [nvarchar](2000) NULL,
	[Detail5] [nvarchar](2000) NULL,
	[SegmentID] [int] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AuditSources_T]    Script Date: 01/04/2011 10:58:13 ******/
CREATE TYPE [dbo].[AuditSources_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[AuditSourceId] [bigint] NULL,
	[AuditSourceTime] [datetime] NULL,
	[AuditedObjectTypeId] [int] NULL,
	[AuditedObjectId] [bigint] NULL,
	[InteractionId] [int] NULL,
	[Host] [varchar](50) NULL,
	[ThreadName] [varchar](200) NULL,
	[AuditProcessId] [int] NULL,
	[Product] [varchar](200) NULL,
	[Process] [varchar](200) NULL,
	[AuditReasonNote] [nvarchar](200) NULL,
	[SegmentID] [int] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AuditSourcesOut_T]    Script Date: 01/04/2011 10:58:13 ******/
CREATE TYPE [dbo].[AuditSourcesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AuditsOut_T]    Script Date: 01/04/2011 10:58:13 ******/
CREATE TYPE [dbo].[AuditsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Configurations_T]    Script Date: 01/04/2011 10:58:14 ******/
CREATE TYPE [dbo].[Configurations_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ID] [int] NULL,
	[Tag] [varchar](64) NULL,
	[ConfigValue] [varchar](2000) NULL,
	[StudyID] [int] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ConfigurationsOut_T]    Script Date: 01/04/2011 10:58:14 ******/
CREATE TYPE [dbo].[ConfigurationsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ImpliedActionTypes_T]    Script Date: 01/04/2011 10:58:14 ******/
CREATE TYPE [dbo].[ImpliedActionTypes_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ActionType] [int] NULL,
	[ImpliedActionType] [int] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ImpliedActionTypesOut_T]    Script Date: 01/04/2011 10:58:14 ******/
CREATE TYPE [dbo].[ImpliedActionTypesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Interactions_T]    Script Date: 01/04/2011 10:58:14 ******/
CREATE TYPE [dbo].[Interactions_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[InteractionID] [int] NULL,
	[UserID] [int] NULL,
	[SessionID] [varchar](36) NULL,
	[LastAttemptedURL] [nvarchar](2000) NULL,
	[Start] [datetime] NULL,
	[LastAccess] [datetime] NULL,
	[Finish] [datetime] NULL,
	[NetWorkAddress] [varchar](255) NULL,
	[InteractionStatus] [int] NULL,
	[ClickCount] [int] NULL,
	[EncryptionKey] [varchar](50) NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[InteractionsOut_T]    Script Date: 01/04/2011 10:58:14 ******/
CREATE TYPE [dbo].[InteractionsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Locales_T]    Script Date: 01/04/2011 10:58:15 ******/
CREATE TYPE [dbo].[Locales_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[LocaleID] [int] NULL,
	[Locale] [char](3) NULL,
	[HelpFolder] [varchar](50) NULL,
	[NameFormat] [varchar](50) NULL,
	[NumberFormat] [varchar](50) NULL,
	[DateFormat] [varchar](50) NULL,
	[DateTimeFormat] [varchar](50) NULL,
	[SubmitOnEnter] [bit] NULL,
	[DescriptionID] [int] NULL,
	[Description] [nvarchar](2000) NULL,
	[Culture] [varchar](50) NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL,
	[CurrentLocale] [nvarchar](3) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[LocalesOut_T]    Script Date: 01/04/2011 10:58:15 ******/
CREATE TYPE [dbo].[LocalesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[DescriptionID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[LocalizationDataStringT]    Script Date: 01/04/2011 10:58:15 ******/
CREATE TYPE [dbo].[LocalizationDataStringT] AS TABLE(
	[StringId] [int] NULL,
	[String] [nvarchar](4000) NULL,
	[Locale] [nvarchar](3) NOT NULL,
	[ObjectTypeID] [int] NOT NULL,
	[ObjectID] [int] NOT NULL,
	[SegmentId] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[LocalizationRefT]    Script Date: 01/04/2011 10:58:15 ******/
CREATE TYPE [dbo].[LocalizationRefT] AS TABLE(
	[StringId] [int] NOT NULL,
	[PropertyName] [nvarchar](255) NOT NULL,
	[ObjectTypeID] [int] NOT NULL,
	[ObjectID] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[MessageRecipients_T]    Script Date: 01/04/2011 10:58:15 ******/
CREATE TYPE [dbo].[MessageRecipients_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[MessageRecipientID] [int] NULL,
	[MessageID] [int] NULL,
	[UserID] [int] NULL,
	[ReceiptTime] [datetime] NULL,
	[DeleteTime] [datetime] NULL,
	[SegmentID] [int] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[MessageRecipientsOut_T]    Script Date: 01/04/2011 10:58:15 ******/
CREATE TYPE [dbo].[MessageRecipientsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Messages_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[Messages_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[MessageID] [int] NULL,
	[MessageString] [nvarchar](1024) NULL,
	[MessageStringID] [int] NULL,
	[MessageStringKey] [varchar](50) NULL,
	[Send] [datetime] NULL,
	[Subject] [nvarchar](255) NULL,
	[SubjectStringKey] [varchar](50) NULL,
	[Urgency] [int] NULL,
	[WhoFrom] [nvarchar](50) NULL,
	[StringParameters] [nvarchar](255) NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[MessagesOut_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[MessagesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ModuleActions_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[ModuleActions_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ModuleActionID] [int] NULL,
	[ModuleID] [tinyint] NULL,
	[ActionType] [int] NULL,
	[ActionGroupId] [int] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ModuleActionsOut_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[ModuleActionsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ObjectSegments_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[ObjectSegments_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ObjectSegmentId] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectTypeId] [int] NULL,
	[SegmentId] [int] NULL,
	[ReadOnly] [bit] NULL,
	[DefaultSegment] [bit] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ObjectSegmentsOut_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[ObjectSegmentsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[RoleActions_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[RoleActions_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[RoleActionID] [int] NULL,
	[RoleID] [smallint] NULL,
	[ModuleActionId] [int] NULL,
	[RestrictionMask] [bigint] NULL,
	[RestrictionStatus] [bigint] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[RoleActionsOut_T]    Script Date: 01/04/2011 10:58:16 ******/
CREATE TYPE [dbo].[RoleActionsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Roles_T]    Script Date: 01/04/2011 10:58:17 ******/
CREATE TYPE [dbo].[Roles_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[RoleID] [int] NULL,
	[ModuleId] [int] NULL,
	[RoleNameID] [int] NULL,
	[RoleName] [nvarchar](2000) NULL,
	[OID] [varchar](50) NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL,
	[CurrentLocale] [nvarchar](3) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[RolesOut_T]    Script Date: 01/04/2011 10:58:17 ******/
CREATE TYPE [dbo].[RolesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[RoleNameID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SearchResultType]    Script Date: 01/04/2011 10:58:17 ******/
CREATE TYPE [dbo].[SearchResultType] AS TABLE(
	[TermId] [bigint] NOT NULL,
	[LevelOrdinal] [int] NOT NULL,
	[RecursionDepth] [tinyint] NOT NULL,
	[Rank] [decimal](10, 2) NULL,
	PRIMARY KEY CLUSTERED 
(
	[TermId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [dbo].[SecurityGroups_T]    Script Date: 01/04/2011 10:58:17 ******/
CREATE TYPE [dbo].[SecurityGroups_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[SecurityGroupID] [int] NULL,
	[SecurityGroupnameID] [int] NULL,
	[Name] [nvarchar](2000) NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL,
	[CurrentLocale] [nvarchar](3) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SecurityGroupsOut_T]    Script Date: 01/04/2011 10:58:17 ******/
CREATE TYPE [dbo].[SecurityGroupsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[SecurityGroupnameID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SecurityGroupUsers_T]    Script Date: 01/04/2011 10:58:17 ******/
CREATE TYPE [dbo].[SecurityGroupUsers_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[SecurityGroupUserID] [int] NULL,
	[UserID] [int] NULL,
	[SecurityGroupID] [int] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SecurityGroupUsersOut_T]    Script Date: 01/04/2011 10:58:17 ******/
CREATE TYPE [dbo].[SecurityGroupUsersOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SecurityModules_T]    Script Date: 01/04/2011 10:58:18 ******/
CREATE TYPE [dbo].[SecurityModules_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[ModuleId] [tinyint] NULL,
	[ModuleName] [varchar](100) NULL,
	[ObjectTypeID] [int] NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SecurityModulesOut_T]    Script Date: 01/04/2011 10:58:18 ******/
CREATE TYPE [dbo].[SecurityModulesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Segments_T]    Script Date: 01/04/2011 10:58:18 ******/
CREATE TYPE [dbo].[Segments_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[SegmentId] [int] NULL,
	[SegmentName] [nvarchar](255) NULL,
	[OID] [varchar](50) NULL,
	[IMedidataId] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SegmentsOut_T]    Script Date: 01/04/2011 10:58:18 ******/
CREATE TYPE [dbo].[SegmentsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SynonymResultType]    Script Date: 01/04/2011 10:58:18 ******/
CREATE TYPE [dbo].[SynonymResultType] AS TABLE(
	[TermId] [int] NOT NULL,
	[SynonymTermId] [int] NULL,
	[MatchPercent] [decimal](10, 2) NULL,
	PRIMARY KEY CLUSTERED 
(
	[TermId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [dbo].[TermArrayType]    Script Date: 01/04/2011 10:58:18 ******/
CREATE TYPE [dbo].[TermArrayType] AS TABLE(
	[TermId] [bigint] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[TermId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [dbo].[TermSearchResultType]    Script Date: 01/04/2011 10:58:18 ******/
CREATE TYPE [dbo].[TermSearchResultType] AS TABLE(
	[TermId] [int] NOT NULL,
	[LevelId] [int] NULL,
	[RecursionDepth] [tinyint] NULL,
	[Rank] [decimal](10, 2) NULL,
	[NodePath] [varchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UserObjectRoles_T]    Script Date: 01/04/2011 10:58:19 ******/
CREATE TYPE [dbo].[UserObjectRoles_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[UserObjectRoleId] [int] NULL,
	[GrantOnObjectId] [int] NULL,
	[GrantOnObjectTypeId] [int] NULL,
	[GrantToObjectId] [int] NULL,
	[GrantToObjectTypeId] [int] NULL,
	[RoleID] [smallint] NULL,
	[DenyObjectRole] [bit] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UserObjectRolesOut_T]    Script Date: 01/04/2011 10:58:19 ******/
CREATE TYPE [dbo].[UserObjectRolesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[Users_T]    Script Date: 01/04/2011 10:58:19 ******/
CREATE TYPE [dbo].[Users_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[UserID] [int] NULL,
	[FirstName] [nvarchar](255) NULL,
	[MiddleName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NULL,
	[Title] [nvarchar](255) NULL,
	[Login] [nvarchar](50) NULL,
	[PIN] [nvarchar](256) NULL,
	[Password] [nvarchar](256) NULL,
	[PasswordExpires] [datetime] NULL,
	[IsEnabled] [bit] NULL,
	[IsTrainingSigned] [bit] NULL,
	[Locale] [char](3) NULL,
	[GlobalRoleID] [int] NULL,
	[ExternalID] [int] NULL,
	[IsSponsorApprovalRequired] [bit] NULL,
	[AccountActivation] [bit] NULL,
	[IsLockedOut] [bit] NULL,
	[Credentials] [nvarchar](255) NULL,
	[Salutation] [nvarchar](32) NULL,
	[Active] [bit] NULL,
	[DEANumber] [nvarchar](255) NULL,
	[IsTrainingOnly] [bit] NULL,
	[EULADate] [datetime] NULL,
	[IsClinicalUser] [bit] NULL,
	[IsReadOnly] [bit] NULL,
	[AuthenticatorID] [int] NULL,
	[IMedidataId] [nvarchar](50) NULL,
	[CreatedBy] [int] NULL,
	[AuthenticationSourceID] [int] NULL,
	[Salt] [nvarchar](50) NULL,
	[DefaultSegmentID] [int] NULL,
	[Email] [nvarchar](255) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UserSettings_T]    Script Date: 01/04/2011 10:58:20 ******/
CREATE TYPE [dbo].[UserSettings_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[UserSettingID] [int] NULL,
	[UserID] [int] NULL,
	[Tag] [nvarchar](50) NULL,
	[Value] [nvarchar](200) NULL,
	[IsUserConfigurable] [bit] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UserSettingsOut_T]    Script Date: 01/04/2011 10:58:20 ******/
CREATE TYPE [dbo].[UserSettingsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UsersOut_T]    Script Date: 01/04/2011 10:58:20 ******/
CREATE TYPE [dbo].[UsersOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[WelcomeMessages_T]    Script Date: 01/04/2011 10:58:20 ******/
CREATE TYPE [dbo].[WelcomeMessages_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[WelcomeMessageID] [int] NULL,
	[WelcomeMessage] [int] NULL,
	[StaticText] [nvarchar](2000) NULL,
	[ShowAtTopLevel] [bit] NULL,
	[ShowAtStudyLevel] [bit] NULL,
	[ShowAtSiteLevel] [bit] NULL,
	[AllRoles] [bit] NULL,
	[AllStudies] [bit] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL,
	[CurrentLocale] [nvarchar](3) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[WelcomeMessagesOut_T]    Script Date: 01/04/2011 10:58:20 ******/
CREATE TYPE [dbo].[WelcomeMessagesOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[WelcomeMessage] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[WelcomeMessageTags_T]    Script Date: 01/04/2011 10:58:20 ******/
CREATE TYPE [dbo].[WelcomeMessageTags_T] AS TABLE(
	[CurrentObjectTypeId] [int] NULL,
	[WelcomeMessageTagID] [int] NULL,
	[MessageTag] [nvarchar](50) NULL,
	[SQLFunction] [varchar](100) NULL,
	[IsPriority] [bit] NULL,
	[SegmentID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Active] [bit] NULL,
	[Deleted] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[WelcomeMessageTagsOut_T]    Script Date: 01/04/2011 10:58:21 ******/
CREATE TYPE [dbo].[WelcomeMessageTagsOut_T] AS TABLE(
	[CurrentAction] [nvarchar](10) NULL,
	[CurrentObjectTypeId] [int] NULL,
	[OldId] [int] NULL,
	[Id] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)
GO


CREATE FULLTEXT INDEX ON MedicalDictionaryTerm(
Code LANGUAGE English, 
Term_ENG LANGUAGE English, 
Term_JPN LANGUAGE Japanese, 
Term_LOC LANGUAGE Neutral)
KEY INDEX PK_MedicalDictionaryTerm ON (MedicalDictionaryTermCat, FILEGROUP [PRIMARY])
WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO

---- TODO : to be removed
--CREATE FULLTEXT INDEX ON MedicalDictTermComponents(
--ComponentCode_ENG LANGUAGE English, 
--ComponentCode_JPN LANGUAGE Japanese, 
--ComponentCode_LOC LANGUAGE Neutral, 
--ComponentName_ENG LANGUAGE English, 
--ComponentName_JPN LANGUAGE Japanese, 
--ComponentName_LOC LANGUAGE Neutral)
--KEY INDEX PK_MedicalDictionaryComponentValues ON (MedicalDictTermComponentsCat, FILEGROUP [PRIMARY])
--WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
--GO


CREATE FULLTEXT INDEX ON ComponentEngStrings(
Code LANGUAGE English, 
Name LANGUAGE English )
KEY INDEX PK_ComponentEngStrings ON (MedicalDictTermComponentsCat, FILEGROUP [PRIMARY])
WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO

CREATE FULLTEXT INDEX ON ComponentJpnStrings(
Code LANGUAGE Japanese, 
Name LANGUAGE Japanese )
KEY INDEX PK_ComponentJpnStrings ON (MedicalDictTermComponentsCat, FILEGROUP [PRIMARY])
WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO

CREATE FULLTEXT INDEX ON ComponentLocStrings(
Code LANGUAGE Neutral, 
Name LANGUAGE Neutral )
KEY INDEX PK_ComponentLocStrings ON (MedicalDictTermComponentsCat, FILEGROUP [PRIMARY])
WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO