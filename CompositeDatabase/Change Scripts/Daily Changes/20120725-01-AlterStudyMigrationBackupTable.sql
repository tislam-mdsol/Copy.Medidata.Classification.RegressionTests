
-- Remove NewCodingSuggestionId column (no need to track in backup)
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationBackup'
		 AND COLUMN_NAME = 'NewCodingSuggestionId')
	ALTER TABLE StudyMigrationBackup DROP COLUMN NewCodingSuggestionId
GO
