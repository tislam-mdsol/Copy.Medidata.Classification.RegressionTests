IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'StudyMigrationBackup')
BEGIN

	CREATE TABLE [dbo].[StudyMigrationBackup](
		CodingElementID BIGINT NOT NULL, 
		StudyDictionaryVersionID INT NOT NULL,
		OldState INT NOT NULL,
		OldIsClosed BIT NOT NULL,
		OldCodingAssignment BIGINT,
		OldSegmentedGroupCodingPatternID BIGINT,
		OldCodingPath VARCHAR(300),
		OldTermCode VARCHAR(100),
		OldText NVARCHAR(900),
		FromVersionId INT NOT NULL,
		NewCodingAssignmentId BIGINT,
		NewWorkflowTaskHistoryId BIGINT,
		NewCodingSuggestionId BIGINT,
		NewTransmissionQueueItemId BIGINT
	 CONSTRAINT [PK_StudyMigrationBackup] PRIMARY KEY CLUSTERED 
	(
		[CodingElementID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END


-- add new column to change the order coding decision data is displayed in source
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'IsToRestoreBackup')
	ALTER TABLE StudyDictionaryVersion
	ADD IsToRestoreBackup BIT NOT NULL CONSTRAINT DF_StudyDictionaryVersion_IsToRestoreBackup DEFAULT (0)
GO
 
-- add new column to change the order coding decision data is displayed in source
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersion'
		 AND COLUMN_NAME = 'BackupState')
	ALTER TABLE StudyDictionaryVersion
	ADD BackupState INT NOT NULL CONSTRAINT DF_StudyDictionaryVersion_BackupState DEFAULT (1)
GO
 
-- CREATE INDEX on StudyMigrationBackup
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_StudyMigrationBackup_NewTransmissionQueueItemId')
	DROP INDEX StudyMigrationBackup.IX_StudyMigrationBackup_NewTransmissionQueueItemId
	
CREATE NONCLUSTERED INDEX IX_StudyMigrationBackup_NewTransmissionQueueItemId
ON [dbo].StudyMigrationBackup
( NewTransmissionQueueItemId, StudyDictionaryVersionID )
