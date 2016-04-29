-- Create table
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SubscriptionLogs'
		 )
	CREATE TABLE SubscriptionLogs(
		SubscriptionLogID INT IDENTITY(1,1) NOT NULL,
		VersionLocaleStatusID INT NOT NULL,
		UserID INT NOT NULL,

		Active BIT NOT NULL,
		Deleted BIT NOT NULL,
		Created DATETIME NOT NULL,
		Updated DATETIME NOT NULL,
	 CONSTRAINT PK_SubscriptionLogs PRIMARY KEY CLUSTERED 
	 (
		SubscriptionLogID ASC
	 )
	)
GO 

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		AND Column_Name = 'SubscriptionLogID' )
		ALTER TABLE DictionaryVersionSubscriptions
		ADD SubscriptionLogID INT NOT NULL CONSTRAINT DF_DictionaryVersionSubscriptions_SubscriptionLogID DEFAULT ((-1))
GO

