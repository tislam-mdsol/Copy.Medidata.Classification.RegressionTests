IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'SynonymMigrationEntries' AND COLUMN_NAME = 'ActivatedStatus')
	ALTER TABLE SynonymMigrationEntries
	ADD ActivatedStatus BIT NOT NULL CONSTRAINT DF_SynonymMigrationEntries_ActivatedStatus DEFAULT (0)
GO