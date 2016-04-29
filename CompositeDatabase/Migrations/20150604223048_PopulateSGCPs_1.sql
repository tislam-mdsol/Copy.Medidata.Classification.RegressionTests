IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'NewCodingPatterns')
BEGIN

	UPDATE sgcp
	SET sgcp.CodingPatternID = cp.CodingPatternId,
		sgcp.CodingPatternID_Backup = cp.OldCodingPatternId
	FROM NewCodingPatterns cp
		JOIN SegmentedGroupCodingPatterns sgcp
			ON cp.OldCodingPatternId = sgcp.CodingPatternID
		JOIN SynonymMigrationMngmt SMM
			ON SMM.SynonymMigrationMngmtID = sgcp.SynonymManagementID
	WHERE smm.DictionaryVersionId = CP.VersionId
		AND smm.Locale = CP.Locale
		
	EXEC sp_rename 'CodingPatterns', 'CodingPatterns_Backup'
	EXEC sp_rename 'NewCodingPatterns', 'CodingPatterns'

END
