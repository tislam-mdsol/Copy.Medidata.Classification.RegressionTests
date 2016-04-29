IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRoleFetch')
	DROP PROCEDURE spRoleFetch
GO

CREATE PROCEDURE dbo.spRoleFetch 
(
      @RoleId INT
)
 
AS  
  
BEGIN  

	SELECT *
	FROM RolesAllModules
	WHERE RoleId = @RoleId

END

GO
   