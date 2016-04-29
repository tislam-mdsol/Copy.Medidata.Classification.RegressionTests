
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationBackup'
	AND COLUMN_NAME = 'MigrationChangeType')
BEGIN
	ALTER TABLE StudyMigrationBackup
	ADD MigrationChangeType SMALLINT NOT NULL CONSTRAINT DF_StudyMigrationBackup_MigrationChangeType DEFAULT(-1)
END
GO

-- TODO: Review Filtered index (probably  not necessary)
--IF NOT EXISTS (SELECT NULL FROM sysindexes
--	WHERE name = 'IX_StudyMigrationBackup_CodingElement_MigrationType')
--BEGIN
--	CREATE UNIQUE NONCLUSTERED INDEX IX_StudyMigrationBackup_CodingElement_MigrationType ON StudyMigrationBackup 
--	(
--		[CodingElementID] ASC,
--		[MigrationChangeType] ASC
--	)
--	WHERE ([MigrationChangeType]=(-1))
--	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationTraces'
	AND COLUMN_NAME = 'CurrentStage')
BEGIN
	ALTER TABLE StudyMigrationTraces
	ADD CurrentStage INT NOT NULL CONSTRAINT DF_StudyMigrationTraces_CurrentStage DEFAULT(0)
END
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyMigrationTraces'
	AND COLUMN_NAME = 'CacheVersion')
BEGIN
	ALTER TABLE StudyMigrationTraces
	ADD CacheVersion BIGINT NOT NULL CONSTRAINT DF_StudyMigrationTraces_CacheVersion DEFAULT(0)
END
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersion_IsToRestoreBackup')
	ALTER TABLE StudyDictionaryVersion
	DROP CONSTRAINT DF_StudyDictionaryVersion_IsToRestoreBackup
GO
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'IsToRestoreBackup')
	ALTER TABLE StudyDictionaryVersion DROP COLUMN IsToRestoreBackup
GO 

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersion_BackupState')
	ALTER TABLE StudyDictionaryVersion
	DROP CONSTRAINT DF_StudyDictionaryVersion_BackupState
GO
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'BackupState')
	ALTER TABLE StudyDictionaryVersion DROP COLUMN BackupState	
GO 
