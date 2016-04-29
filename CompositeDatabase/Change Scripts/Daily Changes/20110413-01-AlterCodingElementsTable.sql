-- Add IsStillInService to CodingElements
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'IsStillInService')
	ALTER TABLE CodingElements
	ADD IsStillInService BIT NOT NULL DEFAULT (1)
GO  

