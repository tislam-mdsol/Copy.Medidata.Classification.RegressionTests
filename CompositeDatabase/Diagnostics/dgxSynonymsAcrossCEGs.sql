-- Background : verify data integrity
-- *** Synonyms must pertain to synonym lists which are wired
-- to incorrect CEGs (matching in dictionary context!)

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'dgxSynonymsAcrossCEGs')
	DROP PROCEDURE dgxSynonymsAcrossCEGs
GO

CREATE PROCEDURE dbo.dgxSynonymsAcrossCEGs
AS  
BEGIN

	;WITH affectedSynonyms AS						
	(						
		SELECT sgcp.SegmentedGroupCodingPatternID,						
			sgcp.SynonymManagementID					
		FROM SegmentedGroupCodingPatterns sgcp						
			JOIN SynonymMigrationMngmt smm						
				ON sgcp.SynonymManagementID = smm.SynonymMigrationMngmtID						
			JOIN CodingElementGroups ceg						
				ON ceg.CodingElementGroupID = sgcp.CodingElementGroupID						
			CROSS APPLY						
			(						
				SELECT dictionaryType =					
				SUBSTRING(
					ceg.MedicalDictionaryLevelKey, 
					1, 
					LEN(ceg.MedicalDictionaryLevelKey) + 1 - CHARINDEX('-',REVERSE(ceg.MedicalDictionaryLevelKey), 1))					
			) AS x						
		WHERE CHARINDEX(x.dictionaryType, smm.MedicalDictionaryVersionLocaleKey, 1) <> 1						
	),						
	groupedSyns AS						
	(						
		SELECT count(1) as badSynonyms, SynonymManagementID						
		FROM affectedSynonyms						
		GROUP BY SynonymManagementID						
	)
					
	SELECT s.SegmentName, smm.MedicalDictionaryVersionLocaleKey, smm.ListName, syn.badSynonyms, allSynonyms						
	FROM groupedSyns Syn						
		JOIN SynonymMigrationMngmt smm					
			ON smm.SynonymMigrationMngmtID = Syn.SynonymManagementID				
		JOIN Segments s					
			ON s.SegmentId = smm.SegmentID				
		CROSS APPLY					
		(					
			SELECT COUNT(1) as allSynonyms				
			FROM SegmentedGroupCodingPatterns sgcp				
			WHERE sgcp.SynonymManagementID = syn.SynonymManagementID				
		) AS g					
	ORDER BY s.SegmentName, smm.MedicalDictionaryVersionLocaleKey, smm.ListName									

END