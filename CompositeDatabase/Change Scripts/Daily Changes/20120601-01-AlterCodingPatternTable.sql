
-- Add DictionaryLevel column
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 AND COLUMN_NAME = 'DictionaryLevelID')
	ALTER TABLE CodingPatterns ADD DictionaryLevelID SMALLINT DEFAULT (-1)
GO

-- Remove IsPrimaryPath column
IF EXISTS (SELECT NULL FROM sys.default_constraints WHERE NAME = 'DF_CodingPatterns_IsPrimaryPath')
	ALTER TABLE CodingPatterns DROP CONSTRAINT DF_CodingPatterns_IsPrimaryPath
GO
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 AND COLUMN_NAME = 'IsPrimaryPath')
	ALTER TABLE CodingPatterns DROP COLUMN IsPrimaryPath
GO

-- Remove index with MedicalDictionaryTermID
IF EXISTS (SELECT NULL FROM sys.indexes WHERE NAME = 'UIX_CodingPatterns_Multi')  
	DROP INDEX CodingPatterns.UIX_CodingPatterns_Multi 
GO

-- Populate DictionaryLevel from MedicalDictionaryTermID relationship, then
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 AND COLUMN_NAME = 'MedicalDictionaryTermID')
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION

		PRINT 'Updating DictionaryLevelID'
		UPDATE CodingPatterns 
		SET DictionaryLevelID = MDT.DictionaryLevelId
		FROM MedicalDictionaryTerm MDT
		WHERE CodingPatterns.MedicalDictionaryTermID = MDT.TermId
		
		-- add not null constraint on level
		ALTER TABLE CodingPatterns ALTER COLUMN DictionaryLevelID SMALLINT NOT NULL
	
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(MAX)
		SET @errorString = N'ERROR CodingPatterns: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH

END
GO

-- Create new CodingPatterns index
IF NOT EXISTS (SELECT NULL FROM sys.indexes WHERE NAME = 'IX_CodingPatterns_Multi')  
	CREATE NONCLUSTERED INDEX IX_CodingPatterns_Multi ON CodingPatterns 
	(
		DictionaryLevelID ASC,
		CodingPath ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
