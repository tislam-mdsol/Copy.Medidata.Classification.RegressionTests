IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'NewCodingPatterns'))
BEGIN
		CREATE TABLE [dbo].[NewCodingPatterns](
		CodingPatternId INT IDENTITY(1,1) NOT NULL,
		
		-- to be replaced by codingpath reference
		CodingPath VARCHAR(500) NOT NULL CONSTRAINT DF_NewCodingPatterns_CodingPath DEFAULT (''),
		
		-- to be replaced by actual version+locale reference
		VersionId INT NOT NULL CONSTRAINT DF_NewCodingPatterns_VersionId DEFAULT (0),
		Locale VARCHAR(3) NOT NULL CONSTRAINT DF_NewCodingPatterns_Locale DEFAULT (''),

		-- to be replaced by level reference
		LevelId INT NOT NULL CONSTRAINT DF_NewCodingPatterns_LevelId DEFAULT (0),
		-- to be recomputed upon migration
		PathCount INT NOT NULL CONSTRAINT DF_NewCodingPatterns_PathCount DEFAULT (0),

		Created DATETIME NOT NULL CONSTRAINT DF_NewCodingPatterns_Created DEFAULT (GETUTCDATE()),

		OldCodingPatternId INT, -- interim use - to be be dropped shortly

	CONSTRAINT [PK_NewCodingPatterns] PRIMARY KEY CLUSTERED 
	(
		CodingPatternId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE UNIQUE NONCLUSTERED INDEX [UIX_NewCodingPatterns_Multi] 
	ON [dbo].[NewCodingPatterns] 
	(
		VersionId ASC,
		Locale ASC,
		LevelId ASC,
		CodingPath ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

END

