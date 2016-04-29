 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Connor Ross cross@mdsol.com
// ------------------------------------------------------------------------------------------------------*/


IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSRaveTransmissionQueueInformationById')
DROP PROCEDURE dbo.spPSRaveTransmissionQueueInformationById
GO

CREATE PROCEDURE [dbo].[spPSRaveTransmissionQueueInformationById]

@CommaDelimitedTransmissionQueueItemIds as NVARCHAR(MAX)

AS
BEGIN

	DECLARE @TransmissionQueueItemIds TABLE (TransmissionQueueItemId BIGINT PRIMARY KEY)
	INSERT INTO @TransmissionQueueItemIds(TransmissionQueueItemId)
	SELECT * FROM dbo.fnParseDelimitedString(@CommaDelimitedTransmissionQueueItemIds,',')

	SELECT TQ.*, OT.*, AP.*, STUDY.* 
	FROM TransmissionQueueItems TQ 
		INNER JOIN Application AP ON AP.SourceSystemID = TQ.SourceSystemID 
		INNER JOIN TrackableObjects STUDY ON STUDY.ExternalObjectId = TQ.StudyOID 
		LEFT JOIN OutTransmissions OT ON TQ.OutTransmissionID = OT.OutTransmissionID 
	WHERE TQ.TransmissionQueueItemID in (SELECT TransmissionQueueItemId FROM @TransmissionQueueItemIds)
 
END
GO