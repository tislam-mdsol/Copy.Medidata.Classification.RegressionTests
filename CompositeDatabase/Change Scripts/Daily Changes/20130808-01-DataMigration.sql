IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DataMigrations')
BEGIN

	CREATE TABLE [dbo].[DataMigrations](
		DataMigrationID INT IDENTITY(1,1) NOT NULL,
		DataMigrationName NVARCHAR(500) NOT NULL,
		ServiceName VARCHAR(50) NOT NULL, -- governing service
		Created DATETIME NOT NULL CONSTRAINT [DF_DataMigrations_Created] DEFAULT (GETUTCDATE()),
		Updated DATETIME NOT NULL CONSTRAINT [DF_DataMigrations_Updated] DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_DataMigrations] PRIMARY KEY CLUSTERED 
	(
		DataMigrationID ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DataMigrationDetails')
BEGIN

	CREATE TABLE [dbo].[DataMigrationDetails](
		DataMigrationDetailID BIGINT IDENTITY(1,1) NOT NULL,
		DataMigrationID INT NOT NULL,
		ObjectTypeID INT NOT NULL,
		ObjectID BIGINT NOT NULL,
		DataMigrationRunID BIGINT NOT NULL CONSTRAINT [DF_DataMigrationDetails_DataMigrationRunID] DEFAULT (-1),
		IsProcessed BIT NOT NULL,
		Created DATETIME NOT NULL CONSTRAINT [DF_DataMigrationDetails_Created] DEFAULT (GETUTCDATE()),
		Updated DATETIME NOT NULL CONSTRAINT [DF_DataMigrationDetails_Updated] DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_DataMigrationDetails] PRIMARY KEY CLUSTERED 
	(
		DataMigrationDetailID ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DataMigrationRuns')
BEGIN

	CREATE TABLE [dbo].[DataMigrationRuns](
		DataMigrationRunID INT IDENTITY(1,1) NOT NULL,
		DataMigrationID INT NOT NULL,
		IsFailed BIT NOT NULL,
		IsSucceeded BIT NOT NULL,
		ExceptionData NVARCHAR(MAX),
		Created DATETIME NOT NULL CONSTRAINT [DF_DataMigrationRuns_Created] DEFAULT (GETUTCDATE()),
		Updated DATETIME NOT NULL CONSTRAINT [DF_DataMigrationRuns_Updated] DEFAULT (GETUTCDATE()),
	 CONSTRAINT [PK_DataMigrationRuns] PRIMARY KEY CLUSTERED 
	(
		DataMigrationRunId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

GO
-- also register the AutoApprove DataMigration
DECLARE @migrationFeature NVARCHAR(500) = 'AutoApprove(MCC-60981)'
DECLARE @migrationID INT

SELECT @migrationID = DataMigrationID
FROM DataMigrations 
WHERE DataMigrationName = @migrationFeature

IF (@migrationID IS NULL)
BEGIN
	INSERT INTO DataMigrations(DataMigrationName, ServiceName)
	SELECT @migrationFeature, 'AutomationService'

	SET @migrationID = SCOPE_IDENTITY()

END

DECLARE @cpTypeID INT,
	@sgcpTypeID INT

SELECT @sgcpTypeID = ObjectTypeId
FROM ObjectTypeR
WHERE ObjectTypeName = 'SegmentedGroupCodingPattern'

SELECT @cpTypeID = ObjectTypeId
FROM ObjectTypeR
WHERE ObjectTypeName = 'CodingPattern'

-- migrate CodingPatterns & SegmentedGroupCodingPatterns to conform to AutoApprove(MCC-60981)
BEGIN TRANSACTION
BEGIN TRY

	-- 0. Delete OLD DATA
	-- 0.a SegmentedGroupCodingPatterns
	DELETE SGCP
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN CodingPatterns cp
			ON sgcp.CodingPatternID = cp.CodingPatternID
		JOIN DictionaryLevelRef dlr
			on dlr.DictionaryLevelRefID = cp.DictionaryLevelID
		JOIN DictionaryRef dr
			on dlr.DictionaryRefID = dr.DictionaryRefID
	WHERE CHARINDEX('_Orig', dr.OID, 0) > 0
		OR CHARINDEX('_Old', dr.OID, 0) > 0

	-- 0.b CodingPatterns
	DELETE cp
	FROM CodingPatterns cp
		JOIN DictionaryLevelRef dlr
			on dlr.DictionaryLevelRefID = cp.DictionaryLevelID
		JOIN DictionaryRef dr
			on dlr.DictionaryRefID = dr.DictionaryRefID
	WHERE CHARINDEX('_Orig', dr.OID, 0) > 0
		OR CHARINDEX('_Old', dr.OID, 0) > 0

	-- 1. insert the codingpatterns
	IF NOT EXISTS (SELECT NULL FROM DataMigrationDetails WHERE DataMigrationID = @migrationID AND ObjectTypeID = @cpTypeID)
	BEGIN

		INSERT INTO DataMigrationDetails (DataMigrationID, ObjectTypeID, ObjectID, IsProcessed)
		SELECT @migrationID, @cpTypeID, CodingPatternID, 0
		FROM CodingPatterns cp

	END

	-- 2. insert the segmentedgroupcodingpatterns
	IF NOT EXISTS (SELECT NULL FROM DataMigrationDetails WHERE DataMigrationID = @migrationID AND ObjectTypeID = @sgcpTypeID)
	BEGIN

		INSERT INTO DataMigrationDetails (DataMigrationID, ObjectTypeID, ObjectID, IsProcessed)
		SELECT @migrationID, @sgcpTypeID, SegmentedGroupCodingPatternID, 0
		FROM SegmentedGroupCodingPatterns sgcp

	END

	COMMIT TRANSACTION
	
END TRY
BEGIN CATCH

	ROLLBACK TRANSACTION
	RAISERROR('Failed to compute migration entries', 1, 16)
	
END CATCH

