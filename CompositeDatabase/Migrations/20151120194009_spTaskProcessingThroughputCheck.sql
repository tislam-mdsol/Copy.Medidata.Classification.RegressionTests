IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spTaskProcessingThroughputCheck]')
                    AND type IN ( N'P' , N'PC' ) )
                     
    DROP PROCEDURE [dbo].[spTaskProcessingThroughputCheck]
GO

CREATE PROCEDURE [dbo].[spTaskProcessingThroughputCheck]
AS 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE @pastInterval INT = -15;

    WITH    size
              AS ( SELECT   COUNT(1) AS CurrentBacklogSize
                   FROM     CodingElements CE
                            JOIN StudyDictionaryVersion SDV ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
                   WHERE    CE.WorkflowStateID = 1
                            AND CE.IsInvalidTask = 0
                            AND SDV.StudyLock = 1
                 ),
            throughput
              AS ( SELECT   DATEADD(minute , DATEDIFF(minute , 0 , updated) ,
                                    0) AS TimeStampMinute
                           ,COUNT(1) [THROUGHPUT]
                   FROM     CodingElements
                   WHERE    workflowstateid > 1
                            AND IsInvalidTask = 0
                            AND updated > DATEADD(minute , @pastInterval ,
                                                  GETUTCDATE())
                   GROUP BY DATEADD(minute , DATEDIFF(minute , 0 , updated) ,
                                    0)
                 ),
            core
              AS ( SELECT   t1.TimeStampMinute
                           ,t1.THROUGHPUT
                           ,S.*
                   FROM     throughput t1
                            CROSS APPLY SIZE S
                 )
				 
    --SELECT  *
    --FROM    core
    --ORDER BY 1 DESC
             
    SELECT  CASE WHEN COUNT(1) > 10 THEN 'ALERT:PERFORMANCE DEGRADING'
                 ELSE 'OK'
            END  -- signature found for more than 10/15 minutes
    FROM    core
    WHERE   CurrentBacklogSize > 4000 -- backlog of tasks
            AND THROUGHPUT < 50 -- slow

GO


