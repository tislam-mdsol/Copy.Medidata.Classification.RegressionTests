DELETE sgcp
FROM SegmentedGroupCodingPatterns sgcp
	JOIN SynonymMigrationMngmt smm
		ON smm.SynonymMigrationMngmtID = sgcp.SynonymManagementID
WHERE smm.SynonymMigrationStatusRID = 1
