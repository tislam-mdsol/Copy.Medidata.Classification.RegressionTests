IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spTransmissionQueueItemLoadSourceTransmissions]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spTransmissionQueueItemLoadSourceTransmissions]
GO

CREATE PROCEDURE [dbo].[spTransmissionQueueItemLoadSourceTransmissions]
    (
     @lastFailureTimeFloor DATETIME
    ,@maxItems INT
    )
AS -- using one standard deviation from the mean transmission time in last 3 hours to 
-- calculate how many tasks we are likely to be able to process in the specified
-- cycle time.... 
--
-- if there is no data available fall back to sending a small set of items in 
-- order to get a rough sample to calculate estimated throuput for next cycle.  
-- Getting a big enough sample to be statistically significant on the first hit 
-- is risky because all selected tasks could be slow.  Prefer
-- to err on the side of taking more time for a single segment to increase speed
-- slowly rather than delaying all other segments if there is an initial speed 
-- problem on a segment where we don't have a good measure of throughput.
--
-- This means we are generally ~84% confident the cycle will complete in the
-- specified cycle time not taking into consideration a new sample given the 
-- assumption that we have a normal distribution
--
-- keeping the cycle short prevents penalizing fast urls that 
-- can process around 70-80 terms in a 2.5 minute batch and keeps the slower 
-- segments at around 1-3 terms per 2.5 minute batch so we 
-- do not bottom out by only pulling one task per url/batch
--
-- Also, keeping the cycle duration short minimizes the negative 
-- effects from 
-- 1) not knowing behavior of the initial sample and
-- 2) volatility in throughput of the network and remote services
--
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE @BaseDate DATETIME = GETUTCDATE()
 -- DATEADD(DAY , -45 , GETUTCDATE())

-- how quickly do we need to adapt to change? what happens in worst case? be careful and think through ramifications if too big or too small.
    DECLARE @DefaultSampleTimeInHours INT = 2
 
    DECLARE @SampleFloorDate DATETIME = DATEADD(hour ,
                                                -1 * @DefaultSampleTimeInHours ,
                                                @BaseDate)
                                            
    DECLARE @FallbackSampleSize INT = 3

 -- be careful -- think through ramifications if too big or too small
    DECLARE @TargetCycleTimeInMilliseconds DECIMAL = 1000 * 60 * 2.5 -- 2.5 min

 -- be careful -- think through ramifications if too big or too small
    DECLARE @FailureCeiling INT = 6 ;

-- minimum request time we consider valid for taking measurements to determine throughput
    DECLARE @ValidMeasurementMillisecondsFloor INT = 500 

    DECLARE @tmp TABLE ( id INT PRIMARY KEY ) ;
    WITH    speed
              AS ( SELECT   otl.TransmissionQueueItemId
                           ,DATEDIFF(ms , otl.Created , otl.Updated) ms
                   FROM     dbo.OutTransmissionLogs otl
                   WHERE    otl.Created BETWEEN @SampleFloorDate
                                        AND     @BaseDate
                            AND DATEDIFF(ms , otl.Created , otl.Updated) > @ValidMeasurementMillisecondsFloor
                 ),
            throttle
              AS ( SELECT   ISNULL(@TargetCycleTimeInMilliseconds / ( AVG(ms)
                                                              + STDEV(ms) + 1  -- prevent divide by zero
                                                              ) ,
                                   @FallbackSampleSize) AS max_pull_count
                           ,tqi.SourceSystemID
                           ,tqi.ObjectTypeID
                   FROM     speed s
                            JOIN dbo.TransmissionQueueItems tqi ON s.TransmissionQueueItemId = tqi.TransmissionQueueItemID
                   GROUP BY tqi.SourceSystemID
                           ,tqi.ObjectTypeId
                 ),
            data
              AS ( SELECT   tqi.SourceSystemID
                           ,tqi.ObjectTypeID
                           ,CAST(CASE WHEN COUNT(1) < ISNULL(th.max_pull_count ,
                                                             @FallbackSampleSize)
                                      THEN COUNT(1)
                                      ELSE ISNULL(th.max_pull_count ,
                                                  @FallbackSampleSize)
                                 END AS INT) TransmissionQueueItemCount
                   FROM     TransmissionQueueItems tqi
                            LEFT JOIN throttle th ON TQI.SourceSystemID = th.SourceSystemID
                                                     AND tqi.ObjectTypeID = th.ObjectTypeID
                   WHERE    ( TQI.FailureCount = 0
                              OR ( TQI.ServiceWillContinueSending = 1
                                   AND TQI.Updated <= @lastFailureTimeFloor
                                 )
                            )
                            AND TQI.SuccessCount = 0
                            AND IsForUnloadService = 0  -- not for polling service
                   GROUP BY tqi.SourceSystemID
                           ,tqi.ObjectTypeID
                           ,ISNULL(th.max_pull_count , @FallbackSampleSize)
                 )
                 
        INSERT  INTO TransmissionQueueItemLoadSourceTransmissions
                ( SourceSystemID
                ,ObjectTypeID
                ,TransmissionQueueItemCount
                )
        OUTPUT  INSERTED.ID
                INTO @tmp
                SELECT TOP ( @maxItems )
                        SourceSystemID
                       ,ObjectTypeID
                       ,TransmissionQueueItemCount
                FROM    data
				ORDER BY ISNULL(TransmissionQueueItemCount , 0) DESC
             
    SELECT TOP ( @maxitems )
            SourceSystemID
           ,ObjectTypeID
           ,TransmissionQueueItemCount
    FROM    @tmp t
            JOIN TransmissionQueueItemLoadSourceTransmissions d ON t.id = d.ID
    ORDER BY TransmissionQueueItemCount DESC