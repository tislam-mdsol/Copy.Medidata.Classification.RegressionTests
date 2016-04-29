DECLARE @badVersions TABLE(MedicalDictionaryID INT, VersionOrdinal INT, LocaleID INT)

-- 1. find the bad versions
INSERT INTO @badVersions(MedicalDictionaryId, VersionOrdinal, LocaleID)
SELECT MedicalDictionaryId, ToVersionOrdinal, Locale
FROM MedDictTermUpdates
WHERE FinalTermID < 1
GROUP BY MedicalDictionaryId, ToVersionOrdinal, Locale

-- 2. update the term updates table
UPDATE TU
SET TU.FinalTermID = VT.FinalTermID
FROM @badVersions BV
	JOIN MedDictTermUpdates TU
		ON BV.MedicalDictionaryID = TU.MedicalDictionaryID
		AND BV.VersionOrdinal = TU.ToVersionOrdinal
		AND BV.LocaleID = TU.Locale
	JOIN MedicalDictVerTerm VT
		ON VT.TermId = TU.VersionTermID

-- 3. update the ImpactAnalysisVersionDifference table
UPDATE IA
SET IA.FinalTermID = TU.FinalTermId
FROM @badVersions BV
	JOIN ImpactAnalysisVersionDifference IA
		ON BV.MedicalDictionaryID = IA.MedicalDictionaryID
		AND BV.VersionOrdinal = IA.ToVersionOrdinal
		AND BV.LocaleID = IA.Locale
	JOIN MedDictTermUpdates TU
		ON TU.PriorTermID = IA.OldTermID
		AND TU.PriorTermID > 0
