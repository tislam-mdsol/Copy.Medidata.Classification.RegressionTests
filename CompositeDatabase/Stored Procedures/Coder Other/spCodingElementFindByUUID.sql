IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementFindByUUID')
	DROP PROCEDURE spCodingElementFindByUUID
GO

CREATE PROCEDURE dbo.spCodingElementFindByUUID (
	@SourceSystemId INT,
	@SegmentId INT,
	@UUID NVARCHAR(100))
AS
BEGIN

	SELECT *
	FROM dbo.CodingElements
	WHERE SourceSystemId = @SourceSystemId
		AND SegmentId    = @SegmentId
		AND UUID         = @UUID

END
GO