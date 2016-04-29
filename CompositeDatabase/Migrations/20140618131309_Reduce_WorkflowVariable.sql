DECLARE @errorString NVARCHAR(MAX)
DECLARE @mapping TABLE(Id INT, OID VARCHAR(50))

INSERT INTO @mapping(Id, OID)
VALUES
	(1, 'IsAutoCode'),
	(2, 'IsReviewRequired'),
	(3, 'IsApprovalRequired'),
	(4, 'IsResetRequired'),
	(5, 'IsAutoApproval'),
	(6, 'IsAutoApproveExecutedAlready'),
	(7, 'IsBypassTransmit')
			
UPDATE WTD
SET WorkflowVariableID = M.Id
FROM WorkflowTaskData WTD
	JOIN WorkflowVariables WV
		ON WTD.WorkflowVariableID = WV.WorkflowVariableID
	JOIN @mapping M
		ON WV.VariableName = M.OID
WHERE WTD.WorkflowVariableID > 7