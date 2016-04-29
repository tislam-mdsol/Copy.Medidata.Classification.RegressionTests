IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spCodingElementLoadTaskIDs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spCodingElementLoadTaskIDs]
GO

create procedure [dbo].[spCodingElementLoadTaskIDs]
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

GO

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