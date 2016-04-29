IF OBJECT_ID('spLoadUserRolesForModule') IS NOT NULL
	DROP PROCEDURE spLoadUserRolesForModule
GO

CREATE PROCEDURE dbo.spLoadUserRolesForModule    
(    
	@UserId INT,
	@SecurityModuleId INT,
	@SecuredObjectId int,
	@SegmentId INT
)    
AS    
BEGIN    
 
	SELECT UOR.* 
	FROM UserObjectRole UOR
		JOIN RolesAllModules R
			ON UOR.RoleID = R.RoleID
			AND R.Active = 1
			AND R.Deleted = 0
			AND @SecurityModuleId IN (0, R.ModuleID) -- limit to given module or ALL if 0
	WHERE UOR.Active = 1 
		AND UOR.Deleted = 0   
		AND UOR.SegmentID = @SegmentId
		AND @UserId IN (0, UOR.GrantToObjectId) -- limit to given userId or ALL if 0
		AND @SecuredObjectId IN (0, UOR.GrantOnObjectId) -- limit to given secured Id or ALL if 0

END

GO  
