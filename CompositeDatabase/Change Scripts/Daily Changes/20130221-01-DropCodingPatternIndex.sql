  IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SegmentedGroupCodingPatterns_Pattern')
	DROP INDEX SegmentedGroupCodingPatterns.IX_SegmentedGroupCodingPatterns_Pattern
	