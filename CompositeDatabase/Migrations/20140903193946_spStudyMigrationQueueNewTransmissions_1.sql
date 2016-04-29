IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationQueueNewTransmissions')
    DROP PROCEDURE spStudyMigrationQueueNewTransmissions
GO

CREATE PROCEDURE dbo.spStudyMigrationQueueNewTransmissions 
    (
     @StudyDictionaryVersionID INT
    ,@ServiceWillContinueSending BIT
    ,@RowNumbers INT
    ,@MinCodingElementId BIGINT OUTPUT
    ,@QueuedCount INT OUTPUT
    )
AS 
    BEGIN  

        DECLARE @TransQueueTT TABLE
            (
             Id BIGINT
            ,QueueId BIGINT
            )

        INSERT  INTO @TransQueueTT
                ( 
                 Id
                ,QueueId
                )
                SELECT TOP ( @RowNumbers )
                        CodingElementId
                       ,NewTransmissionQueueItemId
                FROM    StudyMigrationBackup
                WHERE   StudyDictionaryVersionID = @StudyDictionaryVersionID
                        AND NewTransmissionQueueItemId > 0
                        AND CodingElementId > @MinCodingElementId
                ORDER BY CodingElementId ASC

        SELECT  @MinCodingElementId = MAX(Id)
        FROM    @TransQueueTT

        UPDATE  TQI
        SET     TQI.FailureCount = 0
               ,TQI.ServiceWillContinueSending = @ServiceWillContinueSending
        OUTPUT  inserted.TransmissionQueueItemID
                INTO @TransQueueTT ( Id )
        FROM    @TransQueueTT TT
                JOIN TransmissionQueueItems TQI ON TT.QueueId = TQI.TransmissionQueueItemID

        SELECT  @QueuedCount = @@ROWCOUNT

    END
GO 