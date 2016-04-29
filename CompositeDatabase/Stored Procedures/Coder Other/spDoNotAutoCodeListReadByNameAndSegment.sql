IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeListReadByNameAndSegment')
	DROP PROCEDURE spDoNotAutoCodeListReadByNameAndSegment
GO

CREATE PROCEDURE dbo.spDoNotAutoCodeListReadByNameAndSegment
	@SegmentId				INT,
	@ListName NVARCHAR(100)
AS
BEGIN

	SELECT *
	FROM  DoNotAutoCodeLists
	WHERE ListName = @ListName
		AND   [SegmentId]			= @SegmentId

END 
GO 