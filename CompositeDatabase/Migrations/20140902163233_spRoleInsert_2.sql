IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spRoleInsert]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spRoleInsert]
GO

CREATE PROCEDURE [dbo].[spRoleInsert]
    (
     @Active BIT
    ,@RoleName NVARCHAR(4000)
    ,@ModuleId INT
    ,@SegmentID INT
    ,@RoleID INT OUTPUT
    )
AS 
    BEGIN
        DECLARE @UtcDate DATETIME  
        SET @UtcDate = GETUTCDATE()  
        DECLARE @Created DATETIME = @UtcDate
           ,@Updated DATETIME = @UtcDate  
    
     
        INSERT  INTO Roles
                ( 
                 Active
                ,Created
                ,Updated
                ,RoleName
                ,ModuleId
                ,SegmentID
              )
        VALUES  ( 
                 @Active
                ,@Created
                ,@Updated
                ,@RoleName
                ,@ModuleId
                ,@SegmentID
              )  
        SET @RoleID = SCOPE_IDENTITY() 
    
    END

GO