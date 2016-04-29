IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spPsOutQueueThroughputForTwoWeeksByHour]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spPsOutQueueThroughputForTwoWeeksByHour]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spPsOutQueueThroughputForTwoWeeksByHour]
AS 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE @from DATE = DATEADD(DAY , -14 , GETDATE())
       ,@through DATE = DATEADD(hour , 1 , GETDATE()) ;
   
    WITH    digits
              AS ( SELECT   0 d
                   UNION ALL
                   SELECT   1
                   UNION ALL
                   SELECT   2
                   UNION ALL
                   SELECT   3
                   UNION ALL
                   SELECT   4
                   UNION ALL
                   SELECT   5
                   UNION ALL
                   SELECT   6
                   UNION ALL
                   SELECT   7
                   UNION ALL
                   SELECT   8
                   UNION ALL
                   SELECT   9
                 ),
            numbers
              AS ( SELECT   a.d + b.d * 10 + c.d * 100 + e.d * 1000 + f.d
                            * 10000 n
                   FROM     digits a
                           ,digits b
                           ,digits c
                           ,digits e
                           ,digits f
                 ),
            datesAndHours
              AS ( SELECT   CAST(DATEADD(hh , n , CAST(@from AS DATETIME)) AS DATE) [date]
                           ,n % 24 [hour]
                   FROM     numbers
                   WHERE    n < DATEDIFF(hh , @from , @through)
                 ),
            completed
              AS ( SELECT   COUNT(1) completedCount
                           ,CAST(t.Updated AS DATE) [date]
                           ,DATEPART(hh , t.Updated) [hour]
                   FROM     dbo.TransmissionQueueItems t
                   WHERE    t.Updated BETWEEN @from AND @through
                            AND ( t.FailureCount = 6
                                  OR t.SuccessCount = 1
                                )
                            AND t.IsForUnloadService = 0
                   GROUP BY CAST(t.UPDATEd AS DATE)
                           ,DATEPART(hh , t.Updated)
                 ),
            failed
              AS ( SELECT   COUNT(1) * 6 minFailureCount
                           ,CAST(t.Updated AS DATE) [date]
                           ,DATEPART(hh , t.Updated) [hour]
                   FROM     dbo.TransmissionQueueItems t
                   WHERE    t.Updated BETWEEN @from AND @through
                            AND ( t.FailureCount = 6 )
                   GROUP BY CAST(t.UPDATEd AS DATE)
                           ,DATEPART(hh , t.Updated)
                 ),
            succeeded
              AS ( SELECT   COUNT(1) successCount
                           ,CAST(t.Updated AS DATE) [date]
                           ,DATEPART(hh , t.Updated) [hour]
                   FROM     dbo.TransmissionQueueItems t
                   WHERE    t.Updated BETWEEN @from AND @through
                            AND ( t.SuccessCount = 1 )
                   GROUP BY CAST(t.UPDATEd AS DATE)
                           ,DATEPART(hh , t.Updated)
                 ),
            added
              AS ( SELECT   COUNT(1) CreatedCount
                           ,CAST(Created AS DATE) [date]
                           ,DATEPART(hh , t.Created) [hour]
                   FROM     dbo.TransmissionQueueItems t
                   WHERE    Created BETWEEN @from AND @through
                   GROUP BY CAST(Created AS DATE)
                           ,DATEPART(hh , t.Created)
                 ),
            pending
              AS ( SELECT   COUNT(1) pendingCount
                           ,CAST(t.updated AS DATE) [date]
                           ,DATEPART(hh , t.updated) [hour]
                   FROM     dbo.TransmissionQueueItems t
                            LEFT JOIN dbo.OutTransmissions ot ON t.OutTransmissionID = ot.OutTransmissionID
                   WHERE    t.updated > DATEADD(month , -6 , @through)
                            AND ( t.FailureCount = 0
                                  OR ( t.ServiceWillContinueSending = 1 )
                                )
                            AND t.SuccessCount = 0
                            AND t.IsForUnloadService = 0
                            AND ot.OutTransmissionID IS NULL
                   GROUP BY CAST(t.updated AS DATE)
                           ,DATEPART(hh , t.updated)
                 ),
            totalPendingEnteredOnThisDate
              AS ( SELECT   SUM(COALESCE(p2.pendingCount , 0)) pendingCount
                           ,dh.date
                           ,dh.hour
                   FROM     datesAndHours dh
                            LEFT JOIN pending p2 ON DATEADD(hh , p2.hour ,
                                                            CAST(p2.date AS DATETIME)) < DATEADD(hh ,
                                                              dh.hour ,
                                                              CAST(dh.date AS DATETIME))
                                                    AND p2.date BETWEEN DATEADD(month ,
                                                              -6 , @through)
                                                              AND
                                                              @through
                   GROUP BY dh.date
                           ,dh.hour
                 ),
            everything
              AS ( SELECT   DATEADD(hh , dh.HOUR , CAST(dh.date AS DATETIME)) date
                           ,COALESCE(a.CreatedCount , 0) CreatedCount
                           ,COALESCE(c.completedCount , 0) CompletedCount
                           ,COALESCE(s.successCount , 0) SucceededCount
                           ,COALESCE(f.minFailureCount , 0) MinFailureCount
                           ,COALESCE(p.pendingCount , 0) TotalPendingCount
                   FROM     datesAndHours dh
                            LEFT JOIN added a ON dh.date = a.date
                                                 AND dh.hour = a.hour
                            LEFT  JOIN completed c ON dh.date = c.date
                                                      AND dh.hour = c.hour
                            LEFT JOIN succeeded s ON dh.date = s.date
                                                     AND dh.hour = s.hour
                            LEFT JOIN failed f ON dh.date = f.date
                                                  AND dh.hour = f.hour
                            LEFT JOIN totalPendingEnteredOnThisDate p ON dh.date = p.date
                                                              AND dh.hour = p.hour
                 )
        SELECT  date 'Date'
               ,CreatedCount 'Created Count'
               ,CompletedCount 'Completed Count'
               ,SucceededCount 'Succeeded Count'
               ,MinFailureCount 'Minimum Failure Count'
               ,TotalPendingCount 'Total Items Pending'
        FROM    everything
        ORDER BY 1 DESC
         
GO


