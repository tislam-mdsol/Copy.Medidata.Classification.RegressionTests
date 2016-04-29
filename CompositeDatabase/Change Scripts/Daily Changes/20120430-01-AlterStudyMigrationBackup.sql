IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationBackup'
		 AND COLUMN_NAME = 'NewWorkflowTaskHistory2ID')
	ALTER TABLE StudyMigrationBackup 
	ADD NewWorkflowTaskHistory2ID BIGINT NOT NULL CONSTRAINT DF_StudyMigrationBackup_NewWorkflowTaskHistory2ID DEFAULT (0)
GO
