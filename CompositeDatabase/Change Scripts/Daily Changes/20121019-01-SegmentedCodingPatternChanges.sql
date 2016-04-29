IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'UIX_SegmentedGroupCodingPatterns_Multi')
	DROP INDEX [SegmentedGroupCodingPatterns].[UIX_SegmentedGroupCodingPatterns_Multi]

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'UIX_SegmentedGroupCodingPatterns_SinglePerGroup')
	DROP INDEX [SegmentedGroupCodingPatterns].[UIX_SegmentedGroupCodingPatterns_SinglePerGroup]

IF EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP COLUMN DictionaryVersionId
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns' AND COLUMN_NAME = 'SynonymStatus')
	ALTER TABLE SegmentedGroupCodingPatterns
	ADD SynonymStatus TINYINT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_SynonymStatus DEFAULT (0)
GO

DECLARE @dynSQL VARCHAR(4000)

SET @dynSQL = 
'UPDATE SegmentedGroupCodingPatterns
SET SynonymStatus = CASE WHEN IsProvisional = 1 THEN 1 WHEN IsValidForAutoCode = 1 THEN 2 END
WHERE IsProvisional = 1 OR IsValidForAutoCode = 1'
EXEC (@dynSQL)

IF EXISTS
	(SELECT NULL FROM sys.default_constraints
		WHERE name = 'DF_GroupCodingPatterns_IsValidForAutoCode')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP CONSTRAINT DF_GroupCodingPatterns_IsValidForAutoCode
GO

IF EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		 AND COLUMN_NAME = 'IsValidForAutoCode')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP COLUMN IsValidForAutoCode
GO

IF EXISTS
	(SELECT NULL FROM sys.default_constraints
		WHERE name = 'DF_SegmentedGroupCodingPatterns_IsProvisional')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP CONSTRAINT DF_SegmentedGroupCodingPatterns_IsProvisional
GO

IF EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		 AND COLUMN_NAME = 'IsProvisional')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP COLUMN IsProvisional
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'UIX_SegmentedGroupCodingPatterns_SinglePerGroup')
CREATE UNIQUE NONCLUSTERED INDEX [UIX_SegmentedGroupCodingPatterns_SinglePerGroup] ON [dbo].[SegmentedGroupCodingPatterns] 
(
	[CodingElementGroupID] ASC,
	[SynonymManagementID] ASC
)
WHERE SynonymStatus > 0
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'UIX_SegmentedGroupCodingPatterns_Multi')
CREATE UNIQUE NONCLUSTERED INDEX [UIX_SegmentedGroupCodingPatterns_Multi] ON [dbo].[SegmentedGroupCodingPatterns] 
(
	[CodingElementGroupID] ASC,
	[CodingPatternID] ASC,
	[SynonymManagementID] ASC
)
GO 


