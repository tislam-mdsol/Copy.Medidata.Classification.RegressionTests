IF NOT EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictionaryTermRel_FromTermId')
	CREATE NONCLUSTERED INDEX IX_MedicalDictionaryTermRel_FromTermId
	ON [dbo].[MedicalDictionaryTermRel] ([FromTermId])
GO