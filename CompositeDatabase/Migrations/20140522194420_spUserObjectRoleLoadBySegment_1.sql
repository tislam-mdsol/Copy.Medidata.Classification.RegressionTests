IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserObjectRoleLoadBySegment')
	DROP PROCEDURE spUserObjectRoleLoadBySegment
GO

CREATE PROCEDURE dbo.spUserObjectRoleLoadBySegment 
(
      @SegmentId INT
)
 
AS  
  
BEGIN  

	SELECT *
	FROM UserObjectRole
	WHERE SegmentId = @SegmentId
	AND Deleted = 0

END

GO
   