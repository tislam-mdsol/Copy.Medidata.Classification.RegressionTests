SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Roles]
    (
     [RoleID] [int] IDENTITY(1 , 1)
                    NOT NULL
    ,[Active] [bit] NOT NULL
    ,[Created] [datetime] NOT NULL
    ,[Updated] [datetime] NOT NULL
    ,[RoleName] [nvarchar](4000) NOT NULL
    ,[ModuleId] [int] NULL
    ,[SegmentID] [int] NOT NULL
    ,[UserDeactivated] [bit] NOT NULL
    ,[Deleted] [bit] NOT NULL
    ,[OID] [varchar](50) NOT NULL
    ,CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ( [RoleID] ASC )
        WITH ( PAD_INDEX = OFF , STATISTICS_NORECOMPUTE = OFF ,
               IGNORE_DUP_KEY = OFF , ALLOW_ROW_LOCKS = ON ,
               ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
    )
ON  [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [FK_Roles_Segments] FOREIGN KEY([SegmentID])
REFERENCES [dbo].[Segments] ([SegmentId])
GO

ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [FK_Roles_Segments]
GO

ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_Created]  DEFAULT (GETUTCDATE()) FOR [Created]
GO

ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_Updated]  DEFAULT (GETUTCDATE()) FOR [Updated]
GO

ALTER TABLE [dbo].[Roles] ADD  DEFAULT ((1)) FOR [ModuleId]
GO

ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_UserDeactivated]  DEFAULT ((0)) FOR [UserDeactivated]
GO

ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO


SET IDENTITY_INSERT Roles ON 

INSERT  INTO Roles
        ( 
         RoleID
        ,Active
        ,Created
        ,Updated
        ,RoleName
        ,ModuleId
        ,SegmentID
        ,UserDeactivated
        ,Deleted
        ,OID 
        )
        SELECT  ram.RoleID
               ,ram.Active
               ,ram.Created
               ,ram.Updated
               ,lds.String AS RoleName
               ,ram.ModuleId
               ,ram.SegmentID
               ,ram.UserDeactivated
               ,ram.Deleted
               ,ram.OID
        FROM    dbo.RolesAllModules ram
				JOIN LocalizedDataStringPKs LPK
					ON ram.RoleNameID = LPK.StringId
                JOIN dbo.LocalizedDataStrings lds 
					ON ram.RoleNameID = lds.StringID
                    AND lds.Locale = LPK.InsertedInLocale
        WHERE ram.Deleted=0

SET IDENTITY_INSERT Roles OFF

GO



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
    ,@OID VARCHAR(50)
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
                ,OID
              )
        VALUES  ( 
                 @Active
                ,@Created
                ,@Updated
                ,@RoleName
                ,@ModuleId
                ,@SegmentID
                ,@OID
              )  
        SET @RoleID = SCOPE_IDENTITY() 
    
    END

GO

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
    ,@OID VARCHAR(50)
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
               ,OID = @OID
               ,Updated = @Updated
               ,Deleted = @Deleted
        WHERE   RoleID = @RoleID
    
    END

GO