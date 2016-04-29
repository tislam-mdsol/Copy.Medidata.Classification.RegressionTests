IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymListGetBySegmentId')
	DROP PROCEDURE spSynonymListGetBySegmentId
GO

CREATE PROCEDURE dbo.spSynonymListGetBySegmentId(
	@SegmentId BIGINT
)
AS
BEGIN 
	SELECT SL.*, DR.OID AS DictionaryOID, DVR.OID AS DictionaryVersionOID, DVR.Ordinal AS VersionOrdinal
	FROM SynonymMigrationMngmt SL
	JOIN DictionaryRef DR ON DR.DictionaryRefID=SL.MedicalDictionaryID
	JOIN DictionaryVersionRef DVR ON DVR.DictionaryVersionRefID = SL.DictionaryVersionId
	WHERE SL.SegmentID=@SegmentId
	AND SL.Deleted = 0
END
GO
