

-- Add new column to Application table, to store relationship to SourceSystem
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'Application' AND COLUMN_NAME = 'SourceSystemID')
	)
BEGIN
	ALTER TABLE Application
	ADD SourceSystemID INT NOT NULL DEFAULT(-1)
END 
GO
 