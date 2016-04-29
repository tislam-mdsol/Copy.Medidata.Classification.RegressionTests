IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedDictVerTermComponents_Mixed')
	DROP INDEX MedDictVerTermComponents.IX_MedDictVerTermComponents_Mixed	
	
ALTER TABLE [dbo].[MedDictVerTermComponents] ALTER COLUMN [ComponentTypeID] SMALLINT NULL

CREATE NONCLUSTERED INDEX IX_MedDictVerTermComponents_Mixed
ON [dbo].MedDictVerTermComponents ([MedicalDictionaryID], [DictionaryVersionOrdinal], ComponentTypeID, TermID)
GO