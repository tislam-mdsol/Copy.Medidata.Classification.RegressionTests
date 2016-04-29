-- 1. SynonymStagingTable (drop)
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'SynonymStagingTable')
BEGIN
	DROP TABLE SynonymStagingTable
END
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
			AND COLUMN_NAME = 'IsProvisional')
	ALTER TABLE SegmentedGroupCodingPatterns
	ADD [IsProvisional] BIT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_IsProvisional DEFAULT (0)
GO

-- update provisional
UPDATE SGCP
SET SGCP.IsProvisional = 1
FROM SegmentedGroupCodingPatterns SGCP
	JOIN SynonymProvisionalStorage SPS
		ON SGCP.AssociatedSynonymTermID = SPS.TermID
		AND SGCP.SegmentID = SPS.SegmentID
		AND SGCP.IsValidForAutoCode = 0
		AND SGCP.Active = 1

-- 2. SynonymProvisionalStorage (change)
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'SynonymProvisionalStorage')
	DROP TABLE [SynonymProvisionalStorage]
GO

--3. SegmentedGroupCodingPatterns (alter)
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_SegmentedGroupCodingPatterns_AssocSyn')
	DROP INDEX SegmentedGroupCodingPatterns.UIX_SegmentedGroupCodingPatterns_AssocSyn
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_GroupCodingPatterns_AssociatedSynonymTermID')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP CONSTRAINT DF_GroupCodingPatterns_AssociatedSynonymTermID
GO	

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
			AND COLUMN_NAME = 'AssociatedSynonymTermID')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP COLUMN AssociatedSynonymTermID
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
			AND COLUMN_NAME = 'SynonymManagementID')
	ALTER TABLE SegmentedGroupCodingPatterns
	ADD [SynonymManagementID] INT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_SynonymManagementID DEFAULT (0)
GO


IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
			AND COLUMN_NAME = 'UserId')
	ALTER TABLE SegmentedGroupCodingPatterns
	ADD [UserId] BIT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_UserId DEFAULT (-2)
GO

-- 4. SynonymLoadingTable (DROP)
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'SynonymLoadingTable')
BEGIN
	DROP TABLE SynonymLoadingTable
END
GO

-- 5. ProjectDictionaryRegistrations (alter)
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
			AND COLUMN_NAME = 'SynonymManagementID')
	ALTER TABLE ProjectDictionaryRegistrations
	ADD [SynonymManagementID] INT NOT NULL CONSTRAINT DF_ProjectDictionaryRegistrations_SynonymManagementID DEFAULT (0)
GO

-- 6. SynonymMigrationMngmt (alter)
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SynonymMigrationMngmt'
			AND COLUMN_NAME = 'ListID')
	ALTER TABLE SynonymMigrationMngmt
	ADD [ListID] INT NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_ListID DEFAULT (0)
GO

-- 7. BOTElements
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'BOTElements')
BEGIN

	CREATE TABLE [dbo].BOTElements(
		BOTElementID INT IDENTITY(1,1) NOT NULL,
        SegmentId INT,
        UserId INT,
        SegmentedCodingPatternId BIGINT,
        IsForwardBOT BIT,
        CommentReason VARCHAR(500),
        BotLog VARCHAR(500),
        IsComplete BIT,
		Created DATETIME NOT NULL CONSTRAINT DF_BOTElements_Created DEFAULT (GETUTCDATE()),
		Updated DATETIME NOT NULL CONSTRAINT DF_BOTElements_Updated DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_BOTElements] PRIMARY KEY CLUSTERED 
	(
		BOTElementID ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]	
END
GO