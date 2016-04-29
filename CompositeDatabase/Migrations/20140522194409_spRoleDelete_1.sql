IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleDelete')
	DROP PROCEDURE spRoleDelete
GO

CREATE PROCEDURE dbo.spRoleDelete 
(
      @RoleId INT
)
 
AS  
  
BEGIN  

	UPDATE RolesAllModules
	SET Deleted = 1
	WHERE RoleId = @RoleId

END

GO
   