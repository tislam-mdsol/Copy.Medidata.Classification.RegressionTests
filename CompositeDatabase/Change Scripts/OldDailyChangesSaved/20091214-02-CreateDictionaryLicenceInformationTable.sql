
-- Create table
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryLicenceInformations'
		 )
	CREATE TABLE DictionaryLicenceInformations(
		DictionaryLicenceInformationID INT IDENTITY(1,1) NOT NULL,
		MedicalDictionaryID INT NOT NULL,
		DictionaryLocale CHAR(3) NOT NULL,
		SegmentID INT NOT NULL,
		Active BIT NOT NULL,
		Deleted BIT NOT NULL,
		LicenceCode NVARCHAR(300),
		UserID INT NOT NULL,
		StartLicenceDate DATETIME NOT NULL,
		EndLicenceDate DATETIME NOT NULL,
		LicenceSubscriptionAction TINYINT NOT NULL,
		IsHistoricalEntry BIT NOT NULL,
		Created DATETIME NOT NULL,
		Updated DATETIME NOT NULL,
	 CONSTRAINT PK_DictionaryLicenceInformations PRIMARY KEY CLUSTERED 
	(
		DictionaryLicenceInformationID ASC
	)
	)
GO

-- create relationships

-- 1. Users
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_DictionaryLicenceInformations_UserId')
	ALTER TABLE DictionaryLicenceInformations
	WITH CHECK ADD CONSTRAINT FK_DictionaryLicenceInformations_UserId
		FOREIGN KEY(UserId) REFERENCES Users (UserId)
GO

-- 2. MedicalDictionary
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_DictionaryLicenceInformations_MedicalDictionaryID')
	ALTER TABLE DictionaryLicenceInformations
	WITH CHECK ADD  CONSTRAINT FK_DictionaryLicenceInformations_MedicalDictionaryID
		FOREIGN KEY(MedicalDictionaryID) REFERENCES MedicalDictionary (MedicalDictionaryID)
GO	

-- 3. Segments
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_DictionaryLicenceInformations_SegmentID')
	ALTER TABLE DictionaryLicenceInformations
	WITH CHECK ADD CONSTRAINT FK_DictionaryLicenceInformations_SegmentID 
		FOREIGN KEY(SegmentID ) REFERENCES Segments (SegmentID )
GO

 