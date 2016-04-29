/*
** Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of
** this file may not be disclosed to third parties, copied or duplicated in
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Bonnie Pan bpan@mdsol.com
**
**/
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spScheduleKeyForPendingMessages')
	DROP PROCEDURE dbo.spScheduleKeyForPendingMessages
GO

CREATE PROCEDURE dbo.spScheduleKeyForPendingMessages(
   @MessageTypeIDToExclude INT
)
AS
BEGIN

	SELECT SourceSystemId,ObjectTypeID 
	FROM TransmissionQueueItems TQI
	WHERE (TQI.FailureCount = 0 OR TQI.ServiceWillContinueSending = 1)
		AND TQI.SuccessCount = 0
		AND IsForUnloadService = 0  -- not for polling service
		AND ObjectTypeID <> @MessageTypeIDToExclude

	GROUP BY SourceSystemId, ObjectTypeID
END

GO
