-- Get rid of extra index
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CodingSuggestions]') AND name = N'Ix_CodingSuggestions_DictionaryTermID')
DROP INDEX [Ix_CodingSuggestions_DictionaryTermID] ON [dbo].[CodingSuggestions] WITH ( ONLINE = OFF )
GO
-- Get rid of index that is no longer used for search. search happens on dictionary db
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CodingSuggestions]') AND name = N'IX_CodingSuggestions_MedicalDictionaryTermID')
DROP INDEX [IX_CodingSuggestions_MedicalDictionaryTermID] ON [dbo].[CodingSuggestions] WITH ( ONLINE = OFF )
GO

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSuggestions' And COLUMN_NAME = 'MedicalDictionaryTermID' And DATA_TYPE = 'int')
	ALTER TABLE dbo.CodingSuggestions ALTER COLUMN MedicalDictionaryTermID NVARCHAR(255) NULL
Go