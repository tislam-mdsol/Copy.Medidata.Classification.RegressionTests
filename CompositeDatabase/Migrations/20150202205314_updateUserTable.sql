
IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_Users_DisplayPrimaryPathOnly'
		 AND type = 'D')
	ALTER TABLE Users
	DROP CONSTRAINT DF_Users_DisplayPrimaryPathOnly
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users'
		 AND COLUMN_NAME = 'DisplayPrimaryPathOnly')
	ALTER TABLE Users
	DROP COLUMN  DisplayPrimaryPathOnly

GO