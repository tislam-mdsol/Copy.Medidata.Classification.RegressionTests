-- Performance related denormalizations
-- 1) WorkflowStateId, 2) SegmentedGroupCodingPatternID, 3) Priority
-- index tweaking to follow
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'WorkflowStateID')
	ALTER TABLE CodingElements
	ADD WorkflowStateID SMALLINT NOT NULL CONSTRAINT DF_CodingElements_WorkflowStateID DEFAULT (-1)
GO  

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'AssignedSegmentedGroupCodingPatternId')
	ALTER TABLE CodingElements
	ADD AssignedSegmentedGroupCodingPatternId INT NOT NULL CONSTRAINT DF_CodingElements_CurrentSegmentedGroupCodingPatternId DEFAULT (-1)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'Priority')
	ALTER TABLE CodingElements
	ADD Priority TINYINT NOT NULL CONSTRAINT DF_CodingElements_Priority DEFAULT (0)
GO  

-- assignment data
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'AssignedTermText')
	ALTER TABLE CodingElements
	ADD AssignedTermText NVARCHAR(900) NOT NULL CONSTRAINT DF_CodingElements_AssignedTermText DEFAULT ('')
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'AssignedTermCode')
	ALTER TABLE CodingElements
	ADD AssignedTermCode NVARCHAR(100) NOT NULL CONSTRAINT DF_CodingElements_AssignedTermCode DEFAULT ('')
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'AssignedCodingPath')
	ALTER TABLE CodingElements
	ADD AssignedCodingPath VARCHAR(300) NOT NULL CONSTRAINT DF_CodingElements_AssignedCodingPath DEFAULT ('')
GO

-- rave associated data
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'SourceField')
	ALTER TABLE CodingElements
	ADD SourceField NVARCHAR(450)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'SourceForm')
	ALTER TABLE CodingElements
	ADD SourceForm NVARCHAR(450)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'SourceSubject')
	ALTER TABLE CodingElements
	ADD SourceSubject NVARCHAR(100)
GO


-- data migration from old model to new
UPDATE CE
SET CE.Priority = CST.Priority
from CodingElements CE
	JOIN CodingSourceTerms CST
		ON CE.CodingElementId = CST.CodingElementId

UPDATE CE
SET CE.AssignedSegmentedGroupCodingPatternId = CA.SegmentedGroupCodingPatternID
from CodingElements CE
	JOIN CodingAssignment CA
		ON CE.CodingElementId = CA.CodingElementId
		AND CA.Active = 1

UPDATE CE
SET CE.WorkflowStateID = WT.WorkflowStateID
from CodingElements CE
	JOIN WorkflowTasks WT
		ON CE.WorkflowTaskId = WT.WorkflowTaskId

UPDATE CE
SET CE.AssignedTermText = MDT.Term_ENG,
	CE.AssignedTermCode = MDT.Code,
	CE.AssignedCodingPath = CD.CodingPath
from CodingElements CE
	JOIN SegmentedGroupCodingPatterns SGCP
		ON CE.AssignedSegmentedGroupCodingPatternId = SGCP.SegmentedGroupCodingPatternID
	JOIN CodingPatterns CD
		ON CD.CodingPatternID = SGCP.CodingPatternID
	JOIN MedicalDictionaryTerm MDT
		ON MDT.TermId = CD.MedicalDictionaryTermID

UPDATE CE
SET CE.IsClosed = 1
from CodingElements CE
	JOIN WorkflowStates WS
		ON CE.WorkflowStateID = WS.WorkflowStateID
		AND WS.IsTerminalState = 1


update CodingSourceTermReferences
set ReferenceName = 'Form'
where ReferenceName = 'FormOID'

update CodingSourceTermReferences
set ReferenceName = 'Subject'
where ReferenceName = 'SubjectKey'

update CodingSourceTermReferences
set ReferenceName = 'Event'
where ReferenceName = 'StudyEventOID'

update CodingSourceTermReferences
set ReferenceName = 'Field'
where ReferenceName = 'ItemOID'

update CodingSourceTermReferences
set ReferenceName = 'Line'
where ReferenceName = 'ItemGroupOID'

UPDATE CE
SET CE.SourceSubject = CSTR_SubjectKey.ReferenceValue,
	CE.SourceForm = CSTR_FormOID.ReferenceValue,
	CE.SourceField = CSTR_ItemOID.ReferenceValue
FROM CodingElements CE
	JOIN CodingSourceTerms CST
		ON CE.CodingElementId = CST.CodingElementId
	JOIN CodingSourceTermReferences CSTR_SubjectKey
		ON CSTR_SubjectKey.CodingSourceTermID = CST.CodingSourceTermID
		AND CSTR_SubjectKey.ReferenceName = 'Subject'
	JOIN CodingSourceTermReferences CSTR_ItemOID
		ON CSTR_ItemOID.CodingSourceTermID = CST.CodingSourceTermID
		AND CSTR_ItemOID.ReferenceName = 'Field'
	JOIN CodingSourceTermReferences CSTR_FormOID
		ON CSTR_FormOID.CodingSourceTermID = CST.CodingSourceTermID
		AND CSTR_FormOID.ReferenceName = 'Form'			

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingAssignments_SegPattern')
	CREATE NONCLUSTERED INDEX [IX_CodingAssignments_SegPattern] ON [dbo].[CodingAssignment] 
	(
		[SegmentedGroupCodingPatternID] ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_GroupID')
	CREATE NONCLUSTERED INDEX [IX_CodingElements_GroupID] ON [dbo].[CodingElements] 
	(
		[CodingElementGroupId] ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_SegmentedGroupCodingPatterns_Pattern')
	CREATE NONCLUSTERED INDEX [IX_SegmentedGroupCodingPatterns_Pattern] ON [dbo].[SegmentedGroupCodingPatterns] 
	(
		[CodingPatternId] ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElements_Multi')
	CREATE NONCLUSTERED INDEX IX_CodingElements_Multi
	ON [dbo].[CodingElements] ([SegmentId],[IsClosed],[IsStillInService])
	INCLUDE ([SourceSystemId],[TrackableObjectId],[DictionaryVersionId],[VerbatimTerm],[Created],[CodingElementGroupID],[WorkflowStateID],[AssignedSegmentedGroupCodingPatternId],[Priority])
GO
