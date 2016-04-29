IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spRoleFetch]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spRoleFetch]
GO

CREATE PROCEDURE [dbo].[spRoleFetch] ( @RoleId INT )
AS 
    BEGIN  

        SELECT  *
        FROM    Roles
        WHERE   RoleId = @RoleId

    END

GO