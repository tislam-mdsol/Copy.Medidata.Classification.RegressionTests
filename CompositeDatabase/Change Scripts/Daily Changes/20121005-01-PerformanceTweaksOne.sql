IF EXISTS (SELECT NULL FROM sys.key_constraints
	WHERE name = 'PK_RuntimeLocks')
	ALTER TABLE RuntimeLocks
	DROP CONSTRAINT PK_RuntimeLocks
	
-- Coding Element Schema change
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi2')
	DROP INDEX CodingElements.IX_CodingElements_Multi2
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi')
	DROP INDEX CodingElements.IX_CodingElements_Multi
GO
	
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_Multi_Small')
	DROP INDEX CodingElements.Ix_CodingElements_Multi_Small
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_TrackableObjectID')
	DROP INDEX CodingElements.Ix_CodingElements_TrackableObjectID
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_DictionaryVersionID')
	DROP INDEX CodingElements.Ix_CodingElements_DictionaryVersionID
GO

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElements' AND COLUMN_NAME = 'StudyDictionaryVersionId')
	ALTER TABLE CodingElements
	ADD StudyDictionaryVersionId INT NOT NULL CONSTRAINT DF_CodingElements_StudyDictionaryVersionId DEFAULT (0)
GO

DECLARE @dynSQL VARCHAR(4000)

-- check if (first) column already deleted, to make script rerunnable
---MCC-53264: rejected tasks need to be wired to a valid StudyDictionaryVersionId
---requires 20130228-01-UpdateRejectedTasksAfterStudyMigration.sql to run before the following transition
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElements' AND COLUMN_NAME = 'TrackableObjectId')
BEGIN
	SET @dynSQL = 
	'UPDATE CE
	SET CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
	FROM CodingElements CE
		JOIN StudyDictionaryVersion SDV
			ON CE.DictionaryVersionId = SDV.DictionaryVersionId
			AND CE.DictionaryLocale = SDV.DictionaryLocale
			AND CE.TrackableObjectId = SDV.StudyID'
	EXEC (@dynSQL)
END

CREATE NONCLUSTERED INDEX IX_CodingElements_Multi2
ON [dbo].[CodingElements] ([SegmentId], [StudyDictionaryVersionId], [IsClosed],[IsStillInService],[IsInvalidTask])
INCLUDE ([CodingElementId],[DictionaryLevelId],[VerbatimTerm],[WorkflowStateID],[AssignedSegmentedGroupCodingPatternId],[AssignedTermText],[AssignedTermCode],[AssignedCodingPath],[SourceSubject])
GO

CREATE NONCLUSTERED INDEX IX_CodingElements_Multi
ON [dbo].[CodingElements] ([SegmentId],[IsClosed],[IsStillInService],[Priority],[WorkflowStateID], [StudyDictionaryVersionId])
INCLUDE ([SourceSystemId],[AssignedTermText],[Created],[CodingElementGroupID],[AssignedSegmentedGroupCodingPatternId],[VerbatimTerm])
GO
	
CREATE NONCLUSTERED INDEX Ix_CodingElements_Multi_Small
ON [dbo].[CodingElements] ([StudyDictionaryVersionId], SegmentId, SourceSystemId)
INCLUDE (IsStillInService, IsClosed)
GO	

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElements' AND COLUMN_NAME = 'TrackableObjectId')
	ALTER TABLE CodingElements
	DROP COLUMN TrackableObjectId
GO
	
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElements' AND COLUMN_NAME = 'DictionaryVersionId')
	ALTER TABLE CodingElements
	DROP COLUMN DictionaryVersionId
GO
	
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElements' AND COLUMN_NAME = 'DictionaryLocale')
	ALTER TABLE CodingElements
	DROP COLUMN DictionaryLocale
GO