
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'GroupVerbatimKor')
BEGIN
	CREATE TABLE [dbo].[GroupVerbatimKor](
		[GroupVerbatimID] [int] IDENTITY(1,1) NOT NULL,
		[VerbatimText] [nvarchar](450) NULL,
		[Created] [datetime] NOT NULL CONSTRAINT [DF_GroupVerbatimKor_Created]  DEFAULT (getutcdate()),
	CONSTRAINT [PK_GroupVerbatimKor] PRIMARY KEY CLUSTERED 
	(
		[GroupVerbatimID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	)
END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'GroupVerbatimChn')
BEGIN
	CREATE TABLE [dbo].[GroupVerbatimChn](
		[GroupVerbatimID] [int] IDENTITY(1,1) NOT NULL,
		[VerbatimText] [nvarchar](450) NULL,
		[Created] [datetime] NOT NULL CONSTRAINT [DF_GroupVerbatimChn_Created]  DEFAULT (getutcdate()),
	CONSTRAINT [PK_GroupVerbatimChn] PRIMARY KEY CLUSTERED 
	(
		[GroupVerbatimID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	)
END


IF NOT EXISTS (SELECT NULL FROM sys.fulltext_index_columns
	WHERE object_name(object_id) = 'GroupVerbatimKor')
	CREATE FULLTEXT INDEX ON GroupVerbatimKor
	(
		VerbatimText LANGUAGE Korean
	)
	KEY INDEX PK_GroupVerbatimKor ON (VerbatimCat, FILEGROUP [PRIMARY])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO

IF NOT EXISTS (SELECT NULL FROM sys.fulltext_index_columns
	WHERE object_name(object_id) = 'GroupVerbatimChn')
	CREATE FULLTEXT INDEX ON GroupVerbatimChn
	(
		VerbatimText LANGUAGE 1028 --Traditional Chinese (vs 2052 for Simplified Chinese)
	)
	KEY INDEX PK_GroupVerbatimChn ON (VerbatimCat, FILEGROUP [PRIMARY])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO



