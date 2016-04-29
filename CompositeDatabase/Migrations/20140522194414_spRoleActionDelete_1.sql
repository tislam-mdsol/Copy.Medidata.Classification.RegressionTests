IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleActionDelete')
	DROP PROCEDURE spRoleActionDelete
GO

CREATE PROCEDURE dbo.spRoleActionDelete 
(
      @RoleActionId INT
)
 
AS  
  
BEGIN  

	UPDATE RoleActions
	SET Deleted = 1
	WHERE RoleActionId = @RoleActionId

END

GO
   