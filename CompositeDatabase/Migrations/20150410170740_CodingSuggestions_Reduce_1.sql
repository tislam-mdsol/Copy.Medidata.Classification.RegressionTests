
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingSuggestions_DictionaryVersionId')
BEGIN
	DROP INDEX CodingSuggestions.Ix_CodingSuggestions_DictionaryVersionId

END

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSuggestions'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE CodingSuggestions
	DROP COLUMN DictionaryVersionId
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingSuggestions_AlgorithmId')
BEGIN
	DROP INDEX CodingSuggestions.Ix_CodingSuggestions_AlgorithmId

END

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSuggestions'
		 AND COLUMN_NAME = 'AlgorithmID')
	ALTER TABLE CodingSuggestions
	DROP COLUMN AlgorithmID
GO