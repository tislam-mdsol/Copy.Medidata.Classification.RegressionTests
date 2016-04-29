
-- add new column for batching of coding requests (unsed in coding decision unload)
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingRequests' AND COLUMN_NAME = 'BatchOID')
	)
BEGIN
	ALTER TABLE CodingRequests
	ADD BatchOID NVARCHAR(500) DEFAULT(NULL)
END 
GO
