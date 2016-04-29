IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'ParentPath')
	BEGIN
		ALTER TABLE SynonymLoadStaging ADD ParentPath VARCHAR(500) NOT NULL CONSTRAINT DF_SynonymLoadStaging_ParentPath DEFAULT ('')
	END
GO 

IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'UsePrimary')
	BEGIN
		ALTER TABLE SynonymLoadStaging ADD UsePrimary BIT NOT NULL CONSTRAINT DF_SynonymLoadStaging_UsePrimary DEFAULT (0)
	END
GO 

IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'IsPrimary')
	BEGIN
		ALTER TABLE SynonymLoadStaging ADD IsPrimary BIT NOT NULL CONSTRAINT DF_SynonymLoadStaging_IsPrimary DEFAULT (0)
	END
GO 

IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'CodingElementGroupID')
	BEGIN
		ALTER TABLE SynonymLoadStaging ADD CodingElementGroupID BIGINT NOT NULL CONSTRAINT DF_SynonymLoadStaging_CodingElementGroupID DEFAULT (0)
	END
GO 


IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictionary'
		 AND COLUMN_NAME = 'SupportsPrimaryPath')
	BEGIN
		ALTER TABLE MedicalDictionary ADD SupportsPrimaryPath BIT NOT NULL CONSTRAINT DF_MedicalDictionary_SupportsPrimaryPath DEFAULT (0)
	END
GO 

UPDATE MedicalDictionary
SET SupportsPrimaryPath = 1
WHERE OID LIKE 'MedDra%'


IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictionaryTerm'
		 AND COLUMN_NAME = 'ProgrammaticAuxiliary')
	BEGIN
		ALTER TABLE MedicalDictionaryTerm 
		ADD	ProgrammaticAuxiliary BIGINT NOT NULL CONSTRAINT DF_MedicalDictionaryTerm_ProgrammaticAuxiliary DEFAULT((0))
	END
GO 

IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationSuggestions'
		 AND COLUMN_NAME = 'IsPrimaryPath')
	BEGIN
		ALTER TABLE SynonymMigrationSuggestions 
		ADD	IsPrimaryPath BIT NOT NULL CONSTRAINT DF_SynonymMigrationSuggestions_IsPrimaryPath DEFAULT((0))
	END
GO 


IF (NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_ImpactAnalysisVersionDifference_Multi'))
BEGIN
	CREATE UNIQUE INDEX UIX_ImpactAnalysisVersionDifference_Multi ON ImpactAnalysisVersionDifference
	(
		MedicalDictionaryID, 
		FromVersionOrdinal, 
		ToVersionOrdinal, 
		Locale,
		OldTermID, 
		FinalTermID
	)

END