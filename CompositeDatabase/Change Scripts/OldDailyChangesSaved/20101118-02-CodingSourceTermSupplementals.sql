IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CodingSourceTermSupplementals'))
BEGIN
	CREATE TABLE [dbo].[CodingSourceTermSupplementals](
		[SourceTermSupplementalID] BIGINT IDENTITY(1,1) NOT NULL,
		[CodingSourceTermID] BIGINT NOT NULL,

		[SearchOperator] INT NOT NULL,
		
		SupplementalValue NVARCHAR(1000) NOT NULL,
		SupplementTermKey NVARCHAR(100) NOT NULL,

		[Ordinal] INT NOT NULL,
		
		[Created] DATETIME NOT NULL CONSTRAINT [DF_CodingSourceTermSupplementals_Created]  DEFAULT (GETUTCDATE()),
		[Updated] DATETIME NOT NULL CONSTRAINT [DF_CodingSourceTermSupplementals_Updated]  DEFAULT (GETUTCDATE()),
		
		[SegmentId] INT NOT NULL,
	 CONSTRAINT [PK_CodingSourceTermSupplementals] PRIMARY KEY CLUSTERED 
	(
		[SourceTermSupplementalID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO 

IF (EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingSourceTermSupplementals_CodingSourceTermID'))
BEGIN
	CREATE NONCLUSTERED INDEX IX_CodingSourceTermSupplementals_CodingSourceTermID 
	ON CodingSourceTermSupplementals
	(
		CodingSourceTermID ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO

-- TODO : fix insert/update SPROCs with rest of params

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CodingElementGroupSupplementals'))
BEGIN
		CREATE TABLE [dbo].CodingElementGroupSupplementals(
		ID BIGINT IDENTITY(1,1) NOT NULL,
		CodingElementGroupID BIGINT NOT NULL,

		[SearchOperator] INT NOT NULL,
		
		SupplementalValue NVARCHAR(1000) NOT NULL,
		SupplementTermKey NVARCHAR(100) NOT NULL,

		[Created] DATETIME NOT NULL CONSTRAINT [DF_CodingElementGroupSupplementals_Created]  DEFAULT (GETUTCDATE()),
		[Updated] DATETIME NOT NULL CONSTRAINT [DF_CodingElementGroupSupplementals_Updated]  DEFAULT (GETUTCDATE())

	 CONSTRAINT [PK_CodingElementGroupSupplementals] PRIMARY KEY CLUSTERED 
	(
		ID ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

IF (EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElementGroupSupplementals_CodingSourceTermID'))
BEGIN
	CREATE NONCLUSTERED INDEX IX_CodingElementGroupSupplementals_CodingSourceTermID 
	ON CodingElementGroupSupplementals
	(
		CodingSourceTermID ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO
 

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroups' AND COLUMN_NAME = 'HasSupplements'))
BEGIN
	ALTER TABLE CodingElementGroups
	ADD HasSupplements BIT CONSTRAINT DF_CodingElementGroups_HasSupplements DEFAULT (0)
END
GO