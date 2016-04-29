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

END 

