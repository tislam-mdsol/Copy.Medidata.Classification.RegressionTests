IF NOT EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictTermComponents_TermID')
	CREATE NONCLUSTERED INDEX IX_MedicalDictTermComponents_TermID
	ON [dbo].MedicalDictTermComponents ([TermID])
GO 

IF NOT EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTermRel_ToTermId')
	CREATE NONCLUSTERED INDEX IX_MedicalDictionaryTermRel_ToTermId
	ON [dbo].[MedicalDictionaryTermRel] ([ToTermId])
GO