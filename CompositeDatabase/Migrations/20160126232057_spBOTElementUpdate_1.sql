IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spBOTElementUpdate')
	DROP PROCEDURE dbo.spBOTElementUpdate
GO

CREATE PROCEDURE dbo.spBOTElementUpdate
(
	@BOTElementID INT,
    @SegmentId INT,
    @UserId INT,
    @SegmentedCodingPatternId BIGINT,
    @IsForwardBOT BIT,
    @CommentReason NVARCHAR(500),
    @BotLog VARCHAR(500),
	@Updated DATETIME OUTPUT
)
AS
BEGIN

	SELECT @Updated = GETUTCDATE()  

	UPDATE BOTElements
	SET
		CommentReason = @CommentReason,
		BotLog = @BotLog,
		Updated = @Updated
	 WHERE BOTElementID = @BOTElementID
	
END
GO
 