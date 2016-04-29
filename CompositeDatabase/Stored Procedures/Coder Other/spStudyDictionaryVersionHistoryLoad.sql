IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryVersionHistoryLoad')
	DROP PROCEDURE dbo.spStudyDictionaryVersionHistoryLoad
GO
Create PROCEDURE [dbo].[spStudyDictionaryVersionHistoryLoad]
(
	@StudyDictionaryVersionId INT
)
AS

	SELECT *
	FROM StudyDictionaryVersionHistory
	WHERE StudyDictionaryVersionId = @StudyDictionaryVersionId
	ORDER BY StudyDictionaryVersionHistoryID ASC