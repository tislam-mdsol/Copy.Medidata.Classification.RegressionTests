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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTransmissionQueueResendSelected')
	BEGIN
		DROP Procedure spTransmissionQueueResendSelected
	END
GO	


CREATE procedure [dbo].spTransmissionQueueResendSelected
(
	@FieldIds VARCHAR(max),
	@AgingPeriod INT	-- Use -1 for ALL
)
AS
BEGIN

--------------
-- example fieldId strings
	-- SET @FieldIds = '10,30,293,409,10,30,304,0,28,59,427,0' 
	--'10,30,293,409'   --'3,17,0,0'  -- '3,11,407,0,3,11,408,0'
--------------

	-- setup date selection
	DECLARE @StartDate DATETIME, @EndDate DATETIME  
	DECLARE @TodayStart DATE = CAST(GETUTCDATE() AS DATE)  
	DECLARE @Last7DaysStart DATE = DATEADD(DAY, -7, @TodayStart)  
	DECLARE @Last30DaysStart DATE = DATEADD(DAY, -30, @TodayStart)   
	DECLARE @MinDate DATE = CAST('17530101' AS DATETIME)  
	IF(@AgingPeriod = 1) BEGIN  -- Today  
		SELECT @StartDate = @TodayStart, @EndDate = @TodayStart  
	END  
	ELSE IF(@AgingPeriod = 2) BEGIN --InTheLast7Days  
		SELECT @StartDate = @Last7DaysStart, @EndDate = @TodayStart  
	END  
	ELSE IF(@AgingPeriod = 3) BEGIN --OlderThan7Days  
		SELECT @StartDate = @MinDate, @EndDate = @Last7DaysStart  
	END  
	ELSE IF(@AgingPeriod = 4) BEGIN --OlderThan30Days  
		SELECT @StartDate = @MinDate, @EndDate = @Last30DaysStart  
	END  
	
	------ create selection row CTE
	DECLARE @tempTable TABLE(ParsingOrder INT IDENTITY(1,1), Item BIGINT)	

	INSERT INTO @tempTable
	SELECT CAST(item AS BIGINT)
	FROM dbo.fnSplit(@FieldIds, ',')

	;WITH CTE (SourceID, SegmentID, TrackObjID, HttpCode) 
	AS
	( 
		SELECT TI.Item,	X1.SegmentID, X2.TrackObjID, X3.HttpCode
		FROM @tempTable TI
			CROSS APPLY
				(SELECT SegmentID = Item
				FROM @tempTable
				WHERE TI.ParsingOrder = ParsingOrder - 1)
				AS X1
			CROSS APPLY
				(SELECT TrackObjID = Item
				FROM @tempTable
				WHERE TI.ParsingOrder = ParsingOrder - 2)
				AS X2
			CROSS APPLY
				(SELECT HttpCode = Item
				FROM @tempTable
				WHERE TI.ParsingOrder = ParsingOrder - 3)
				AS X3									
		WHERE TI.ParsingOrder % 4 = 1
	)

    --------------
 
  
	UPDATE TransmissionQueueItems
	SET CumulativeFailCount = CumulativeFailCount + FailureCount, 
		FailureCount = 0,  
		ServiceWillContinueSending = 1
	WHERE TransmissionQueueItemID IN (
		SELECT TransmissionQueueItemID FROM TransmissionQueueItems Q  
			LEFT JOIN TrackableObjects T ON T.ExternalObjectId = Q.StudyOID 
			LEFT JOIN OutTransmissions O ON O.OutTransmissionID = Q.OutTransmissionID
			INNER JOIN CTE ON CTE.SourceID = Q.SourceSystemID 
				AND CTE.SegmentID = Q.SegmentID 
				-- zero is sent from the grid for NULL on TrackObjID and HttpCode
				AND (CTE.TrackObjID = T.TrackableObjectID OR 
					(CTE.TrackObjID = 0 AND T.TrackableObjectID IS NULL))
				AND (CTE.HttpCode = HttpStatusCode OR
					(CTE.HttpCode = 0 AND HttpStatusCode IS NULL))
		WHERE Q.SuccessCount = 0  
				AND Q.ServiceWillContinueSending = 0 
				AND Q.IsForUnloadService = 0
				AND (@AgingPeriod = -1 OR Q.Created BETWEEN @StartDate AND @EndDate)
		)


END
  
  