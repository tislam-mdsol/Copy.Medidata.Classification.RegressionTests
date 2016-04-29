IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentUpdate')
	DROP PROCEDURE spObjectSegmentUpdate
GO
CREATE PROCEDURE dbo.spObjectSegmentUpdate
(
	@ObjectSegmentID bigint,
	@ObjectID INT, 
	@ObjectTypeId INT,
	@SegmentId INT,
	@Readonly BIT,
	@DefaultSegment BIT,
	@Deleted BIT,
	@Updated datetime output  
)
AS

BEGIN

	DECLARE @UtcDate Datetime
	SET @UtcDate = GetUtcDate()  
	SELECT  @Updated = @UtcDate  

	UPDATE dbo.ObjectSegments
	SET DefaultSegment = @DefaultSegment,
		Readonly = @Readonly,
		Deleted = @Deleted,
		Updated = @Updated
	WHERE ObjectSegmentID = @ObjectSegmentID

END

