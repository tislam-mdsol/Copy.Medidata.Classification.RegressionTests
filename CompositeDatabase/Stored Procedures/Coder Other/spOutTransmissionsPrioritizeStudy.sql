IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spOutTransmissionsPrioritizeStudy]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spOutTransmissionsPrioritizeStudy]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spOutTransmissionsPrioritizeStudy]
    (
     @StudyOid VARCHAR(50),
     @SegmentId INT,
     @Weight INT = 0
    )
AS 
    MERGE INTO dbo.TransmissionQueueItemsPriorityStudies
        USING 
            ( SELECT 'StudyOid' AS col_1, 'SegmentId' AS col_2
            ) AS source
        ON dbo.TransmissionQueueItemsPriorityStudies.StudyOid = @StudyOid AND 
		   dbo.TransmissionQueueItemsPriorityStudies.SegmentId = @SegmentId
    WHEN MATCHED AND @Weight = 0 THEN
		DELETE
    WHEN MATCHED AND @Weight <> 0 THEN 
		UPDATE
			SET Weight = @Weight
    WHEN NOT MATCHED AND @Weight <> 0 THEN
    INSERT  ( StudyOid, SegmentId, Weight )
               VALUES
            ( @StudyOid, @SegmentId, @Weight) ;
            
    SELECT * FROM dbo.TransmissionQueueItemsPriorityStudies
GO