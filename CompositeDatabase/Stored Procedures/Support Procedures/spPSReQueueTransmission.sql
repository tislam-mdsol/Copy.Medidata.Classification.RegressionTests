IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSReQueueTransmission')
	DROP PROCEDURE dbo.spPSReQueueTransmission
GO

CREATE PROCEDURE [dbo].[spPSReQueueTransmission]

	@TransmissionQueueItemID BIGINT

AS
BEGIN

	UPDATE TransmissionQueueItems
	SET CumulativeFailCount = CumulativeFailCount + FailureCount, 
		FailureCount = 0,  
		ServiceWillContinueSending = 1
	WHERE TransmissionQueueItemID = @TransmissionQueueItemID
 
END
GO
