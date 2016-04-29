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
** Complete history on bottom of file
**/
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spTransmissionQueueItemGetBySourceTransmission')
	DROP PROCEDURE dbo.spTransmissionQueueItemGetBySourceTransmission
GO

CREATE PROCEDURE dbo.spTransmissionQueueItemGetBySourceTransmission
(
	@sourceSystemId BIGINT, 
	@transmissionTypeId BIGINT, 
	@lastFailureTimeFloor DATETIME
)
AS
BEGIN

	--pick up tasks for workflow to process where failure count < max

        SELECT TOP 1
                TQI.*
        FROM    dbo.TransmissionQueueItems TQI
                LEFT JOIN OutTransmissions OT ON OT.OutTransmissionID = TQI.OutTransmissionID
                                                 AND OT.TransmissionDate >= @lastFailureTimeFloor -- only join recent transmissions
                                                 AND TQI.SuccessCount = 0
                                                 AND ( TQI.FailureCount = 0
                                                       OR TQI.ServiceWillContinueSending = 1
                                                     )
                LEFT JOIN TransmissionQueueItemsPriorityStudies w ON TQI.StudyOID = w.StudyOID
                                                              AND TQI.SegmentID = w.SegmentId
        WHERE   ( TQI.FailureCount = 0
                  OR TQI.ServiceWillContinueSending = 1
                )
                AND @sourceSystemId = TQI.SourceSystemID
                AND @transmissionTypeId = TQI.ObjectTypeID
                AND TQI.SuccessCount = 0
                AND IsForUnloadService = 0  -- not for polling service
                AND OT.OutTransmissionID IS NULL  -- no recent transmission attempts
        ORDER BY ISNULL(w.Weight , 0) DESC       -- first by specified study priority
               ,TQI.TransmissionQueueItemID DESC -- next by oldest

		
END

GO