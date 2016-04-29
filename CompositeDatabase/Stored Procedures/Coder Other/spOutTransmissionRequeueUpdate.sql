IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spOutTransmissionRequeueUpdate')
	DROP PROCEDURE spOutTransmissionRequeueUpdate
GO

CREATE PROCEDURE dbo.spOutTransmissionRequeueUpdate 
(
	@OutTransmissionID BIGINT,

	@Acknowledged BIT,
	@HttpStatusCode INT,
	@WebExceptionStatus VARCHAR(50),
	@ResponseText NVARCHAR(MAX),
	@MaxRetryCount INT,
	@ServiceWillContinueSending BIT OUTPUT,
	@FailureCount INT OUTPUT
)  
AS  
  
BEGIN

	DECLARE @Updated DATETIME  

	SELECT @Updated = GETUTCDATE()  

	BEGIN TRANSACTION
	BEGIN TRY

		-- 1. update the transmissionqueue
		UPDATE TransmissionQueueItems
		SET ServiceWillContinueSending = CASE WHEN FailureCount >= @MaxRetryCount THEN 0 ELSE 1 END,
			@ServiceWillContinueSending = CASE WHEN FailureCount >= @MaxRetryCount THEN 0 ELSE 1 END,
			FailureCount = FailureCount + 1,
			@FailureCount = FailureCount + 1,
			Updated = @Updated
		WHERE OutTransmissionID = @OutTransmissionID

		-- 2. update the outTransmissions
		UPDATE OutTransmissions
		SET
			Acknowledged = @Acknowledged,
			AcknowledgeDate = @Updated,
			TransmissionSuccess = 0,
			HttpStatusCode = @HttpStatusCode,
			WebExceptionStatus = @WebExceptionStatus,
			ResponseText = @ResponseText,
			Updated = @Updated
		 WHERE OutTransmissionID = @OutTransmissionID
	 
		 -- 3. update the outTransmissionLogs
		UPDATE OutTransmissionLogs
		SET
			Succeeded = 0,
			Updated = @Updated
		WHERE OutTransmissionID = @OutTransmissionID 

		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
			
			ROLLBACK TRANSACTION

			DECLARE	@ErrorSeverity INT, 
					@ErrorState INT,
					@ErrorLine INT,
					@ErrorMessage NVARCHAR(4000),
					@ErrorProc NVARCHAR(4000)	
			
			SELECT @ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE(),
					@ErrorLine = ERROR_LINE(),
					@ErrorMessage = ERROR_MESSAGE(),
					@ErrorProc = ERROR_PROCEDURE()
			SELECT @ErrorMessage = COALESCE(@ErrorProc, 'spOutTransmissionRequeueUpdate.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
			
			RAISERROR(@ErrorMessage, 16, 1)
	
	END CATCH

END

GO  

 