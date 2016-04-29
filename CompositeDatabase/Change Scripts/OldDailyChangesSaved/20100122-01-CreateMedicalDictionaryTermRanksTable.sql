if not exists(select null from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MedicalDictionaryTermRanks') begin

	CREATE TABLE [dbo].[MedicalDictionaryTermRanks](
		[ID] [bigint] IDENTITY(1,1) NOT NULL,
		[TermId] [bigint] NOT NULL,
		[RankCode_FT] [int] NULL,
		[RankCode_CT] [int] NULL,
		[RankEng_FT] [int] NULL,
		[RankJpn_FT] [int] NULL,
		[RankLoc_FT] [int] NULL,
		[RankEng_CT] [int] NULL,
		[RankJpn_CT] [int] NULL,
		[RankLoc_CT] [int] NULL,
		[RankEng_FTNS] [int] NULL,
		[RankJpn_FTNS] [int] NULL,
		[RankLoc_FTNS] [int] NULL,
		[RankEng_FTST] [int] NULL,
		[RankJpn_FTST] [int] NULL,
		[RankLoc_FTST] [int] NULL,
		[RankEng_CTNS] [int] NULL,
		[RankJpn_CTNS] [int] NULL,
		[RankLoc_CTNS] [int] NULL,
		[RankEng_CTSA] [int] NULL,
		[RankJpn_CTSA] [int] NULL,
		[RankLoc_CTSA] [int] NULL,
		[RankEng_CTST] [int] NULL,
		[RankJpn_CTST] [int] NULL,
		[RankLoc_CTST] [int] NULL,
		[RankEng_CTSP] [int] NULL,
		[RankJpn_CTSP] [int] NULL,
		[RankLoc_CTSP] [int] NULL,
		[TermProperty] [nchar](10) NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_MedicalDictionaryTermRanks] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[MedicalDictionaryTermRanks]  WITH CHECK ADD  CONSTRAINT [FK_MedicalDictionaryTermRank_Term] FOREIGN KEY([TermId])
	REFERENCES [dbo].[MedicalDictionaryTerm] ([TermId])

	ALTER TABLE [dbo].[MedicalDictionaryTermRanks] CHECK CONSTRAINT [FK_MedicalDictionaryTermRank_Term]

	ALTER TABLE [dbo].[MedicalDictionaryTermRanks] ADD  CONSTRAINT [DF_MedicalDictionaryTermRank_Created]  DEFAULT (getutcdate()) FOR [Created]

	ALTER TABLE [dbo].[MedicalDictionaryTermRanks] ADD  CONSTRAINT [DF_MedicalDictionaryTermRank_Updated]  DEFAULT (getutcdate()) FOR [Updated]

end
