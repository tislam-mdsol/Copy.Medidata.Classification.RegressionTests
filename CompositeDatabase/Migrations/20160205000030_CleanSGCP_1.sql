IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_SegmentedGroupCodingPatterns_CodingPatternID_Backup')
BEGIN
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP CONSTRAINT DF_SegmentedGroupCodingPatterns_CodingPatternID_Backup
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		AND COLUMN_NAME = 'CodingPatternID_Backup')
BEGIN
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP COLUMN CodingPatternID_Backup
END
