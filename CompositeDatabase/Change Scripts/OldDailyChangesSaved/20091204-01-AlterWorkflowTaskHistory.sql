﻿IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WorkflowTaskHistory'
		 AND COLUMN_NAME = 'CodingAssignmentId')
	ALTER TABLE WorkflowTaskHistory
	ADD CodingAssignmentId BIGINT
GO