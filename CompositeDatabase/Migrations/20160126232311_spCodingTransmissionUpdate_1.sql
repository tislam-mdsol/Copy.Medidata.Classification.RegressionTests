if exists (select * from sysobjects where id = object_id(N'dbo.spCodingTransmissionUpdate') and objectproperty(id, N'IsProcedure') = 1)
    drop procedure dbo.spCodingTransmissionUpdate
go

Create Procedure dbo.spCodingTransmissionUpdate (
 @CodingTransmissionID bigint,
 @CodingSourceTermID bigint,
 @CodingRequestId bigint,
 @TransmissionDate datetime,
 @TransmissionSuccess bit,
 @Acknowledged bit,
 @AcknowledgeDate datetime,
 @Updated datetime output  
)
AS
begin

DECLARE @UtcDate DateTime  
SET @UtcDate = GetUtcDate()  
SELECT @Updated = @UtcDate  

UPDATE CodingTransmissions SET
	CodingSourceTermID = @CodingSourceTermID,
	CodingRequestId = CodingRequestId,
	TransmissionDate = @TransmissionDate,
	TransmissionSuccess = @TransmissionSuccess,
	Acknowledged = @Acknowledged,
	AcknowledgeDate = @AcknowledgeDate,
	Updated = @Updated
WHERE CodingTransmissionID = @CodingTransmissionID

end
Go