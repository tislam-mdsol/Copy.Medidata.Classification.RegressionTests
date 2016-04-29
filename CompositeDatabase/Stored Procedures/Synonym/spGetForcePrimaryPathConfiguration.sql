IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetForcePrimaryPathConfiguration')
	DROP PROCEDURE spGetForcePrimaryPathConfiguration
GO

CREATE PROCEDURE dbo.spGetForcePrimaryPathConfiguration(
      @SegmentId INT
)
AS
BEGIN 


    SELECT CASE WHEN ConfigValue = 'Yes' THEN 'True'
	            ELSE 'False'
		   END AS ForcePrimaryPath
	FROM Configuration
	WHERE SegmentID = @SegmentId
	AND Tag = 'ForcePrimaryPathSelection'


END
GO