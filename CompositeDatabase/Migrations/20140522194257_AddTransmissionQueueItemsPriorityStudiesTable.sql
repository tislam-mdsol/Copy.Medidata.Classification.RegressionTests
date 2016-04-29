IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[TransmissionQueueItemsPriorityStudies]')
                    AND type IN ( N'U' ) ) 
    DROP TABLE [dbo].[TransmissionQueueItemsPriorityStudies]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransmissionQueueItemsPriorityStudies]
    (
     [StudyOid] [nvarchar](50) NOT NULL
    ,[SegmentId] INT NOT NULL
    ,[Weight] [int] NOT NULL
    ,CONSTRAINT [PK_TransmissionQueueItemsPriorityStudies] PRIMARY KEY CLUSTERED
        ( [StudyOid] ASC, [SegmentId] ASC )
        WITH ( PAD_INDEX = OFF , STATISTICS_NORECOMPUTE = OFF ,
               IGNORE_DUP_KEY = OFF , ALLOW_ROW_LOCKS = ON ,
               ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
    )
ON  [PRIMARY]

GO