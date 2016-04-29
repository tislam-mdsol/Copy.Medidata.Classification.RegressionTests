IF ( NOT EXISTS ( SELECT    NULL
                  FROM      INFORMATION_SCHEMA.TABLES
                  WHERE     TABLE_NAME = 'TransmissionQueueItemLoadSourceTransmissions' )
   ) 
    BEGIN
        CREATE TABLE [dbo].[TransmissionQueueItemLoadSourceTransmissions]
            (
             [ID] INT IDENTITY(1 , 1)
                      NOT NULL
            ,[SourceSystemID] INT
            ,[ObjectTypeID] INT
            ,[TransmissionQueueItemCount] INT
            ,[Created] [datetime]
                NOT NULL
                CONSTRAINT DF_TransmissionQueueItemLoadSourceTransmissions_Created
                DEFAULT ( GETUTCDATE() )
            ,CONSTRAINT [PK_TransmissionQueueItemLoadSourceTransmissions] PRIMARY KEY CLUSTERED
                ( [ID] ASC )
                WITH ( PAD_INDEX = OFF , STATISTICS_NORECOMPUTE = OFF ,
                       IGNORE_DUP_KEY = OFF , ALLOW_ROW_LOCKS = ON ,
                       ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
            )
        ON  [PRIMARY]
    END
GO