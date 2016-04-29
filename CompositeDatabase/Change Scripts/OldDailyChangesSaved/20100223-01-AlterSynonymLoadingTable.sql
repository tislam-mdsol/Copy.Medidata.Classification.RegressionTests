if not exists(select null from INFORMATION_SCHEMA.TABLES where TABLE_NAME='SynonymLoadStaging') begin

	CREATE TABLE [dbo].[SynonymLoadStaging](
		ID BIGINT IDENTITY(1,1) NOT NULL,
		SynonymManagementID INT NOT NULL,
		LineNumber INT NOT NULL,
		MasterTermID BIGINT NOT NULL CONSTRAINT DF_SynonymLoadStaging_MasterTermID DEFAULT((-1)),
		SynText NVARCHAR(1000) NOT NULL,
		SynLevelID INT NOT NULL,
		Code VARCHAR(50) NOT NULL,
		ActivatedStatus TINYINT NOT NULL CONSTRAINT DF_SynonymLoadStaging_ActivatedStatus DEFAULT((0)),
		
		[Created] [datetime] NOT NULL CONSTRAINT DF_SynonymLoadStaging_Created DEFAULT(GETUTCDATE()),
		[Updated] [datetime] NOT NULL CONSTRAINT DF_SynonymLoadStaging_Updated DEFAULT(GETUTCDATE()),
	 CONSTRAINT [PK_SynonymLoadStaging] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
end

IF NOT EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_SynonymLoadStaging_SynonymManagementID')
BEGIN
	CREATE NONCLUSTERED INDEX IX_SynonymLoadStaging_SynonymManagementID
	ON [dbo].[SynonymLoadStaging] ([SynonymManagementID])
	INCLUDE ([ID],[SynLevelID],[Code])
END