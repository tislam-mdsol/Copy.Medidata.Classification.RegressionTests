IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadStuckTaskIDs')
    DROP Procedure spCodingElementLoadStuckTaskIDs
GO

create procedure [dbo].spCodingElementLoadStuckTaskIDs
(
    @ResetIntervalInMinutes INT,
    @MaxFailureCount INT,
    @SegmentId INT
)
as
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE @LeastDate DATETIME = DATEADD(minute, 0-@ResetIntervalInMinutes, GETUTCDATE())

    --pick up tasks for workflow to process(failure count < max)
    ;With XCTE
    AS
    (
        SELECT top 1000 CE.CodingElementId, FailureCount
        FROM CodingElements CE 
        WHERE IsStillInService = 1
              AND SegmentId = @SegmentId
              AND FailureCount < @MaxFailureCount
              AND Updated < @LeastDate
    )
	
    -- randomly chooses 1 item that matches the predicate
    -- MC: prioritize the tasks most likely to succeed first (those with the lowest failure count)	
    SELECT Top 1 CodingElementId
    FROM XCTE
    ORDER BY FailureCount, newid()

END	
