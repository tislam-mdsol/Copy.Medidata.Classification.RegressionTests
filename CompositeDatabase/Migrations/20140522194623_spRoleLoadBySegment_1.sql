IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleLoadBySegment')
	DROP PROCEDURE spRoleLoadBySegment
GO

CREATE PROCEDURE dbo.spRoleLoadBySegment 
(
      @SegmentId INT
)
 
AS  
  
BEGIN  

	SELECT *
	FROM RolesAllModules
	WHERE SegmentId = @SegmentId
	AND Deleted = 0

END

GO
   