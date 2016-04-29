IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryVersionLoadAll')
	DROP PROCEDURE spStudyDictionaryVersionLoadAll
GO

CREATE PROCEDURE [dbo].[spStudyDictionaryVersionLoadAll]
(
	@SegmentID INT
)
AS
BEGIN

	SELECT * 
	from StudyDictionaryVersion
	WHERE SegmentID = @SegmentID

END