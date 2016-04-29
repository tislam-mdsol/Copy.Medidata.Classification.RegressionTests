IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_MidwaySynonymMigrationsReport')
	DROP PROCEDURE CMP_MidwaySynonymMigrationsReport
GO

CREATE PROCEDURE dbo.CMP_MidwaySynonymMigrationsReport
AS
BEGIN
	
	SELECT SMM.MedicalDictionaryVersionLocaleKey AS Dictionary, 
		SMM.ListName AS SynonymList, 
		S.SegmentName AS Segment
	FROM SynonymMigrationMngmt SMM
		JOIN Segments S
			ON SMM.SegmentId = S.SegmentId
	WHERE SMM.SynonymMigrationStatusRID IN (2, 3, 4, 5)
        AND SMM.Deleted = 0

--	SELECT SMM.Locale AS Locale, 
--		DVR.OID,
--		DR.OID,
--		SMM.ListName AS SynonymList, 
--		S.SegmentName AS Segment
--	FROM SynonymMigrationMngmt SMM
--		JOIN Segments S
--			ON SMM.SegmentId = S.SegmentId
--		JOIN DictionaryVersionRef DVR
--			ON DVR.DictionaryVersionRefID = SMM.DictionaryVersionId
--		JOIN DictionaryRef DR
--			ON DR.DictionaryRefID = DVR.DictionaryRefID
--	WHERE SMM.SynonymMigrationStatusRID IN (2, 3, 4, 5)
--        AND SMM.Deleted = 0

END 
