
-- Create table
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryVersionSubscriptions'
		 )
	CREATE TABLE DictionaryVersionSubscriptions(
		DictionaryVersionSubscriptionID INT IDENTITY(1,1) NOT NULL,
		Active BIT NOT NULL,
		Deleted BIT NOT NULL,
		UserID INT NOT NULL,
		ObjectSegmentID INT NOT NULL,
		VersionSubscriptionAction TINYINT NOT NULL,
		IsHistoricalEntry BIT NOT NULL,
		HistoricalVersionLocaleStatusID INT NOT NULL,
		Created DATETIME NOT NULL,
		Updated DATETIME NOT NULL,
	 CONSTRAINT PK_DictionaryVersionSubscriptions PRIMARY KEY CLUSTERED 
	(
		DictionaryVersionSubscriptionID ASC
	)
	)
GO

-- create relationships
-- 1. ObjectSegments
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_DictionaryVersionSubscriptions_ObjectSegmentId')
	ALTER TABLE DictionaryVersionSubscriptions
	WITH CHECK ADD  CONSTRAINT FK_DictionaryVersionSubscriptions_ObjectSegmentId 
		FOREIGN KEY(ObjectSegmentId) REFERENCES ObjectSegments (ObjectSegmentId)
GO

-- 2. Users
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_DictionaryVersionSubscriptions_UserId')
	ALTER TABLE DictionaryVersionSubscriptions
	WITH CHECK ADD  CONSTRAINT FK_DictionaryVersionSubscriptions_UserId
		FOREIGN KEY(UserId) REFERENCES Users (UserId)
GO

-- 3. MedicalDictVerLocaleStatus
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_DictionaryVersionSubscriptions_HistoricalVersionLocaleStatusID')
	ALTER TABLE DictionaryVersionSubscriptions
	WITH CHECK ADD  CONSTRAINT FK_DictionaryVersionSubscriptions_HistoricalVersionLocaleStatusID
		FOREIGN KEY(HistoricalVersionLocaleStatusID) REFERENCES MedicalDictVerLocaleStatus (MedicalDictVerLocaleStatusId)
GO	


