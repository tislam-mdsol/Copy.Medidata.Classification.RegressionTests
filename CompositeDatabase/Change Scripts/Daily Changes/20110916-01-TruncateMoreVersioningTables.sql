-- unconditionally truncate MedicalDictVerTermRel
-- if the versions have been activated
DECLARE @unactivatedVersions TABLE(DictionaryID INT, Ordinal INT)

-- 1. check unactivated
;WITH VR
AS
(
	SELECT MedicalDictionaryID, DictionaryVersionOrdinal
	FROM MedDictVerTermComponents
	GROUP BY MedicalDictionaryID, DictionaryVersionOrdinal
)

INSERT INTO @unactivatedVersions(DictionaryID, Ordinal)
SELECT VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal
FROM VR
	LEFT JOIN MedicalDictVerLocaleStatus VLS
		ON VR.MedicalDictionaryID = VLS.MedicalDictionaryID
		AND VR.DictionaryVersionOrdinal = VLS.NewVersionOrdinal
		AND VLS.OldVersionOrdinal IS NULL
		AND VLS.Locale = 'eng'
		AND VLS.VersionStatus <> 8
WHERE VLS.MedicalDictVerLocaleStatusID IS NOT NULL
GROUP BY VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal

-- 2. check undifferenced
;WITH VR
AS
(
	SELECT MedicalDictionaryID, DictionaryVersionOrdinal
	FROM MedDictVerTermComponents
	GROUP BY MedicalDictionaryID, DictionaryVersionOrdinal
)

INSERT INTO @unactivatedVersions(DictionaryID, Ordinal)
SELECT VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal
FROM VR
	LEFT JOIN MedicalDictVerLocaleStatus VLS
		ON VR.MedicalDictionaryID = VLS.MedicalDictionaryID
		AND VR.DictionaryVersionOrdinal = VLS.NewVersionOrdinal
		AND VLS.OldVersionOrdinal IS NOT NULL
		AND VLS.Locale = 'eng'
		AND VLS.VersionStatus <> 10
WHERE VLS.MedicalDictVerLocaleStatusID IS NOT NULL
GROUP BY VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal

IF 0 = (SELECT COUNT(*) FROM @unactivatedVersions)
BEGIN
	PRINT N'All Versions already activated. Truncating MedicalDictVerTermRel!'
	TRUNCATE TABLE MedicalDictVerTermRel
END
ELSE
BEGIN
	PRINT N'Some Versions not activated. Skipping truncating and going with delete!'
	DELETE FROM MedicalDictVerTermRel
	WHERE NOT EXISTS (SELECT NULL FROM @unactivatedVersions
		WHERE DictionaryID = MedicalDictionaryID AND Ordinal = DictionaryVersionOrdinal)
END
GO

---- conditionally truncate MedDictVerTermComponents
---- if the versions have been activated, only if there are no other dictionary types
---- present, otherwise opt for the longer delete method
DECLARE @cmpVersions TABLE(DictionaryID INT, Ordinal INT, IsDeletable BIT)

-- 1. check unactivated
;WITH VR
AS
(
	SELECT MedicalDictionaryID, DictionaryVersionOrdinal
	FROM MedDictVerTermComponents
	GROUP BY MedicalDictionaryID, DictionaryVersionOrdinal
)

INSERT INTO @cmpVersions(DictionaryID, Ordinal, IsDeletable)
SELECT VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal,
	CASE WHEN MD.MedicalDictionaryID IS NULL OR VLS.MedicalDictVerLocaleStatusID IS NOT NULL THEN 0
		ELSE 1
	END
FROM VR
	LEFT JOIN MedicalDictionary MD
		ON VR.MedicalDictionaryID = MD.MedicalDictionaryId
		AND MD.MedicalDictionaryType IN ('WhoDRUGB2', 'WhoDRUGC')
	LEFT JOIN MedicalDictVerLocaleStatus VLS
		ON VR.MedicalDictionaryID = VLS.MedicalDictionaryID
		AND VR.DictionaryVersionOrdinal = VLS.NewVersionOrdinal
		AND VLS.OldVersionOrdinal IS NULL
		AND VLS.Locale = 'eng'
		AND VLS.VersionStatus <> 8
GROUP BY VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal,
	CASE WHEN MD.MedicalDictionaryID IS NULL OR VLS.MedicalDictVerLocaleStatusID IS NOT NULL THEN 0
		ELSE 1
	END

-- 2. check undifferenced
;WITH VR
AS
(
	SELECT MedicalDictionaryID, DictionaryVersionOrdinal
	FROM MedDictVerTermComponents
	GROUP BY MedicalDictionaryID, DictionaryVersionOrdinal
)

INSERT INTO @cmpVersions(DictionaryID, Ordinal, IsDeletable)
SELECT VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal,
	CASE WHEN MD.MedicalDictionaryID IS NULL OR VLS.MedicalDictVerLocaleStatusID IS NOT NULL THEN 0
		ELSE 1
	END
FROM VR
	LEFT JOIN MedicalDictionary MD
		ON VR.MedicalDictionaryID = MD.MedicalDictionaryId
		AND MD.MedicalDictionaryType IN ('WhoDRUGB2', 'WhoDRUGC')
	LEFT JOIN MedicalDictVerLocaleStatus VLS
		ON VR.MedicalDictionaryID = VLS.MedicalDictionaryID
		AND VR.DictionaryVersionOrdinal = VLS.NewVersionOrdinal
		AND VLS.OldVersionOrdinal IS NOT NULL
		AND VLS.Locale = 'eng'
		AND VLS.VersionStatus <> 10
GROUP BY VR.MedicalDictionaryID, VR.DictionaryVersionOrdinal,
	CASE WHEN MD.MedicalDictionaryID IS NULL OR VLS.MedicalDictVerLocaleStatusID IS NOT NULL THEN 0
		ELSE 1
	END
	
IF 0 = (SELECT COUNT(*) FROM @cmpVersions WHERE IsDeletable = 0)
BEGIN
	PRINT N'All Versions already activated. Truncating MedDictVerTermComponents!'
	TRUNCATE TABLE MedDictVerTermComponents
END
ELSE
BEGIN
	PRINT N'Some Versions not activated. Skipping truncating and going with delete!'
	DELETE FROM MedDictVerTermComponents
	WHERE NOT EXISTS (SELECT NULL FROM @cmpVersions
		WHERE DictionaryID = MedicalDictionaryID 
			AND Ordinal = DictionaryVersionOrdinal
			AND IsDeletable = 0)
END

GO