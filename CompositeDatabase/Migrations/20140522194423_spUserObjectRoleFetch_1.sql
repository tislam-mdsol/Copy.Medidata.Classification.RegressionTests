IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserObjectRoleFetch')
	DROP PROCEDURE spUserObjectRoleFetch
GO

CREATE PROCEDURE dbo.spUserObjectRoleFetch 
(
      @UserObjectRoleId INT
)
 
AS  
  
BEGIN  

	SELECT *
	FROM UserObjectRole
	WHERE UserObjectRoleId = @UserObjectRoleId

END

GO
   