IF EXISTS ( SELECT  *
	FROM    sys.objects
    WHERE   object_id = OBJECT_ID(N'[dbo].[spRoleLoadBySegment]')
		AND type IN ( N'P' , N'PC' ) ) 

	DROP PROCEDURE [dbo].[spRoleLoadBySegment]
GO

CREATE PROCEDURE [dbo].[spRoleLoadBySegment] ( @SegmentId INT )
AS 
BEGIN  
        SELECT  *
        FROM    Roles
        WHERE   SegmentId = @SegmentId
                AND Deleted = 0
END

GO
