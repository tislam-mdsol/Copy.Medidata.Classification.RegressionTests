SET IDENTITY_INSERT SegmentMedicalDictionaryTemplates ON 

INSERT INTO SegmentMedicalDictionaryTemplates(TemplateID, TokenString, SegmentID, MedicalDictionaryId, IsDefault, IsReverse)
SELECT TemplateID, L.String, T.SegmentID, MedicalDictionaryId, IsDefault, 
	CASE WHEN First.PMax - Last.PMax > 0 THEN 1 ELSE 0 END AS IsReverse
FROM MedicalDictionaryTemplates T
	JOIN LocalizedDataStringPKs LP
		ON LP.StringId = T.NameStringId
	JOIN LocalizedDataStrings L	
		ON T.NameStringId = L.StringID
		AND L.Locale = LP.InsertedInLocale
	CROSS APPLY
	(
		SELECT TOP 1 PMax = DictionaryLevelId
		FROM MedicalDictionaryTemplateLevel l
		WHERE l.TemplateId = t.TemplateId
		ORDER BY Ordinal
	) AS First
	CROSS APPLY
	(
		SELECT TOP 1 PMax = DictionaryLevelId
		FROM MedicalDictionaryTemplateLevel l
		WHERE l.TemplateId = t.TemplateId
		ORDER BY Ordinal DESC
	) AS Last

SET IDENTITY_INSERT SegmentMedicalDictionaryTemplates OFF
