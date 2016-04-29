IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadTaskIDs')
    DROP Procedure spCodingElementLoadTaskIDs
GO

create procedure [dbo].spCodingElementLoadTaskIDs
(
    @MaxFailureCount INT,
    @WorkflowStatesToPickup WorkflowStateIds_UDT READONLY,
    @SegmentId INT
)
as
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    --pick up tasks for workflow to process(failure count < max)
    ;With XCTE
    AS
    (
        SELECT top 2000 CE.CodingElementId, FailureCount
        FROM CodingElements CE 
            JOIN @WorkflowStatesToPickup W ON CE.WorkflowStateID = W.WorkflowStateID
        WHERE IsStillInService = 0
              AND SegmentId = @SegmentId
              AND FailureCount < @MaxFailureCount
    )
    
    -- randomly chooses items that match the predicate
    -- MC: prioritize the tasks most likely to succeed first (those with the lowest failure count)	
    SELECT TOP 20 CodingElementId
    FROM XCTE
    ORDER BY FailureCount, newid()

END	
