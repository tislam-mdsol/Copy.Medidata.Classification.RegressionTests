
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_AssignUserToApplicationSecurity')
	DROP PROCEDURE CMP_AssignUserToApplicationSecurity
GO

CREATE PROCEDURE dbo.CMP_AssignUserToApplicationSecurity  
(  
   @userName NVARCHAR(100)
)  
AS
BEGIN

	DECLARE @userId INT

	SELECT @userId = UserId
	FROM Users
	WHERE login = @userName

	IF (@userId IS NULL)
	BEGIN
		PRINT 'Can not find user. Exiting...'
		RETURN 1
	END

	INSERT INTO UserObjectRole
	(GrantToObjectId, GrantOnObjectId, RoleId, Active, DenyObjectRole, SegmentId, UserDeactivated, Deleted)
	SELECT @userId, 1, R.RoleId, 1, 0, 1, 0, 0
	FROM Roles R
		LEFT JOIN UserObjectRole UOR
			ON R.RoleID = UOR.RoleID
			AND UOR.GrantToObjectId = @userId
			AND UOR.Deleted = 0
	WHERE ModuleId = 5
		AND UOR.RoleId IS NULL

END 