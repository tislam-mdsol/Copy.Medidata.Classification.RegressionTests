IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleActionLoadBySegment')
	DROP PROCEDURE spRoleActionLoadBySegment
GO

CREATE PROCEDURE dbo.spRoleActionLoadBySegment 
(
      @SegmentId INT
)
 
AS  
  
BEGIN  

	SELECT *
	FROM RoleActions
	WHERE SegmentId = @SegmentId
	AND Deleted = 0

END

GO
   