IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WorkflowRunnerServiceHeartBeat'
		 AND COLUMN_NAME = 'IsCacheThreadAlive')
	ALTER TABLE WorkflowRunnerServiceHeartBeat
	ADD IsCacheThreadAlive BIT NOT NULL CONSTRAINT DF_WorkflowRunnerServiceHeartBeat_IsCacheThreadAlive DEFAULT (0)
GO 

drop index CodingElements.IX_CodingElements_Multi

CREATE NONCLUSTERED INDEX IX_CodingElements_Multi
ON [dbo].[CodingElements] ([SegmentId],[IsClosed],[IsStillInService])
INCLUDE ([SourceSystemId],[TrackableObjectId],[DictionaryVersionId],[VerbatimTerm],[Created],[CodingElementGroupID],[WorkflowStateID],[AssignedSegmentedGroupCodingPatternId],[Priority], IsInvalidTask)
GO
