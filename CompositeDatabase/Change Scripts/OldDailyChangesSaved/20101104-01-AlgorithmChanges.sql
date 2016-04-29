-- CodingSuggestions table
IF (OBJECT_ID('FK_Suggestions_Algorithm') IS NOT NULL)
	ALTER TABLE CodingSuggestions
	DROP CONSTRAINT FK_Suggestions_Algorithm 
GO

-- CodingElements table
IF (OBJECT_ID('FK_CodingElements_Algorithm') IS NOT NULL)
	ALTER TABLE CodingElements
	DROP CONSTRAINT FK_CodingElements_Algorithm 
GO

-- CodingAssignment table
IF (OBJECT_ID('FK_Assignment_Algorithm') IS NOT NULL)
	ALTER TABLE CodingAssignment
	DROP CONSTRAINT FK_Assignment_Algorithm 
GO

-- CodingSourceTerms table
IF (OBJECT_ID('FK_CodingSourceTerms_CodingAlgorithm') IS NOT NULL)
	ALTER TABLE CodingSourceTerms
	DROP CONSTRAINT FK_CodingSourceTerms_CodingAlgorithm 
GO

-- MedicalDictionaryTermRanks table
IF (OBJECT_ID('FK_MedicalDictionaryTermRank_Term') IS NOT NULL)
	ALTER TABLE MedicalDictionaryTermRanks
	DROP CONSTRAINT FK_MedicalDictionaryTermRank_Term
GO
