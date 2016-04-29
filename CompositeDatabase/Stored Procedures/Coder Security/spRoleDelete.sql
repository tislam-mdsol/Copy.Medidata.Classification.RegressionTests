IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spRoleDelete]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spRoleDelete]
GO

CREATE PROCEDURE [dbo].[spRoleDelete] ( @RoleId INT )
AS 
    BEGIN  

        UPDATE  Roles
        SET     Deleted = 1
        WHERE   RoleId = @RoleId

    END

GO