--/** 
--** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
--**
--** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of
--** this file may not be disclosed to third parties, copied or duplicated in
--** any form, in whole or in part, without the prior written permission of
--** Medidata Solutions, Inc.
--**
--** Author: Altin Vardhami avardhami@mdsol.com
--**
--** Complete history on bottom of file
--**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSearchTransmissionQueueItems')
	DROP PROCEDURE dbo.spSearchTransmissionQueueItems
GO

--CREATE PROCEDURE dbo.spSearchTransmissionQueueItems (  
--	 @StudyID BIGINT,  
--	 @AgingPeriod INT,  
--	 @TransmissionType INT,
--	 @SegmentID INT,
--	 @pageSize INT,  
--	 @pageIndex INT,  
--	 @sortExpression NVARCHAR(200)  
--)  
--AS  
--BEGIN

--	DECLARE @StartDate DATETIME, @EndDate DATETIME  
--	DECLARE @TodayStart DATE = CAST(GETUTCDATE() AS DATE)  
--	DECLARE @Last7DaysStart DATE = DATEADD(DAY, -7, @TodayStart)  
--	DECLARE @Last30DaysStart DATE = DATEADD(DAY, -30, @TodayStart)   
--	DECLARE @MinDate DATE = CAST('17530101' AS DATETIME)  

--	IF(@AgingPeriod = 1) BEGIN  -- Today  
--		SELECT @StartDate = @TodayStart, @EndDate = @TodayStart  
--	END  
--	ELSE IF(@AgingPeriod = 2) BEGIN --InTheLast7Days  
--		SELECT @StartDate = @Last7DaysStart, @EndDate = @TodayStart  
--	END  
--	ELSE IF(@AgingPeriod = 3) BEGIN --OlderThan7Days  
--		SELECT @StartDate = @MinDate, @EndDate = @Last7DaysStart  
--	END  
--	ELSE IF(@AgingPeriod = 4) BEGIN --OlderThan30Days  
--		SELECT @StartDate = @MinDate, @EndDate = @Last30DaysStart  
--	END  

--	DECLARE @startRowNumber BIGINT, @endRowNumber INT  
--	SET @startRowNumber = (@PageIndex * @PageSize) + 1  
--	SET @endRowNumber = @startRowNumber + @PageSize - 1  
  
--	;WITH searchQueryCTE (  
--		  Id, SourceSystem,  
--		  Verbatim, ObjectTypeID,  
--		  StudyOID, FailureCount,  
--		  FirstFailedTransmissionDate, LastFailedTransmissionDate,  
--		  HttpStatusCode, WebExceptionStatus, ResponseText,  
--		  RowNumber  
--		) 
--	AS
--	(  
--		SELECT q.TransmissionQueueItemID, s.OID, coalesce(t.Term, e.VerbatimTerm, ''),  
--			q.ObjectTypeID,  
--			q.StudyOID + (CASE WHEN tr.IsTestStudy = 1 THEN '_UAT' ELSE '_PROD' END),  
--			q.FailureCount,  
--			q.Created, --OT.LastFailedTransmissionDate,  
--			OT.TransmissionDate, OT.HttpStatusCode, OT.WebExceptionStatus, OT.ResponseText,  
--			ROW_NUMBER() OVER(ORDER BY q.TransmissionQueueItemID DESC)  
--		FROM TransmissionQueueItems q  
--			JOIN SourceSystems s 
--				ON s.SourceSystemId = q.SourceSystemID 
--				AND q.SegmentID = @SegmentID
--			LEFT JOIN CodingSourceTerms t 
--				ON t.CodingSourceTermId = q.ObjectID 
--				AND q.ObjectTypeID = 2077  
--			LEFT JOIN CodingRejections r 
--				ON r.CodingRejectionID = q.ObjectID 
--				AND q.ObjectTypeID = 2185  
--			LEFT JOIN CodingElements e 
--				ON e.CodingElementId = r.CodingElementID  
--			LEFT JOIN OutTransmissions OT 
--				ON OT.OutTransmissionID = q.OutTransmissionID
--			JOIN TrackableObjects tr 
--				ON tr.ExternalObjectOID = q.StudyOID 
--				AND tr.ExternalObjectTypeId = 1  
--		WHERE q.SuccessCount <= 0 AND  
--			q.ServiceWillContinueSending = 0 AND
--			( -- by study  
--				@StudyID = 0 OR  
--				(@StudyID > 0 AND tr.TrackableObjectID = @StudyID) OR  
--				(@StudyID = -1 AND tr.IsTestStudy = 0) OR  
--				(@StudyID = -2 AND tr.IsTestStudy = 1)  
--			) AND  
--			(@AgingPeriod = 0 OR q.Created BETWEEN @StartDate AND @EndDate) AND  
--			(@TransmissionType = 0 OR (@TransmissionType = q.ObjectTypeID))  
--	)  
 
--	SELECT  
--		Id AS TransmissionQueueItemID, SourceSystem,  
--		Verbatim, ObjectTypeID,  
--		StudyOID, FailureCount,  
--		FirstFailedTransmissionDate, LastFailedTransmissionDate,  
--		HttpStatusCode, WebExceptionStatus, ResponseText,  
--		(SELECT COUNT(*) FROM searchQueryCTE) AS TotalRowCount  
--	FROM searchQueryCTE  
--	WHERE RowNumber BETWEEN @startRowNumber AND @endRowNumber  
  
--END  

--GO

 