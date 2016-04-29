IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCreateWorkFlowRole')
DROP PROCEDURE dbo.spCreateWorkFlowRole
GO

CREATE PROCEDURE [dbo].spCreateWorkFlowRole
( 
     @RoleName		NVARCHAR(255),
	 @SegmentName   NVARCHAR(255)
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

    select @segmentID = SegmentId
    FROM Segments
    WHERE SegmentName = @SegmentName

	 IF @segmentID IS NULL
    BEGIN
        PRINT N'cant find segment'+@SegmentName
    End

	select @segmentID = SegmentId
    FROM Segments
    WHERE SegmentName = @SegmentName
    INSERT INTO WorkflowRoles (ModuleId, SegmentId, Active, RoleName)
    VALUES(1,@segmentID,1,@RoleName)

END

