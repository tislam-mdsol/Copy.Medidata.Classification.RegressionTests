IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserObjectRoleInsert')
    BEGIN
        DROP  Procedure  spUserObjectRoleInsert
    END

GO

CREATE Procedure dbo.spUserObjectRoleInsert
(
        @GrantToObjectId INT,
        @GrantOnObjectKey NVARCHAR(100),
        @RoleID INT,
        @Active BIT,
        @DenyObjectRole BIT,
        @SegmentID INT,
        @UserObjectRoleId INT OUTPUT
)

AS

BEGIN

        DECLARE @ModuleID INT = ( 
								  SELECT    ModuleId
                                  FROM      Roles R
                                  WHERE     R.RoleID = @RoleID
                                )


        IF ISNUMERIC(@GrantOnObjectKey) <> 1
            AND @ModuleID <> 3 -- all are numeric except 'dictionary security' 
            BEGIN
            
                DECLARE @ErrorMessage VARCHAR(MAX) = 
					N'@GrantOnObjectKey parameter must be numeric for ModuleID '
                    + CAST(@ModuleID AS VARCHAR(16))
                
                RAISERROR (
					@ErrorMessage,
					11, -- Severity.
					1 -- State,
					);
                RETURN 
            END

    DECLARE @UtcDate DateTime  
    SET @UtcDate = GetUtcDate()  
    DECLARE @Created DATETIME = @UtcDate, @Updated DATETIME = @UtcDate  
    
    DECLARE @Deleted BIT =0
     
    INSERT INTO UserObjectRole (
        GrantToObjectId,
        GrantOnObjectKey,
        RoleID,
        Active,
        Created,
        Updated,
        DenyObjectRole,
        SegmentID,
        Deleted,
        
        GrantOnObjectId_BackUp --  Legacy, to remove
    ) VALUES (
        @GrantToObjectId,
        @GrantOnObjectKey,
        @RoleID,
        @Active,
        @Created,
        @Updated,
        @DenyObjectRole,
        @SegmentID,
        @Deleted,
        
        -1
    )  
    SET @UserObjectRoleId = SCOPE_IDENTITY() 
    
END

GO