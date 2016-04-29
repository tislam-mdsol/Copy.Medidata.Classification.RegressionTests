UPDATE SynonymMigrationMngmt
SET ActivationUserId = 0
WHERE ActivationUserId IS NULL

UPDATE SynonymMigrationMngmt
SET MigrationUserId = 0
WHERE MigrationUserId IS NULL