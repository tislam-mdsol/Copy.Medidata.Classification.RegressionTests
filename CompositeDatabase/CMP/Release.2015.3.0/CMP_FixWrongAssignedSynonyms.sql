-- *** THE BUG ***
-- Root source, in release 2015.2.0, study migration releases study lock before updating 
-- the study dictionary version entity to the new synonym list

-- *** AS IT HAPPENED ***
-- Once released from lock, a task which was coded before study migration to a synonym, but reset
-- after study migration due to absence of synonym in the target upgrade is now picked up by the 
-- workflow.
-- The workflow checks for the tasks study dictionary version entity, and its synonym list
-- which is not yet updated since the study migration is not yet complete.
-- The task autocodes to the old synonym - resulting in dirty data

-- *** Excerpt from Task History (CodingElementId : 2450543)
-- Comment                              DateTime                CodingAssignmentId
--Version Change - From 14.2 To 15.1	2015-04-21 22:27:40.833	-1
--Workflow=DEFAULT	                    2015-04-21 22:28:39.780	NULL
--Auto coded by synonym	                2015-04-21 22:28:39.780	12601114

-- *** Excerpt from Study Migration Trace (StudyMigrationTraceId : 1282)
--Created                   Updated
--2015-04-21 09:13:27.653	2015-04-21 22:56:30.540

-- *** CONSEQUENCE ***
-- Coding information CANNOT be reconstructed for those tasks
-- They have to be reset

-- 1. find the affected tasks
DECLARE @affectedTasks TABLE(CodingElementId BIGINT PRIMARY KEY)

INSERT INTO @affectedTasks
SELECT ce.CodingElementId
FROM CodingElements ce
	JOIN StudyDictionaryVersion sdv
		ON ce.StudyDictionaryVersionId = sdv.StudyDictionaryVersionID
	JOIN SegmentedGroupCodingPatterns sgcp
		ON sgcp.SegmentedGroupCodingPatternID = ce.AssignedSegmentedGroupCodingPatternId
WHERE ce.IsInvalidTask = 0
	AND sgcp.SynonymManagementID <> sdv.SynonymManagementID

-- 2. Reset the rest back to start to restore integrity
-- NOTE : do not attempt to re-create these synonyms in the correct lists as the validity of the pattern
-- cannot be determined within SQL, nor can the pattern mapping itselft be validated

UPDATE CE
SET CE.WorkflowStateId                       = 1,
	CE.AssignedCodingPath                    = '',
	CE.AssignedSegmentedGroupCodingPatternId = -1,
	CE.AssignedTermCode                      = '',
	CE.AssignedTermText                      = '',
	CE.Updated                               = GETUTCDATE(),
	CE.CacheVersion                          = CE.CacheVersion+2
FROM @affectedTasks AT
	JOIN CodingElements CE
		ON CE.CodingElementID = AT.CodingElementID

-- deactivate codingassignments
UPDATE CA
SET CA.Active = 0,
	CA.Updated = GETUTCDATE()
FROM @affectedTasks AT
	JOIN CodingAssignment CA
		ON CA.CodingElementID = AT.CodingElementID

;WITH latestHistory AS
(
	SELECT *
	FROM @affectedTasks AT
		CROSS APPLY
		( 
			SELECT TOP 1 WTH.*
			FROM WorkflowTaskHistory WTH
			WHERE AT.CodingElementId = WTH.WorkflowTaskID 
			ORDER BY WTH.WorkflowTaskHistoryID DESC
		) AS WTH
)

INSERT INTO WorkflowTaskHistory 
    (WorkflowTaskId, WorkflowStateID, WorkflowActionId, WorkflowSystemActionID,
	UserId, WorkflowReasonID, COMMENT,
	Created, SegmentId, CodingAssignmentId, CodingElementGroupId, QueryId)
SELECT WorkflowTaskId, 1 AS WorkflowStateID, NULL AS WorkflowActionId, NULL AS WorkflowSystemActionID,
	-2 AS UserId, NULL AS WorkflowReasonID, 
    'Resetting the task to correct study up-versioning processing error' AS COMMENT,
   	GETUTCDATE() AS Created, SegmentId, NULL AS CodingAssignmentId, CodingElementGroupId, QueryId
FROM latestHistory
