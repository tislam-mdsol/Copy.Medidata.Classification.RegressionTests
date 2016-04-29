
/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Dan Dapper ddapper@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

/*
// UUIDs that are not found, or do not have current coding assignments, or no existing transmission queue item, will be reported, but it is not an error..
// Script requeues all transmissions, not only those that had failed.
// Call CMP_ReportTransmissionQueueItemsByUUID with same parameters to get listing of results.
*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CMP_ResendTransmissionQueueItemsByUUID') 
			AND type in (N'P', N'PC'))
	drop proc CMP_ResendTransmissionQueueItemsByUUID
go
  
  ---------------------------------------------------------
CREATE PROCEDURE [dbo].CMP_ResendTransmissionQueueItemsByUUID  
(  
 @SegmentName VARCHAR(250),  
 @CommaDelimitedUUIDs NVARCHAR(MAX)  
)  
  
AS  
BEGIN  
   
 DECLARE @SegmentID INT, @errorString NVARCHAR(MAX)  
 DECLARE @UUIDs TABLE (UUID NVARCHAR(100) PRIMARY KEY, SegmentId int, CodingElementId int, CodingAssigmentId int, TransmissionQueueItemId int)  
 DECLARE @TransmissionQueueItemID TABLE (UUID NVARCHAR(100) PRIMARY KEY, SegmentId int, CodingElementId int, CodingAssigmentId int, TransmissionQueueItemId int)  
  
   
 SELECT @SegmentId = SegmentId  
 FROM Segments  
 WHERE SegmentName = @SegmentName  
   
 IF (@SegmentId IS NULL)  
 BEGIN  
  SET @errorString = N'ERROR: Segment not found!'  
  RAISERROR(@errorString, 16, 1)  
  RETURN 1  
 END  
  
 INSERT INTO @UUIDs (UUID, SegmentId)  
 SELECT *, -1 
 FROM dbo.fnParseDelimitedString(@CommaDelimitedUUIDs, ',')  
 
  
  --Find TransmissionQueueItemID where exists
  INSERT INTO @TransmissionQueueItemID (UUID, SegmentId, CodingElementID, CodingAssigmentId, TransmissionQueueItemID)  
  select U.UUID, CE.SegmentId, ce.CodingElementID, 
		 max(coalesce(dt.CodingAssignmentID,0)) CodingAssignmentID, 
		 max(coalesce(dt.TransmissionQueueItemID,0)) TransmissionQueueItemID
  FROM @UUIDs U  
  JOIN CodingElements CE ON U.UUID = CE.UUID and CE.SegmentId = @SegmentId  
  Left JOIN (	select ca.CodingElementID, CA.CodingAssignmentID,TQI.TransmissionQueueItemID
				from CodingAssignment CA 
				left JOIN TransmissionQueueItems TQI on TQI.ObjectId = CA.CodingAssignmentID AND TQI.ObjectTypeID = 2251) dt
				ON dt.CodingElementID = CE.CodingElementId --AND CA.Active = 1  
  group by U.UUID, CE.SegmentId, ce.CodingElementID
  
  --temp print
  --select * from @TransmissionQueueItemID
  --where TransmissionQueueItemID >0
  
  --update @UUIDs table 
 UPDATE @UUIDs  
 SET  SegmentId = CE.SegmentId,  
	  CodingElementId = CE.CodingElementId,  
	  CodingAssigmentId = CA.CodingAssignmentId,  
	  TransmissionQueueItemId = TQ.TransmissionQueueItemID  
 FROM @UUIDs U  
  JOIN CodingElements CE ON U.UUID = CE.UUID --and CE.SegmentId = @SegmentId  
  LEFT JOIN CodingAssignment CA ON CA.CodingElementID = CE.CodingElementId 
											AND CA.Active = 1  
  left Join @TransmissionQueueItemID TQ on TQ.UUID = CE.UUID and TQ.SegmentId = @SegmentId 
				and CE.CodingElementID = TQ.CodingElementId
 										

 IF EXISTS (SELECT NULL FROM @UUIDs WHERE SegmentID = -1)  
 BEGIN  
  SELECT 'Coding element not found' Note, UUID   
  FROM @UUIDs   
  WHERE SegmentID = -1  
    
  
 END  
  
 -- No active Coding Assignment?  
  
 IF EXISTS (SELECT * FROM @UUIDs WHERE coalesce(CodingAssigmentId,0) =0)  
  BEGIN  
  SELECT 'No active Coding Assignment' Note, UUID  
  FROM @UUIDs   
  WHERE coalesce(CodingAssigmentId,0) =0 
   
  END  
  
 -- No Transmisssion Queue Item?  
  
 IF EXISTS (SELECT * FROM @UUIDs WHERE coalesce(TransmissionQueueItemId,0)=0  )  
  BEGIN  
  SELECT 'No transmission queue item' Note, UUID  
  FROM @UUIDs   
  WHERE coalesce(TransmissionQueueItemId,0)=0  
  
  DELETE @UUIDs  
  WHERE coalesce(TransmissionQueueItemId,0)=0   
  END  
  
  -- delete the rest before real update for re-transmission
  DELETE @UUIDs WHERE SegmentID = -1 
     
  DELETE @UUIDs  
  WHERE coalesce(CodingAssigmentId,0) =0
  
 
 -- Requeue for transmission  
  
 UPDATE   TQI  
 SET  CumulativeFailCount = TQI.CumulativeFailCount + TQI.FailureCount,   
		FailureCount = 0,    
		SuccessCount = 0,  
		ServiceWillContinueSending = 1  
 FROM TransmissionQueueItems TQI  
 JOIN @UUIDs U on U.TransmissionQueueItemId = TQI.TransmissionQueueItemID   
  
END  
go
