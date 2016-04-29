 IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_WorkflowTaskID')
	DROP INDEX CodingElements.Ix_CodingElements_WorkflowTaskID 
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi2')
	DROP INDEX CodingElements.IX_CodingElements_Multi2
GO

CREATE NONCLUSTERED INDEX IX_CodingElements_Multi2
ON [dbo].[CodingElements] ([SegmentId],[DictionaryVersionId],[DictionaryLocale],[IsClosed],[IsStillInService],[IsInvalidTask])
INCLUDE ([CodingElementId],[TrackableObjectId],[DictionaryLevelId],[VerbatimTerm],[WorkflowStateID],[AssignedSegmentedGroupCodingPatternId],[AssignedTermText],[AssignedTermCode],[AssignedCodingPath],[SourceSubject])
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'WorkflowTaskId')
	ALTER TABLE CodingElements
	DROP COLUMN WorkflowTaskID
GO


