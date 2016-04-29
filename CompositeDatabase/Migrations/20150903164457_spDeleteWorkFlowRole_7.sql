
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spDeleteWorkFlowRole')
DROP PROCEDURE spDeleteWorkFlowRole
GO

CREATE PROCEDURE [dbo].spDeleteWorkFlowRole
( 
    @RoleName     NVARCHAR(255),
    @SegmentName  NVARCHAR(255)
) 


AS
BEGIN

--production check
    IF NOT EXISTS (
        SELECT NULL 
        FROM CoderAppConfiguration
        WHERE Active = 1 AND IsProduction = 0)
    BEGIN
        PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
        RETURN 1
    END

    Declare @segmentID INT
	Declare @WorkflowRoleId INT

    SELECT @segmentID = SegmentId
    FROM Segments
    WHERE SegmentName = @SegmentName

    IF @segmentID IS NULL
    BEGIN
        PRINT N'cant find segment'+@SegmentName
    END
	
    SELECT @segmentID = SegmentId
    FROM Segments
    WHERE SegmentName = @SegmentName
    SELECT @WorkflowRoleId = WorkflowRoleId
    FROM WorkflowRoles
    WHERE RoleName = @RoleName
    DELETE FROM WorkflowRoleActions 
    WHERE SegmentId   = @segmentID and WorkflowRoleId = @WorkflowRoleId
    DELETE FROM WorkflowRoles
    WHERE SegmentId   = @segmentID and RoleName = @RoleName
    DELETE FROM WorkflowRoleActions 
    WHERE SegmentId = @segmentID and WorkflowRoleId = @WorkflowRoleId
    DELETE FROM WorkflowRoles
    WHERE SegmentId = @segmentID and RoleName = @RoleName
END
