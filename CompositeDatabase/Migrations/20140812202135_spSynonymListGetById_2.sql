IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymListGetById')
	DROP PROCEDURE spSynonymListGetById
GO

CREATE PROCEDURE dbo.spSynonymListGetById(
	@SynonymListId INT
)
AS
BEGIN 
	SELECT SL.*, DR.OID AS DictionaryOID, DVR.OID AS DictionaryVersionOID, DVR.Ordinal AS VersionOrdinal
	FROM SynonymMigrationMngmt SL
	JOIN DictionaryRef DR ON DR.DictionaryRefID=SL.MedicalDictionaryID
	JOIN DictionaryVersionRef DVR ON DVR.DictionaryVersionRefID = SL.DictionaryVersionId
	WHERE SL.SynonymMigrationMngmtID=@SynonymListId
	AND SL.Deleted = 0
END
GO
