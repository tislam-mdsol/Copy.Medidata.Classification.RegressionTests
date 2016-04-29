IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spTransmissionQueueItemUpdate')
	DROP PROCEDURE dbo.spTransmissionQueueItemUpdate
GO

CREATE PROCEDURE dbo.spTransmissionQueueItemUpdate (
	@TransmissionQueueItemID bigint,
	@ObjectTypeID int,
	@ObjectID bigint,
	@StudyOID varchar(50),
	@FailureCount int,
	@SuccessCount int,
	--@LastFailedTransmissionDate datetime,
	--@LastSuccessfulTransmissionDate datetime,
	@SourceSystemID int,
	--@HttpStatusCode int,
	--@WebExceptionStatus varchar(50),
	--@ResponseText varchar(max),
	@CumulativeFailCount int,
	@OutTransmissionID BIGINT,
	@ServiceWillContinueSending BIT,
	@IsForUnloadService BIT,
	--@Created datetime,
	@Updated datetime output
)
AS

BEGIN
	SET @Updated = GetUtcDate()

UPDATE dbo.TransmissionQueueItems SET
	ObjectTypeID = @ObjectTypeID,
	ObjectID = @ObjectID,
	StudyOID = @StudyOID,
	FailureCount = @FailureCount,
	SuccessCount = @SuccessCount,
	--LastFailedTransmissionDate = @LastFailedTransmissionDate,
	--LastSuccessfulTransmissionDate = @LastSuccessfulTransmissionDate,
	SourceSystemID = @SourceSystemID,
	--HttpStatusCode = @HttpStatusCode,
	--WebExceptionStatus = @WebExceptionStatus,
	--ResponseText = @ResponseText,
	CumulativeFailCount = @CumulativeFailCount,
	OutTransmissionID = @OutTransmissionID,
	ServiceWillContinueSending = @ServiceWillContinueSending,
	IsForUnloadService = @IsForUnloadService,
	--Created = @Created,
	Updated = @Updated
WHERE TransmissionQueueItemID = @TransmissionQueueItemID

END

GO

