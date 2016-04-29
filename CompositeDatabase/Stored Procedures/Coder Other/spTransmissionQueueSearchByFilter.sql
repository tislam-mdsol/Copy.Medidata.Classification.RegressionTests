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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTransmissionQueueSearchByFilter')
	BEGIN
		DROP Procedure spTransmissionQueueSearchByFilter
	END
GO	


CREATE procedure [dbo].spTransmissionQueueSearchByFilter
(
	@SourceSystemID BIGINT,		-- Use -1 for ALL
	@SegmentID BIGINT,			-- Use -1 for ALL
	@TrackableObjectID BIGINT,  -- Use -1 for ALL
	@HttpStatus INT,			-- Use -1 for ALL
	@AgingPeriod INT,			-- Use -1 for ALL
	@pageSize INT,  
	@pageIndex INT
)
AS
BEGIN
	
	SET NOCOUNT ON


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
	DECLARE @startRowNumber BIGINT, @endRowNumber INT  
	SET @startRowNumber = (@PageIndex * @PageSize) + 1  
	SET @endRowNumber = @startRowNumber + @PageSize - 1  
  
	;WITH searchQueryCTE (  
		  SourceName, SourceSystemID, SegmentName, SegmentId, StudyName, TrackableObjectID, HttpStatus, 
		  Count, RowNumber 
		) 
	AS
	(  
		SELECT A.Name, A.SourceSystemID, S.SegmentName, S.SegmentId, 
			T.ExternalObjectName, T.TrackableObjectID, O.HttpStatusCode,
			COUNT(*), ROW_NUMBER() OVER(ORDER BY A.Name)
		FROM TransmissionQueueItems Q  
			INNER JOIN Application A ON A.SourceSystemID = Q.SourceSystemID 
			INNER JOIN Segments S ON S.SegmentId = Q.SegmentID
			LEFT JOIN TrackableObjects T ON T.ExternalObjectId = Q.StudyOID 
			LEFT JOIN OutTransmissions O ON O.OutTransmissionID = Q.OutTransmissionID
		WHERE Q.SuccessCount = 0  
			AND Q.ServiceWillContinueSending = 0 
			AND Q.IsForUnloadService = 0
			AND (@AgingPeriod = -1 OR Q.Created BETWEEN @StartDate AND @EndDate)
			AND (@SourceSystemID = -1 OR Q.SourceSystemID = @SourceSystemID)
			AND (@SegmentID = -1 OR Q.SegmentID = @SegmentID)
			AND (@TrackableObjectID = -1 OR T.TrackableObjectID = @TrackableObjectID)
			AND (@HttpStatus = -1 OR O.HttpStatusCode = @HttpStatus)
		GROUP BY A.Name, A.SourceSystemID, S.SegmentName, S.SegmentId, 
				 T.ExternalObjectName, T.TrackableObjectID, O.HttpStatusCode
	)  
 
	SELECT  
		  SourceName, SourceSystemID, SegmentName, SegmentId, StudyName, TrackableObjectID, HttpStatus, 
		  Count, RowNumber, 
		  (SELECT COUNT(*) FROM searchQueryCTE) AS TotalRowCount
	FROM searchQueryCTE  
	WHERE RowNumber BETWEEN @startRowNumber AND @endRowNumber  
  

END
  
 