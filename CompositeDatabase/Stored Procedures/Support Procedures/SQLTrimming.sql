-- Place HOLDER for Entities that need regular cleanup/archiving.  

-- delete unreferenced codingrequests
DELETE CR
FROM CodingRequests CR
WHERE NOT EXISTS (SELECT NULL FROM CodingElements CE 
	WHERE CE.CodingRequestId = CR.CodingRequestId)

-- empty log tables
TRUNCATE TABLE AsyncTaskNodeReports
TRUNCATE TABLE LogMessages
TRUNCATE TABLE OutServiceHeartbeats
TRUNCATE TABLE WorkflowRunnerServiceHeartbeat

-- OutTransmissions ??
-- workflowactivityresult?? 

