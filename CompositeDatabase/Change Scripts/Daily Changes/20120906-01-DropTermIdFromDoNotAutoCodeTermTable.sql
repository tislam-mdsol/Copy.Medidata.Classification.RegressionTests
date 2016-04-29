IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		 AND COLUMN_NAME = 'TermId')
	ALTER TABLE DoNotAutoCodeTerms DROP COLUMN TermId
GO 

IF EXISTS (select null from sysobjects where type = 'P' and name = 'spDoNotAutoCodeCanInsert')
	DROP PROCEDURE dbo.spDoNotAutoCodeCanInsert
GO