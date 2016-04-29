IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_NewCodingPatterns_Multi')
	DROP INDEX CodingPatterns.UIX_NewCodingPatterns_Multi
GO

CREATE UNIQUE NONCLUSTERED INDEX [UIX_NewCodingPatterns_Multi] 
ON [dbo].[CodingPatterns] 
(
	MedicalDictionaryVersionLocaleKey ASC,
	LevelId ASC,
	CodingPath ASC
)
GO