-- drop MedicalDictionaryTermID
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 AND COLUMN_NAME = 'MedicalDictionaryTermID')
BEGIN
		PRINT 'Dropping MedicalDictionaryTermID'
		ALTER TABLE CodingPatterns DROP CONSTRAINT DF_CodingPatterns_MedicalDictionaryTermID
		ALTER TABLE CodingPatterns DROP COLUMN MedicalDictionaryTermID 
END

-- remove VerbatimText from CodingElementGroups
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingElementGroups'
			AND COLUMN_NAME = 'VerbatimText')
	ALTER TABLE CodingElementGroups
	DROP COLUMN VerbatimText
GO



-- remove columns 
IF NOT EXISTS (SELECT NULL FROM ProjectDictionaryRegistrations
	WHERE DictionaryVersionID < 1)
BEGIN
	IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'ProjectDictionaryRegistrations'
				AND COLUMN_NAME = 'VersionOrdinal')
		ALTER TABLE ProjectDictionaryRegistrations
		DROP COLUMN VersionOrdinal
END
ELSE
	RAISERROR('ProjectDictionaryRegistrations. Cannot drop VersionOrdinal. There are entries not yet migrated.', 16, 1)



IF NOT EXISTS (SELECT NULL FROM StudyDictionaryVersion
	WHERE DictionaryVersionID < 1
		OR InitialDictionaryVersionID < 1)
BEGIN

	DECLARE @csName VARCHAR(200), @dynSQL VARCHAR(MAX)

	SELECT @csName = name
	FROM sys.default_constraints
	WHERE OBJECT_ID('StudyDictionaryVersion') = parent_object_id
		AND parent_column_id = (SELECT column_id FROM sys.columns
								WHERE OBJECT_ID('StudyDictionaryVersion') = object_id
									AND name = 'InitialVersionOrdinal')
	IF (@csName IS NOT NULL)
	BEGIN
		SET @dynSQL = 'ALTER TABLE StudyDictionaryVersion DROP CONSTRAINT ' + @csName
		EXEC(@dynSQL)
	END

	IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'StudyDictionaryVersion'
				AND COLUMN_NAME = 'InitialVersionOrdinal')
		ALTER TABLE StudyDictionaryVersion
		DROP COLUMN InitialVersionOrdinal

	IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'StudyDictionaryVersion'
				AND COLUMN_NAME = 'VersionOrdinal')
		ALTER TABLE StudyDictionaryVersion
		DROP COLUMN VersionOrdinal

END
ELSE
	RAISERROR('StudyDictionaryVersion. Cannot drop VersionOrdinal/InitialVersionOrdinal. There are entries not yet migrated.', 16, 1)


-- SynonymManagement
IF NOT EXISTS (SELECT NULL FROM SynonymMigrationMngmt
	WHERE DictionaryVersionID < 1)
BEGIN

	IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'SynonymMigrationMngmt'
				AND COLUMN_NAME = 'FromVersionOrdinal')
		ALTER TABLE SynonymMigrationMngmt
		DROP COLUMN FromVersionOrdinal

	IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'SynonymMigrationMngmt'
				AND COLUMN_NAME = 'ToVersionOrdinal')
		ALTER TABLE SynonymMigrationMngmt
		DROP COLUMN ToVersionOrdinal

END
ELSE
	RAISERROR('SynonymMigrationMngmt. Cannot drop FromVersionOrdinal/ToVersionOrdinal. There are entries not yet migrated.', 16, 1)

