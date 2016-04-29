IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spPsOutQueueHealthBySegment]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spPsOutQueueHealthBySegment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spPsOutQueueHealthBySegment]
AS 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT  s.SegmentName
           ,s.SegmentId
           ,COUNT(tqi.TransmissionQueueItemID) 'Outqueue Item Count'
           ,SUM(ISNULL(tqi.FailureCount , 0)) 'Failure Count'
           ,MIN(ISNULL(tqi.Created , GETDATE())) 'Earliest Created Term'
           ,DATEDIFF(HOUR , MIN(ISNULL(tqi.Created , GETDATE())) , GETDATE()) 'Oldest Age In Hours'
           ,AVG(DATEDIFF(HOUR , ISNULL(tqi.Created , GETDATE()) , GETDATE())) 'Average Age In Hours'
           ,ISNULL(ot.ObjectTypeName , '') 'Message Type'
    FROM    Segments s
            LEFT JOIN dbo.TransmissionQueueItems TQI ON TQI.SegmentID = s.SegmentId
            LEFT JOIN dbo.ObjectTypeR ot ON tqi.ObjectTypeID = ot.ObjectTypeID
    WHERE   tqi.TransmissionQueueItemID IS NULL
            OR ( ( TQI.FailureCount = 0
                   OR ( TQI.ServiceWillContinueSending = 1 )
                 )
                 AND TQI.SuccessCount = 0
                 AND IsForUnloadService = 0
               )
    GROUP BY s.SegmentId
           ,s.SegmentName
           ,ISNULL(ot.ObjectTypeName , '')
    ORDER BY 6 DESC
           ,3 DESC
           ,8
GO