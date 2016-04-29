-- need to trace the old codingpatterns...
-- so extend sgcp with new column

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		AND COLUMN_NAME = 'CodingPatternID_Backup')
BEGIN
	ALTER TABLE SegmentedGroupCodingPatterns
	ADD CodingPatternID_Backup INT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_CodingPatternID_Backup DEFAULT (0) 
END