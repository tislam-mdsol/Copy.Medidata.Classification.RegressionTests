IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLoadAllObjectSegmentsByObjectTypeAndSegment')
	DROP PROCEDURE spLoadAllObjectSegmentsByObjectTypeAndSegment
GO
CREATE PROCEDURE dbo.spLoadAllObjectSegmentsByObjectTypeAndSegment
(
	@ObjectTypeID INT,
	@SegmentID INT
)
AS

	SELECT * 
	FROM ObjectSegments 
	WHERE ObjectTypeID = @ObjectTypeID
		AND SegmentID = @SegmentID

GO 