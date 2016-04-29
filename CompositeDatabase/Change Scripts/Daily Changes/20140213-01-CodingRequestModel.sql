-- add request state to CodingRequests
-- any coding request not in state = 1, is not ready for task processing
-- workflow service should take care of establishing coding request.request state
-- prior to processing a task in start state
-- any other state (other than 1) to be added as necessary

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingRequests'
		 AND COLUMN_NAME = 'RequestState')
	ALTER TABLE CodingRequests
	ADD RequestState TINYINT NOT NULL CONSTRAINT DF_CodingRequests_RequestState DEFAULT (1)
GO