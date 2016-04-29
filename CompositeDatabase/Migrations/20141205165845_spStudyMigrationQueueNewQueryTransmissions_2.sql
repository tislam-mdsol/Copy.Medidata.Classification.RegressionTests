IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationQueueNewQueryTransmissions')
    DROP PROCEDURE spStudyMigrationQueueNewQueryTransmissions
GO

CREATE PROCEDURE dbo.spStudyMigrationQueueNewQueryTransmissions 
    (
     @StudyDictionaryVersionID INT
    ,@ServiceWillContinueSending BIT
    ,@RowNumbers INT
    ,@MinCodingElementId BIGINT OUTPUT
    ,@RecordCount INT OUTPUT
    )
AS 
    BEGIN  

        DECLARE @TransQueueTT TABLE
            (
             Id BIGINT
            ,QueueId BIGINT
            )

        INSERT  INTO @TransQueueTT
                ( Id
                ,QueueId
                )
                SELECT TOP ( @RowNumbers )
                        CodingElementId
                       ,NewQueryTransmissionQueueItemId
                FROM    StudyMigrationBackup
                WHERE   StudyDictionaryVersionID = @StudyDictionaryVersionID
                        AND NewQueryTransmissionQueueItemId > 0
                        AND CodingElementId > @MinCodingElementId
                ORDER BY CodingElementId ASC

        SELECT  @MinCodingElementId = ISNULL(MAX(Id),0)
        FROM    @TransQueueTT

        UPDATE  TQI
        SET     TQI.FailureCount = 0
               ,TQI.ServiceWillContinueSending = @ServiceWillContinueSending
        OUTPUT  inserted.TransmissionQueueItemID
                INTO @TransQueueTT ( Id )
        FROM    @TransQueueTT TT
                JOIN TransmissionQueueItems TQI ON TT.QueueId = TQI.TransmissionQueueItemID
                
        SELECT @RecordCount = @@ROWCOUNT
    END
GO 