DECLARE @numDuplicateGroups INT

;WITH P AS
(
	SELECT
		GroupVerbatimID, DictionaryLocale, SegmentID, MedicalDictionaryLevelKey, CompositeKey, COUNT(1) AS CC,
		MIN(CodingElementGroupID) AS MINCodingElementGroupID,
		MAX(CodingElementGroupID) AS MAXCodingElementGroupID
	FROM CodingElementGroups ceg
		CROSS APPLY
		(
			SELECT ISNULL(MAX(CompositeKey), '') AS CompositeKey
			FROM 
			(
				SELECT CAST(SupplementFieldKeyId AS VARCHAR) +':'+CAST(NameTextID AS VARCHAR) + ';'
				FROM CodingElementGroupComponents cegc
				WHERE cegc.CodingElementGroupID = ceg.CodingElementGroupID
				ORDER BY SupplementFieldKeyId, NameTextID
				FOR XML PATH('')
			) AS X (CompositeKey)
		) AS X
	GROUP BY GroupVerbatimID, DictionaryLocale, SegmentID, MedicalDictionaryLevelKey, CompositeKey
	HAVING COUNT(1) > 1
)

--SELECT SegmentID, DictionaryLocale, MedicalDictionaryLevelKey, COUNT(1)
--FROM P
--GROUP BY SegmentID, DictionaryLocale, MedicalDictionaryLevelKey

SELECT @numDuplicateGroups = COUNT(1)
FROM P

IF (@numDuplicateGroups > 0)
BEGIN
	DECLARE @errorString VARCHAR(200) = 'Duplicate Groups Found:' + CAST(@numDuplicateGroups AS VARCHAR)
	RAISERROR(@errorString, 16, 1)
END
 