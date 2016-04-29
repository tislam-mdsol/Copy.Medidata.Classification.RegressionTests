-- Add LevelRecursiveDepth
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictionaryTerm'
	 AND COLUMN_NAME = 'LevelRecursiveDepth'))
BEGIN
	ALTER TABLE MedicalDictionaryTerm 
	ADD LevelRecursiveDepth TINYINT NOT NULL CONSTRAINT DF_MedicalDictionaryTerm_LevelRecursiveDepth DEFAULT ((1))
END

GO

-- ALTER the version staging TABLE
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MedicalDictVerTerm'
	 AND COLUMN_NAME = 'LevelRecursiveDepth'))
BEGIN
	ALTER TABLE MedicalDictVerTerm 
	ADD LevelRecursiveDepth TINYINT NOT NULL CONSTRAINT DF_MedicalDictVerTerm_LevelRecursiveDepth DEFAULT ((1))
END

GO


IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE
	TABLE_NAME = 'MedicalDictionaryVersionLevelRecursion')
BEGIN
	
	CREATE TABLE MedicalDictionaryVersionLevelRecursion(
		MedicalDictionaryVersionLevelRecursionID INT IDENTITY(1,1) NOT NULL,
		MedicalDictionaryID INT NOT NULL,
		VersionOrdinal INT NOT NULL,
		DictionaryLevelID INT NOT NULL,
		MaxRecursiveDepth TINYINT NOT NULL,

		Active BIT NOT NULL,
		Deleted BIT NOT NULL,

		Created DATETIME NOT NULL,
		Updated DATETIME NOT NULL,
	 CONSTRAINT PK_MedicalDictionaryVersionLevelRecursion PRIMARY KEY CLUSTERED 
	(
		MedicalDictionaryVersionLevelRecursionID ASC
	)
	)	

END
 
GO

-- create relationships
-- 1. MedicalDictionary
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_MedicalDictionaryVersionLevelRecursion_MedicalDictionaryID')
	ALTER TABLE MedicalDictionaryVersionLevelRecursion
	WITH CHECK ADD  CONSTRAINT FK_MedicalDictionaryVersionLevelRecursion_MedicalDictionaryID 
		FOREIGN KEY(MedicalDictionaryID) REFERENCES MedicalDictionary (MedicalDictionaryID)
GO

-- 2. MedicalDictionaryLevel
IF NOT EXISTS (SELECT NULL FROM
	sys.foreign_keys WHERE name = 'FK_MedicalDictionaryVersionLevelRecursion_DictionaryLevelID')
	ALTER TABLE MedicalDictionaryVersionLevelRecursion
	WITH CHECK ADD  CONSTRAINT FK_MedicalDictionaryVersionLevelRecursion_DictionaryLevelID
		FOREIGN KEY(DictionaryLevelID) REFERENCES MedicalDictionaryLevel (DictionaryLevelID)
GO

-- Pre-Populate MedicalDictionaryVersionLevelRecursion (with recursion 1)

DECLARE @MedicalDictionaryID INT, @VersionOrdinal INT, @LevelID INT, @MaxRecursiveDepth TINYINT

DECLARE @UTCDATE DATETIME

SET @UTCDATE = GETUTCDATE()

DECLARE versionLevelsCursor CURSOR FAST_FORWARD FOR
	SELECT M.MedicalDictionaryID, V.Ordinal, L.DictionaryLevelID
	FROM MedicalDictionary M
		JOIN MedicalDictionaryVersion V
			ON M.MedicalDictionaryID = V.MedicalDictionaryID
		JOIN MedicalDictionaryLevel L
			ON M.MedicalDictionaryID = L.MedicalDictionaryID

OPEN versionLevelsCursor
FETCH NEXT FROM versionLevelsCursor INTO @MedicalDictionaryID, @VersionOrdinal, @LevelID

SET @MaxRecursiveDepth = 1


WHILE (@@FETCH_STATUS = 0)
BEGIN

	IF NOT EXISTS (SELECT NULL FROM MedicalDictionaryVersionLevelRecursion
		WHERE MedicalDictionaryID = @MedicalDictionaryID
			AND VersionOrdinal = @VersionOrdinal
			AND DictionaryLevelID = @LevelID)
	BEGIN	

		INSERT INTO MedicalDictionaryVersionLevelRecursion
		(MedicalDictionaryID,
		VersionOrdinal,
		DictionaryLevelID,
		MaxRecursiveDepth,
		Active,
		Deleted,
		Created,
		Updated)
		VALUES(
		@MedicalDictionaryID,
		@VersionOrdinal,
		@LevelID,
		@MaxRecursiveDepth, 
		1,
		0,
		@UTCDATE,
		@UTCDATE
		)

	END

	FETCH NEXT FROM versionLevelsCursor INTO @MedicalDictionaryID, @VersionOrdinal, @LevelID
	
END

CLOSE versionLevelsCursor
DEALLOCATE versionLevelsCursor

SELECT @MedicalDictionaryID = L.MedicalDictionaryID,
	@LevelID = L.DictionaryLevelID,
	@MaxRecursiveDepth = 4
FROM MedicalDictionaryLevel L
	JOIN MedicalDictionary M
		ON L.MedicalDictionaryID = M.MedicalDictionaryID
		AND M.OID = 'WHODRUGC'
		AND L.OID = 'ATC'

-- Update WHODrugC recursive info (currently 4 for all levels on ATC)
UPDATE MedicalDictionaryVersionLevelRecursion
SET MaxRecursiveDepth = @MaxRecursiveDepth
WHERE MedicalDictionaryID = @MedicalDictionaryID
	AND DictionaryLevelID = @LevelID

GO

-- FOR each recursive level (depth bigger than 1) -- update the existing tables (currently only the term table)

DECLARE @MedicalDictionaryID INT, @VersionOrdinal INT, @LevelID INT

DECLARE recursiveLevelsCursor CURSOR FAST_FORWARD FOR
	SELECT MedicalDictionaryID, VersionOrdinal, DictionaryLevelID
	FROM MedicalDictionaryVersionLevelRecursion
	WHERE MaxRecursiveDepth > 1
			

OPEN recursiveLevelsCursor
FETCH NEXT FROM recursiveLevelsCursor INTO @MedicalDictionaryID, @VersionOrdinal, @LevelID

WHILE (@@FETCH_STATUS = 0)
BEGIN

	IF NOT EXISTS (SELECT NULL FROM MedicalDictionaryTerm
		WHERE MedicalDictionaryID = @MedicalDictionaryID
			AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
			AND DictionaryLevelID = @LevelID
			AND LevelRecursiveDepth > 1)
	BEGIN
	
		UPDATE MedicalDictionaryTerm
		SET LevelRecursiveDepth = dbo.fnMedDictVerMaxNodePathDepth(Nodepath)
		WHERE MedicalDictionaryID = @MedicalDictionaryID
			AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
			AND DictionaryLevelID = @LevelID

	END
	
	FETCH NEXT FROM recursiveLevelsCursor INTO @MedicalDictionaryID, @VersionOrdinal, @LevelID
END

CLOSE recursiveLevelsCursor
DEALLOCATE recursiveLevelsCursor

GO

