IF object_id('fnPassesReclassifyHistoryFilter') IS NOT NULL
	DROP FUNCTION dbo.fnPassesReclassifyHistoryFilter
GO

CREATE FUNCTION [dbo].fnPassesReclassifyHistoryFilter
(
    @WorkflowActionStartDate DATETIME, 
	@WorkflowActionEndDate DATETIME, 
	@PriorWorkflowStateIDs VARCHAR(255), 
	@PriorWorkflowActionIDs VARCHAR(255),
	@CodingElementId INT
)
RETURNS BIT
AS
BEGIN

	IF EXISTS (
					SELECT NULL
					FROM WorkflowTaskHistory WTH
					WHERE WTH.WorkflowTaskId = @CodingElementID AND
						-- dates check
						WTH.Created BETWEEN @WorkflowActionStartDate AND @WorkflowActionEndDate
						-- 2. priorstateid check
						AND CHARINDEX(CAST(WTH.WorkflowStateID AS VARCHAR)+',', @PriorWorkflowStateIDs) > 0
						-- 3. prioraction check
						AND CHARINDEX(CAST(WTH.WorkflowActionID AS VARCHAR)+',', @PriorWorkflowActionIDs) > 0
					)

		RETURN 1

	RETURN 0	

END
