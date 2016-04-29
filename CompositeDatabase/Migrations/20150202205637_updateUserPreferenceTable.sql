IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_BrowserActiveTabIndex'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_BrowserActiveTabIndex
GO


IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideBrowserPropDetailRow0'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideBrowserPropDetailRow0
GO


IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideBrowserPropDetailRow1'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideBrowserPropDetailRow1
GO


IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideBrowserPropDetailRow2'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideBrowserPropDetailRow2
GO


IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideBrowserPropDetailRow3'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideBrowserPropDetailRow3
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideTaskPropDetailRow0'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideTaskPropDetailRow0
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideTaskPropDetailRow1'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideTaskPropDetailRow1
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideTaskPropDetailRow2'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideTaskPropDetailRow2
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_HideTaskPropDetailRow3'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_HideTaskPropDetailRow3
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_PopupActiveTabIndex'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_PopupActiveTabIndex
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'DF_UserPreferences_TaskActiveTabIndex'
		 AND type = 'D')
	ALTER TABLE UserPreferences
	DROP CONSTRAINT DF_UserPreferences_TaskActiveTabIndex
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'SessionId')
	ALTER TABLE UserPreferences
	DROP COLUMN SessionId 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'TaskActiveTabIndex')
	ALTER TABLE UserPreferences
	DROP COLUMN TaskActiveTabIndex 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'BrowserActiveTabIndex')
	ALTER TABLE UserPreferences
	DROP COLUMN BrowserActiveTabIndex 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'PopupActiveTabIndex')
	ALTER TABLE UserPreferences
	DROP COLUMN PopupActiveTabIndex 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideTaskPropDetailRow0')
	ALTER TABLE UserPreferences
	DROP COLUMN HideTaskPropDetailRow0 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideTaskPropDetailRow1')
	ALTER TABLE UserPreferences
	DROP COLUMN HideTaskPropDetailRow1 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideTaskPropDetailRow2')
	ALTER TABLE UserPreferences
	DROP COLUMN HideTaskPropDetailRow2 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideTaskPropDetailRow3')
	ALTER TABLE UserPreferences
	DROP COLUMN HideTaskPropDetailRow3 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideBrowserPropDetailRow0')
	ALTER TABLE UserPreferences
	DROP COLUMN HideBrowserPropDetailRow0 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideBrowserPropDetailRow1')
	ALTER TABLE UserPreferences
	DROP COLUMN HideBrowserPropDetailRow1 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideBrowserPropDetailRow2')
	ALTER TABLE UserPreferences
	DROP COLUMN HideBrowserPropDetailRow2 

GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'HideBrowserPropDetailRow3')
	ALTER TABLE UserPreferences
	DROP COLUMN HideBrowserPropDetailRow3 

GO
IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserPreferences'
		 AND COLUMN_NAME = 'TimeZoneInfoId')
	ALTER TABLE UserPreferences
	DROP COLUMN TimeZoneInfoId 

GO

