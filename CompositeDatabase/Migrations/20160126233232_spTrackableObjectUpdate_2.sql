IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTrackableObjectUpdate')
	DROP PROCEDURE dbo.spTrackableObjectUpdate
GO

CREATE PROCEDURE dbo.spTrackableObjectUpdate (
	@TrackableObjectID bigint,
	@ExternalObjectTypeId bigint,
	@ExternalObjectId nvarchar(50),
	@ExternalObjectOID varchar(50),
	@ExternalObjectName nvarchar(2000),
	@ProtocolName nvarchar(2000),
	@Updated datetime output,
	@ExternalObjectNameId int,
	@TaskCounter bigint,
	@IsTestStudy bit,
	@StudyProjectID INT,
	@SourceUpdatedAt DATETIME,
	@SegmentId int
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SET @Updated = @UtcDate

	UPDATE dbo.TrackableObjects SET
		ExternalObjectTypeId = @ExternalObjectTypeId,
		ExternalObjectId = @ExternalObjectId,
		ExternalObjectOID = @ExternalObjectOID,
		ExternalObjectName = @ExternalObjectName,
		ProtocolName = @ProtocolName,
		SegmentId = @SegmentId,
		Updated = @UtcDate,
		ExternalObjectNameId = @ExternalObjectNameId,
		SourceUpdatedAt = @SourceUpdatedAt,
		--TaskCounter = @TaskCounter,
		IsTestStudy = @IsTestStudy,
		StudyProjectID = @StudyProjectID
	WHERE TrackableObjectID = @TrackableObjectID
END

GO
