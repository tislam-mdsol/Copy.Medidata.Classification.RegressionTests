-- add new column to flag invalid tasks (rejected from Rave)
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
		 AND COLUMN_NAME = 'IsInvalidTask')
	ALTER TABLE CodingElements
	ADD IsInvalidTask BIT NOT NULL CONSTRAINT DF_CodingElements_IsInvalidTask DEFAULT (0)
GO
