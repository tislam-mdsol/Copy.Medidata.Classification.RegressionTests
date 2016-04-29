UPDATE SDVH
SET 
	SDVH.FromDictionaryVersionId = DVR_FROM.DictionaryVersionRefID,
	SDVH.ToDictionaryVersionId   = DVR_TO.DictionaryVersionRefID
FROM StudyDictionaryVersionHistory SDVH
	JOIN StudyDictionaryVersion SDV
		ON SDVH.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
	JOIN SynonymMigrationMngmt SMM
		ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
	JOIN DictionaryVersionRef DVR_Main
		ON SMM.DictionaryVersionId = DVR_Main.DictionaryVersionRefID
	JOIN DictionaryVersionRef DVR_FROM
		ON DVR_Main.DictionaryRefID = DVR_FROM.DictionaryRefID
		AND DVR_FROM.Ordinal = SDVH.FromVersionOrdinal
	JOIN DictionaryVersionRef DVR_TO
		ON DVR_Main.DictionaryRefID = DVR_TO.DictionaryRefID
		AND DVR_TO.Ordinal = SDVH.ToVersionOrdinal

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'FromVersionOrdinal')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP COLUMN FromVersionOrdinal
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StudyDictionaryVersionHistory'
		 AND COLUMN_NAME = 'ToVersionOrdinal')
	ALTER TABLE StudyDictionaryVersionHistory
	DROP COLUMN ToVersionOrdinal
GO