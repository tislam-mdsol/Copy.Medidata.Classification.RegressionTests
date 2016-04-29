IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SegmentedGroupCodingPatterns_ListAndPattern')
	DROP INDEX SegmentedGroupCodingPatterns.IX_SegmentedGroupCodingPatterns_ListAndPattern
GO

CREATE NONCLUSTERED INDEX [IX_SegmentedGroupCodingPatterns_ListAndPattern] ON SegmentedGroupCodingPatterns
(
	CodingPatternID ASC, 
	SynonymManagementID ASC
)
GO