UPDATE WTH
SET WTH.CodingElementGroupId = CE.CodingElementGroupId
FROM WorkflowTaskHistory WTH
	JOIN CodingElements CE
		ON WTH.WorkflowTaskId = CE.CodingElementId