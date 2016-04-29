IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingAssignment_DictionaryVersionID')
	DROP INDEX CodingAssignment.Ix_CodingAssignment_DictionaryVersionID 
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE CodingAssignment
	DROP COLUMN DictionaryVersionId
GO