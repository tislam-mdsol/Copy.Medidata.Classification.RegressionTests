-- 1. Wipe MedDRA Lists
DELETE DoNotAutoCodeTerms
WHERE CHARINDEX('MedDRA', MedicalDictionaryVersionLocaleKey, 0) = 1
	AND ListId = 0

-- 2. listId & ListName
;WITH newDNAClists AS
(
	SELECT TOP 10000 
		SegmentId, MedicalDictionaryVersionLocaleKey
	FROM DoNotAutoCodeTerms
	WHERE ListId = 0
	GROUP BY SegmentId, MedicalDictionaryVersionLocaleKey
)

INSERT INTO DoNotAutoCodeLists (SegmentId, MedicalDictionaryVersionLocaleKey, ListName)
SELECT N.SegmentId, N.MedicalDictionaryVersionLocaleKey, N.MedicalDictionaryVersionLocaleKey
FROM newDNAClists N
	LEFT JOIN DoNotAutoCodeLists L
		ON N.SegmentId = L.SegmentId
		AND N.MedicalDictionaryVersionLocaleKey = L.MedicalDictionaryVersionLocaleKey
WHERE L.ListId IS NULL

UPDATE DNAC
SET DNAC.ListId = t.ListId
FROM DoNotAutoCodeTerms DNAC
	JOIN DoNotAutoCodeLists t
		ON DNAC.SegmentId = t.SegmentId
		AND DNAC.MedicalDictionaryVersionLocaleKey = t.MedicalDictionaryVersionLocaleKey
WHERE DNAC.ListId = 0

-- 3. Restore MedDRA Lists

-- 3.1 assign list id
DECLARE @t TABLE(
	OldListname VARCHAR(50),
	newListName NVARCHAR(200), 
	versionOid VARCHAR(50), 
	locale CHAR(30), 
	MedicalDictionaryVersionLocaleKey VARCHAR(100),
	SegmentId INT,
	ListId INT)

;WITH medDRADNAC AS
(
	SELECT TOP 10000 dnaclistname, versionoid, locale, segmentid
	FROM DnacMedDRABackup
	GROUP BY dnaclistname, versionoid, locale, segmentid
)

INSERT INTO @t(OldListname, newListName, versionoid, locale, segmentid, MedicalDictionaryVersionLocaleKey)
SELECT dnaclistname, dnaclistname+'-'+VersionLocale.Ky,
	versionoid, locale, segmentid,
	'MedDRA-'+VersionLocale.Ky
FROM medDRADNAC
		CROSS APPLY
		(
			SELECT Ky = REPLACE(versionOid, '.', '_')+
			CASE WHEN Locale = 'eng' THEN '-English' ELSE '-Japanese' END
		) VersionLocale

INSERT INTO DoNotAutoCodeLists (SegmentId, MedicalDictionaryVersionLocaleKey, ListName)
SELECT t.SegmentId, t.MedicalDictionaryVersionLocaleKey, 
	t.newListName
FROM @t t
	LEFT JOIN DoNotAutoCodeLists L
		ON t.SegmentId = L.SegmentId
		AND t.MedicalDictionaryVersionLocaleKey = L.MedicalDictionaryVersionLocaleKey
		AND t.newListName = L.ListName
WHERE L.ListId IS NULL

UPDATE t
SET t.ListId = L.ListId
FROM @t t
	JOIN DoNotAutoCodeLists L
		ON t.SegmentId = L.SegmentId
		AND t.MedicalDictionaryVersionLocaleKey = L.MedicalDictionaryVersionLocaleKey
		AND t.newListName = L.ListName


IF NOT EXISTS (SELECT NULL FROM DoNotAutoCodeTerms
	WHERE CHARINDEX('MedDRA', MedicalDictionaryVersionLocaleKey, 0) = 1)
BEGIN

	INSERT INTO DoNotAutoCodeTerms
	(ListId, SegmentId, UserId, Term, MedicalDictionaryLevelKey,
	-- columns to be removed below
	MedicalDictionaryVersionLocaleKey, 
	DictionaryLocale_Backup,
	DictionaryVersionId_Backup,
	DictionaryLevelId_Backup
	)
	SELECT 
		t.ListId,

		B.SegmentId,
		B.UserId,
		B.Term,
		B.MedicalDictionaryLevelKey,

		--  columns to be removed below
		t.MedicalDictionaryVersionLocaleKey, B.Locale, 0, 0
	FROM DnacMedDRABackup B
		JOIN @t t
			ON B.DnacListName = t.oldlistname
			AND B.SegmentId = t.SegmentId
			AND B.VersionOid = t.versionOid
			AND B.Locale = t.locale

END
