IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spOutTransmissionUpdate')
	DROP PROCEDURE spOutTransmissionUpdate
GO

CREATE PROCEDURE dbo.spOutTransmissionUpdate 
(
	@OutTransmissionID INT,
	@SourceSystemID INT,
	@TransmissionTypeID INT,
	
	@Acknowledged BIT,
	@AcknowledgeDate DATETIME,
	@TransmissionSuccess BIT,
	@TransmissionDate DATETIME,
	
	@HttpStatusCode INT,
	@WebExceptionStatus VARCHAR(50),
	@TextToTransmit NVARCHAR(MAX), -- compressed?
	@ResponseText NVARCHAR(MAX), -- compressed?

	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE OutTransmissions
	SET
		SourceSystemID = @SourceSystemID,
		TransmissionTypeID = @TransmissionTypeID,
		
		Acknowledged = @Acknowledged,
		AcknowledgeDate = @AcknowledgeDate,
		TransmissionSuccess = @TransmissionSuccess,
		TransmissionDate = @TransmissionDate,
		
		HttpStatusCode = @HttpStatusCode,
		WebExceptionStatus = @WebExceptionStatus,
		TextToTransmit = @TextToTransmit,
		ResponseText = @ResponseText,

		Updated = @Updated
	 WHERE OutTransmissionID = @OutTransmissionID

END

GO  