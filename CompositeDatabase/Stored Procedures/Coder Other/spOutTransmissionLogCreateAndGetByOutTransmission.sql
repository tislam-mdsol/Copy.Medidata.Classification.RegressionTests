/*
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of
** this file may not be disclosed to third parties, copied or duplicated in
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
**
**/
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spOutTransmissionLogCreateAndGetByOutTransmission')
	DROP PROCEDURE dbo.spOutTransmissionLogCreateAndGetByOutTransmission
GO

CREATE PROCEDURE dbo.spOutTransmissionLogCreateAndGetByOutTransmission
(
	@outTransmissionId BIGINT,
	@queueId BIGINT
)
AS
BEGIN
	
	-- 1. update the queue items
	UPDATE TransmissionQueueItems
	SET OutTransmissionId = @outTransmissionId
	WHERE TransmissionQueueItemID = @queueId
	
	-- 2. create the log entries
	INSERT INTO OutTransmissionLogs (ObjectId, OutTransmissionID, TransmissionQueueItemId)
	OUTPUT Inserted.*
	SELECT TQI.ObjectID, @outTransmissionId, @queueId
	FROM TransmissionQueueItems TQI
	WHERE TQI.TransmissionQueueItemID = @queueId
		
END

GO
