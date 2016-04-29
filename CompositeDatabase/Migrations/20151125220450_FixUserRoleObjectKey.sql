IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   type = 'P'
                    AND name = 'CMP_FixUserRoleObjectKey' ) 
    DROP PROCEDURE CMP_FixUserRoleObjectKey

GO

CREATE PROCEDURE dbo.CMP_FixUserRoleObjectKey
    (
     @segmentName VARCHAR(250)
    )
AS 
    BEGIN
    
        DECLARE @segmentId INT
           ,@startId INT
           ,@errorString NVARCHAR(MAX)

        SELECT  @segmentId = SegmentId
        FROM    Segments
        WHERE   SegmentName = @segmentName

		Declare @Users table(
			UserID int,
			RoleID int
		)
        IF ( @segmentId IS NULL ) 
            BEGIN

                SELECT  'Cannot find Segment'

                RETURN 0

            END

        BEGIN TRY

            BEGIN TRANSACTION

			Update UserObjectRole
			Set
				  GrantOnObjectKey = '0'
			Output
			      inserted.GrantToObjectId
				 ,inserted.RoleID
				 INTO @users(UserID,RoleID)
			where SegmentID = @segmentId and GrantOnObjectKey= 'All'

			Declare @output varchar(max)

			Select @output = coalesce(@output+', ' , 'Updated User permissions: ') + u.Login +':'+ r.RoleName
			from @Users tempu
			inner join Users u
			on tempu.UserID = u.UserID
			inner join Roles r
			on tempu.RoleID = r.RoleID 

			Print @output
            COMMIT TRANSACTION

        END TRY

        BEGIN CATCH

            ROLLBACK TRANSACTION

            SET @errorString = N'CMP ERROR: Transaction Error Message - '
                + ERROR_MESSAGE()

        --PRINT @errorString

            RAISERROR(@errorString, 16, 1)

        END CATCH	

    END