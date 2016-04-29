IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserObjectRoleDelete')
	BEGIN
		DROP  Procedure  spUserObjectRoleDelete
	END

GO

CREATE Procedure dbo.spUserObjectRoleDelete
(
		@UserObjectRoleId INT
)

AS

BEGIN
	
	UPDATE UserObjectRole
	SET Deleted = 1
	WHERE UserObjectRoleId = @UserObjectRoleId
	
END

GO