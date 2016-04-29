IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		 AND COLUMN_NAME = 'MigratingToIds')
	ALTER TABLE SynonymMigrationMngmt
	ADD MigratingToIds VARCHAR(MAX) NOT NULL CONSTRAINT DF_SynonymMigrationMngmt_MigratingToIds DEFAULT ('')
GO

IF EXISTS
	(SELECT NULL FROM sys.default_constraints
		WHERE name = 'DF_SynonymMigrationMngmtNumberOfSynonyms')
	ALTER TABLE SynonymMigrationMngmt
	DROP CONSTRAINT DF_SynonymMigrationMngmtNumberOfSynonyms
GO

IF EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationMngmt'
		 AND COLUMN_NAME = 'NumberOfSynonyms')
	ALTER TABLE SynonymMigrationMngmt
	DROP COLUMN NumberOfSynonyms
GO

