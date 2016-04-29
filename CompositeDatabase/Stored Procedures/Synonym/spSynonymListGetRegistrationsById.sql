IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSynonymListGetRegistrationsById')
	DROP PROCEDURE dbo.spSynonymListGetRegistrationsById
GO

CREATE PROCEDURE [dbo].spSynonymListGetRegistrationsById
(
	@SynonymListId INT
)
AS
BEGIN

	SELECT StudyDictionaryVersionId, StudyId, SynonymManagementID
	FROM StudyDictionaryVersion
	WHERE SynonymManagementID = @SynonymListId

END
GO
