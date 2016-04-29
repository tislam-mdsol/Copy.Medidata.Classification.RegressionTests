IF EXISTS (SELECT NULL FROM MedDictTermUpdates
	WHERE ChangeTypeID = 3
		AND ImpactAnalysisChangeTypeId <> 4)
BEGIN

	UPDATE IAVD
	SET IAVD.ImpactAnalysisChangeTypeId = 4
	FROM ImpactAnalysisVersionDifference IAVD
	JOIN MedDictTermUpdates MDTU
		ON IAVD.OldTermID = MDTU.PriorTermID
		AND IAVD.FinalTermID = MDTU.FinalTermId
		AND IAVD.FromVersionOrdinal = MDTU.FromVersionOrdinal
		AND IAVD.ToVersionOrdinal = MDTU.ToVersionOrdinal
		AND IAVD.Locale = MDTU.Locale
		AND MDTU.ChangeTypeId = 3
		AND MDTU.ImpactAnalysisChangeTypeId <> 4

	UPDATE MedDictTermUpdates
	SET ImpactAnalysisChangeTypeId = 4
	WHERE ChangeTypeID = 3
		AND ImpactAnalysisChangeTypeId <> 4

END