/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTransmissionQueueGetFilterValues')
	BEGIN
		DROP Procedure spTransmissionQueueGetFilterValues
	END
GO	


CREATE procedure [dbo].spTransmissionQueueGetFilterValues
AS
BEGIN
	
	SET NOCOUNT ON


	;WITH ResendTransmissionCTE 
		(SourceSystemID, SegmentID, StudyOID, HttpStatusCode)
	AS
	(
	SELECT 
		TQ.SourceSystemID, SegmentID, StudyOID, HttpStatusCode
	FROM TransmissionQueueItems TQ
		LEFT JOIN OutTransmissions OT ON OT.OutTransmissionID = TQ.OutTransmissionID
	WHERE TQ.SuccessCount = 0 
			AND TQ.ServiceWillContinueSending = 0 
			AND TQ.IsForUnloadService = 0
	)
	

  SELECT GridColumn, ID, Name
  FROM
	(
	SELECT 'SourceSystem' AS GridColumn, Src_Internal.SourceSystemID AS ID, A.Name AS Name
	FROM
	(
		SELECT DISTINCT(SourceSystemID)
		FROM ResendTransmissionCTE
	) AS Src_Internal
		JOIN Application A ON A.SourceSystemID = Src_Internal.SourceSystemID
	UNION
	SELECT 'Segment' AS GridColumn, Seg_Internal.SegmentID AS ID, S.SegmentName AS Name
	FROM
	(
		SELECT DISTINCT(SegmentID)
		FROM ResendTransmissionCTE
	) AS Seg_Internal
		JOIN Segments S ON S.SegmentId = Seg_Internal.SegmentID
	UNION
	SELECT 'Study' AS GridColumn, TrackableObjectID AS ID, ExternalObjectName AS Name
	FROM
	(	
		SELECT DISTINCT(StudyOID)
		FROM ResendTransmissionCTE
	) AS Study_Internal
		LEFT JOIN TrackableObjects T ON T.ExternalObjectId = Study_Internal.StudyOID
	UNION
	SELECT 'HttpStatus' AS GridColumn, HttpStatusCode AS ID, CAST(HttpStatusCode AS NVARCHAR) AS Name
	FROM
	(	
		SELECT DISTINCT(HttpStatusCode)
		FROM ResendTransmissionCTE
	) AS Status_Internal
	) AS Composite
	ORDER BY Composite.GridColumn
		
END
  
 