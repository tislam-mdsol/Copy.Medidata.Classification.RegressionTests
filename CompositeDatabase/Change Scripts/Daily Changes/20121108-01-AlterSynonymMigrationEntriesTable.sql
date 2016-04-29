﻿ IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymMigrationEntries'
	AND COLUMN_NAME = 'IsPrimaryPath')
BEGIN
	ALTER TABLE SynonymMigrationEntries
	ADD IsPrimaryPath BIT NOT NULL DEFAULT(0)
END
GO