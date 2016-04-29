IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spOutTransmissionLogUpdate')
	DROP PROCEDURE spOutTransmissionLogUpdate
GO

CREATE PROCEDURE dbo.spOutTransmissionLogUpdate 
(
	@OutTransmissionLogID INT,
	@ObjectId BIGINT,
	@OutTransmissionID BIGINT,
	@TransmissionQueueItemId BIGINT,
	@Succeeded BIT,
	@ResponseVerificationCode VARCHAR(100),
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE OutTransmissionLogs
	SET
		ObjectId = @ObjectId,
		OutTransmissionID = @OutTransmissionID,
		TransmissionQueueItemId = @TransmissionQueueItemId,
		Succeeded = @Succeeded,
		ResponseVerificationCode = @ResponseVerificationCode,
		Updated = @Updated
	 WHERE OutTransmissionLogID = @OutTransmissionLogID

END

GO  