-------  CLEAN PROC ------------------------------------------------------------

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spPSStudyTaskCounts]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[spPSStudyTaskCounts]
GO 

-------  CREATE PROC ------------------------------------------------------------

CREATE PROCEDURE [dbo].[spPSStudyTaskCounts]
    @ProjectName NVARCHAR(440) ,
    @SegmentName NVARCHAR(255)
AS 
    BEGIN  
;
        WITH    taskType
                  AS ( SELECT   1 AS id ,
                                'Study Migration' Name
                       UNION ALL
                       SELECT   2 ,
                                'Synonym Migration'
                       UNION ALL
                       SELECT   3 ,
                                'Synonym Migration Activation'
                       UNION ALL
                       SELECT   4 ,
                                'Synonym Download'
                       UNION ALL
                       SELECT   6 ,
                                'Workflow BOT'
                     )
            SELECT  SEG.SegmentName ,
                    SP.ProjectName ,
                    STUDY.ExternalObjectName AS 'StudyName' ,
                    STUDY.ExternalObjectId ,
                    COALESCE(tt.Name, 'Unknown') 'Task Type' ,
                    SUM(CASE WHEN lat.iscomplete = 0
                                  AND lat.isfailed = 0 THEN 1
                             ELSE 0
                        END) PendingCount ,
                    SUM(CASE WHEN LAT.IsComplete = 1 THEN 1
                             ELSE 0
                        END) CompletedCount ,
                    SUM(CASE WHEN LAT.IsFailed = 1 THEN 1
                             ELSE 0
                        END) FailedCount
            FROM    StudyProjects SP
                    JOIN Segments SEG ON SEG.SegmentId = SP.SegmentID
                    JOIN TrackableObjects STUDY ON STUDY.StudyProjectId = SP.StudyProjectId
                    JOIN dbo.LongAsyncTasks LAT ON LAT.SegmentId = SEG.SegmentId
                    JOIN taskType tt ON tt.id = LAT.LongAsyncTaskType
            WHERE   SP.ProjectName = @ProjectName
                    AND SEG.SegmentName = @SegmentName
            GROUP BY SEG.SegmentName ,
                    SP.ProjectName ,
                    STUDY.ExternalObjectName ,
                    STUDY.ExternalObjectId ,
                    COALESCE(tt.Name, 'Unknown')
            ORDER BY SEG.SegmentName ,
                    STUDY.ExternalObjectName ,
                    SP.ProjectName ,
                    COALESCE(tt.Name, 'Unknown')
    END 
GO

------- REMOVE EXISTING ------------------------------------------------------------

DELETE  dbo.ProductionSupportNamedQueries
WHERE   SPName = 'spPSStudyTaskCounts'
GO 

------- ADD QUERY ------------------------------------------------------------

INSERT  INTO [ProductionSupportNamedQueries]
        ( [QueryName] ,
          [SPName] ,
          [Created] ,
          [Updated]
        )
VALUES  ( 'Study Task Count Report' ,
          'spPSStudyTaskCounts' ,
          GETDATE() ,
          GETDATE()
        )
GO


