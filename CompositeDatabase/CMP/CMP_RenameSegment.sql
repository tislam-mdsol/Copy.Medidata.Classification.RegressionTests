IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_RenameSegment')
	DROP PROCEDURE spCoder_CMP_RenameSegment
GO

CREATE PROCEDURE dbo.spCoder_CMP_RenameSegment
(
	@OriginalSegmentName NVARCHAR(255),
	@UpdatedSegmentName NVARCHAR(255)
)
AS
BEGIN

    DECLARE @SegmentId INT
	DECLARE @errorString NVARCHAR(MAX)

	IF (1 < (SELECT COUNT(*)
		FROM Segments
		WHERE SegmentName = @OriginalSegmentName))
	BEGIN
		SET @errorString = N'ERROR: More than one segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	IF EXISTS( SELECT NULL
			   FROM Segments
			   WHERE SegmentName = @UpdatedSegmentName)
	BEGIN
		SET @errorString = N'ERROR: Segment with updated segment name already exists!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	SELECT  @SegmentId  = SegmentId
	FROM    Segments
	WHERE   SegmentName = @OriginalSegmentName
  
	IF (@segmentId IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	UPDATE Segments
	SET    SegmentName = @UpdatedSegmentName
	WHERE  SegmentId   = @SegmentId

	SELECT SegmentName 
	FROM   Segments
	WHERE  SegmentId   = @SegmentId

END