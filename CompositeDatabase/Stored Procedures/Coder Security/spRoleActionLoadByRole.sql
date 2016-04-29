IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleActionLoadByRole')
	DROP PROCEDURE spRoleActionLoadByRole
GO

CREATE PROCEDURE dbo.spRoleActionLoadByRole 
(
      @RoleId INT
)
 
AS  
  
BEGIN  

	SELECT *
	FROM RoleActions
	WHERE RoleId = @RoleId
		AND Deleted = 0

END

GO
   