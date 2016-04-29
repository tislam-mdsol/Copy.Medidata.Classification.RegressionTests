
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spTransmissionQueueItemGetBySourceTransmissionType')
	DROP PROCEDURE dbo.spTransmissionQueueItemGetBySourceTransmissionType
GO

CREATE PROCEDURE [dbo].[spTransmissionQueueItemGetBySourceTransmissionType]
(
	@sourceSystemId BIGINT, 
	@transmissionTypeId BIGINT, 
	@pageSize INT,
	@lastFailureTimeFloor DATETIME
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT top(@pageSize) 
		TQI.* 
	FROM dbo.TransmissionQueueItems TQI
		LEFT JOIN OutTransmissions OT
			ON OT.OutTransmissionID = TQI.OutTransmissionID
			AND OT.TransmissionDate >= @lastFailureTimeFloor -- only join recent transmissions
			AND TQI.SuccessCount = 0
			AND (TQI.FailureCount = 0 OR TQI.ServiceWillContinueSending = 1)
	WHERE (TQI.FailureCount = 0 OR TQI.ServiceWillContinueSending = 1)
		AND @sourceSystemId = TQI.SourceSystemID
		AND @transmissionTypeId = TQI.ObjectTypeID
		AND TQI.SuccessCount = 0
		AND IsForUnloadService = 0  -- not for polling service
		AND OT.OutTransmissionID IS NULL  -- no recent transmission attempts
	ORDER BY TQI.TransmissionQueueItemID ASC
   
		
END

GO

 
