IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_CodingSourceAlgorithmID')
	DROP INDEX CodingElements.Ix_CodingElements_CodingSourceAlgorithmID 
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_SegmentID')
	DROP INDEX CodingElements.Ix_CodingElements_SegmentID
GO


IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_DictionaryLevelId')
	DROP INDEX CodingElements.Ix_CodingElements_DictionaryLevelId 
GO