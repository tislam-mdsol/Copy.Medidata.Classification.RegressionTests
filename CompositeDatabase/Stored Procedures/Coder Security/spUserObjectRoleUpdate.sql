IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserObjectRoleUpdate')
    BEGIN
        DROP  Procedure  spUserObjectRoleUpdate
    END

GO

CREATE Procedure dbo.spUserObjectRoleUpdate
(
        @GrantToObjectId INT,
        @GrantOnObjectKey NVARCHAR(100),
        @RoleID INT,
        @Active BIT,
        @DenyObjectRole BIT,
        @SegmentID INT,
        @Deleted BIT,
        @UserObjectRoleId INT
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
         
    Update UserObjectRole
    SET GrantToObjectId     = @GrantToObjectId,
        GrantOnObjectKey    = @GrantOnObjectKey,
        RoleID              = @RoleID,
        Active              = @Active,
        Updated             = GetUtcDate(),
        DenyObjectRole      = @DenyObjectRole,
        SegmentID           = @SegmentID,
        Deleted             = @Deleted
    WHERE UserObjectRoleId = @UserObjectRoleId
    
END

GO