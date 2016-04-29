-- Add TimeZoneInfoId to UserPreferences
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'TimeZoneInfoId')
	ALTER TABLE UserPreferences
	ADD TimeZoneInfoId NVARCHAR(256) NULL
GO  
