IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingElementLoadBySegment')
	DROP PROCEDURE dbo.spCodingElementLoadBySegment
GO

create procedure dbo.spCodingElementLoadBySegment
(
	@SegmentID BIGINT
)
as

	SELECT * 
	FROM CodingElements
	WHERE SegmentID = @SegmentID

GO