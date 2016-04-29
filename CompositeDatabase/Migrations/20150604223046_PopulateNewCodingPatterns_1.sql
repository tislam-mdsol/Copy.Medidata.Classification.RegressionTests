
;WITH uniquePathsPerCodingContext AS
(
	SELECT smm.DictionaryVersionId, smm.Locale, cp.CodingPath, DictionaryLevelId
	FROM CodingPatterns cp
		JOIN SegmentedGroupCodingPatterns sgcp
			ON cp.CodingPatternID = sgcp.CodingPatternID
		JOIN SynonymMigrationMngmt smm
			ON sgcp.SynonymManagementID = smm.SynonymMigrationMngmtID
	GROUP BY smm.DictionaryVersionId, smm.Locale, cp.CodingPath, cp.DictionaryLevelId
),
allNewPaths AS
(
	SELECT cp.*, u.DictionaryVersionId, u.Locale
	FROM uniquePathsPerCodingContext u
		JOIN CodingPatterns cp
			on u.CodingPath = cp.CodingPath
			AND u.DictionaryLevelID = cp.DictionaryLevelID
)

INSERT INTO NewCodingPatterns
(CodingPath, VersionId, Locale, LevelId, PathCount, Created, OldCodingPatternId)
SELECT CodingPath, DictionaryVersionId, Locale, DictionaryLevelId, PathCount, Created, CodingPatternId
FROM allNewPaths
