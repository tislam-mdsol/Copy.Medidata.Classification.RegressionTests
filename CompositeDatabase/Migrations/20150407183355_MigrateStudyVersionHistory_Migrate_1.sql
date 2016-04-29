UPDATE SDVH
SET SDVH.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
FROM StudyDictionaryVersionHistory SDVH
	CROSS APPLY(
		SELECT ISNULL(MAX(StudyDictionaryVersionId), 0) AS StudyDictionaryVersionId,
			COUNT(1) AS CC
		FROM StudyDictionaryVersion SDV
			JOIN SynonymMigrationMngmt SMM
				ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
				AND SMM.MedicalDictionaryID = SDVH.MedicalDictionaryID
		WHERE SDVH.StudyId = SDV.StudyId
			AND SDVH.SegmentId = SDV.SegmentId
			AND SMM.MedicalDictionaryID = SDVH.MedicalDictionaryID
	) AS SDV
WHERE SDV.CC = 1

-- remove the unresolvable histories
DELETE StudyDictionaryVersionHistory
WHERE StudyDictionaryVersionId = 0

-- add index here
CREATE NONCLUSTERED INDEX [IX_StudyDictionaryVersionHistoryStudyDictionaryVersionID] ON [dbo].[StudyDictionaryVersionHistory] 
(
	StudyDictionaryVersionID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_StudyDictionaryVersionHistory_StudyID')
	DROP INDEX StudyDictionaryVersionHistory.IX_StudyDictionaryVersionHistory_StudyID 
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_StudyDictionaryVersionHistory_StudyDictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP CONSTRAINT DF_StudyDictionaryVersionHistory_StudyDictionaryVersionId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP COLUMN DictionaryVersionId
GO

IF EXISTS (SELECT NULL FROM sys.foreign_keys 
WHERE object_id = OBJECT_ID(N'FK_StudyDictionaryVersionHistory_Study')) 
BEGIN 
	ALTER TABLE StudyDictionaryVersionHistory 
	DROP CONSTRAINT FK_StudyDictionaryVersionHistory_Study
END 

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'StudyId')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP COLUMN StudyId
GO

