IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spRoleUpdate]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spRoleUpdate]
GO

CREATE PROCEDURE [dbo].[spRoleUpdate]
    (
     @RoleID INT
    ,@Active BIT
    ,@RoleName NVARCHAR(4000)
    ,@ModuleId INT
    ,@SegmentID INT
    ,@Deleted BIT
    )
AS 
    BEGIN
        DECLARE @UtcDate DATETIME  
        SET @UtcDate = GETUTCDATE()  
        DECLARE @Updated DATETIME = @UtcDate  
 
        UPDATE  Roles
        SET     Active = @Active
               ,RoleName = @RoleName
               ,ModuleId = @ModuleId
               ,SegmentID = @SegmentID
               ,Updated = @Updated
               ,Deleted = @Deleted
        WHERE   RoleID = @RoleID
    
    END

GO