IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElementGroups_Multi')
	DROP INDEX CodingElementGroups.IX_CodingElementGroups_Multi

CREATE NONCLUSTERED INDEX IX_CodingElementGroups_Multi
ON [dbo].[CodingElementGroups] ([VerbatimText])
INCLUDE ([CodingElementGroupID],[DictionaryLocale])
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi')
	DROP INDEX CodingElements.IX_CodingElements_Multi

CREATE NONCLUSTERED INDEX IX_CodingElements_Multi
ON [dbo].[CodingElements] ([SegmentId],[IsClosed],[IsStillInService],[Priority],[WorkflowStateID])
INCLUDE ([SourceSystemId],[TrackableObjectId],[DictionaryVersionId],[AssignedTermText],[Created],[CodingElementGroupID],[AssignedSegmentedGroupCodingPatternId],[VerbatimTerm])
GO