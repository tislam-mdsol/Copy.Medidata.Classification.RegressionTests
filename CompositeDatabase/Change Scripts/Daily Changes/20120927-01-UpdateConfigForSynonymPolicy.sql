-- ActiveOnWorkflowApproval becomes NeverActive
UPDATE Configuration
SET ConfigValue = '2' 
WHERE Tag = 'SynonymCreationPolicyFlag'
	AND ConfigValue = '3' 