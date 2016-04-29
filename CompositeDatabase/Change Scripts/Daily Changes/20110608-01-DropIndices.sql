IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_CodingSourceAlgorithmID')
	DROP INDEX CodingElements.Ix_CodingElements_CodingSourceAlgorithmID 
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElement_Multi')
	DROP INDEX CodingElements.IX_CodingElement_Multi 
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_DictionaryLevelId')
	DROP INDEX CodingElements.Ix_CodingElements_DictionaryLevelId 
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_DictionaryVersionID')
	DROP INDEX CodingElements.Ix_CodingElements_DictionaryVersionID
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_SegmentID')
	DROP INDEX CodingElements.Ix_CodingElements_SegmentID
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_SourceSystemID')
	DROP INDEX CodingElements.Ix_CodingElements_SourceSystemID 
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_TrackableObjectID')
	DROP INDEX CodingElements.Ix_CodingElements_TrackableObjectID
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_CodingElements_Multi_Small')
	CREATE NONCLUSTERED INDEX Ix_CodingElements_Multi_Small ON [dbo].CodingElements 
	(
		TrackableObjectId, SegmentId, SourceSystemId
	)
	INCLUDE (IsStillInService, IsClosed)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_WorkflowTaskHistory_Multi')
	CREATE NONCLUSTERED INDEX Ix_WorkflowTaskHistory_Multi ON [dbo].WorkflowTaskHistory 
	(
		WorkflowTaskID, Created, WorkflowStateID, WorkflowActionID
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_TaskHistory_Segment')
	DROP INDEX WorkflowTaskHistory.Ix_TaskHistory_Segment

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_WorkflowTaskHistory_UserID')
	DROP INDEX WorkflowTaskHistory.Ix_WorkflowTaskHistory_UserID

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_WorkflowTaskHistory_WorkflowActionID')
	DROP INDEX WorkflowTaskHistory.Ix_WorkflowTaskHistory_WorkflowActionID

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_WorkflowTaskHistory_WorkflowStateID')
	DROP INDEX WorkflowTaskHistory.Ix_WorkflowTaskHistory_WorkflowStateID
	
IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Assignement')
	CREATE NONCLUSTERED INDEX IX_CodingElements_Assignement ON [dbo].[CodingElements]
	(	
		AssignedSegmentedGroupCodingPatternId
	) INCLUDE ([IsInvalidTask])

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi2')
	CREATE NONCLUSTERED INDEX IX_CodingElements_Multi2
	ON [dbo].[CodingElements] ([SegmentId],[DictionaryVersionId],[DictionaryLocale],[IsClosed],[IsStillInService],[IsInvalidTask])
	INCLUDE ([CodingElementId],[WorkflowTaskId],[TrackableObjectId],[DictionaryLevelId],[VerbatimTerm],[WorkflowStateID],[AssignedSegmentedGroupCodingPatternId],[AssignedTermText],[AssignedTermCode],[AssignedCodingPath],[SourceSubject])
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi')
	drop index codingelements.IX_CodingElements_Multi
GO

CREATE NONCLUSTERED INDEX IX_CodingElements_Multi
ON [dbo].[CodingElements] ([SegmentId],[IsClosed],[IsStillInService])
INCLUDE ([SourceSystemId],[TrackableObjectId],[DictionaryVersionId],[VerbatimTerm],[Created],[CodingElementGroupID],[WorkflowStateID],[AssignedSegmentedGroupCodingPatternId],[Priority])
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_UserObjectRole_Single')
	CREATE UNIQUE NONCLUSTERED INDEX [UIX_UserObjectRole_Single] ON [dbo].[UserObjectRole] 
	(
		GrantToObjectId ASC,
		GrantOnObjectId ASC,
		GrantToObjectTypeId ASC,
		GrantOnObjectTypeId ASC,
		RoleId ASC,
		SegmentID ASC
	)
	WHERE Active=1 AND Deleted=0
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO