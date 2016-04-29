IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingRejectionUpdate')
	DROP PROCEDURE dbo.spCodingRejectionUpdate
GO

CREATE PROCEDURE dbo.spCodingRejectionUpdate (
 @CodingRejectionID bigint,
 @CodingElementID bigint,
 @UserID int,
 @Comment nvarchar(4000),
 @Updated datetime output,
 @SegmentID int
)
AS

BEGIN
 DECLARE @UtcDate DateTime
 SET @UtcDate = GetUtcDate()
 SET @Updated = @UtcDate

 UPDATE dbo.CodingRejections SET
  CodingElementID = @CodingElementID,
  SegmentId = @SegmentId,
  UserID = @UserID,
  Comment = @Comment,
  Updated = @UtcDate
 WHERE CodingRejectionID = @CodingRejectionID
END

GO
