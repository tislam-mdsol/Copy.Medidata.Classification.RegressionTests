IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_SecurityAudit')
	DROP PROCEDURE CMP_SecurityAudit
GO

CREATE PROCEDURE dbo.CMP_SecurityAudit
(
	@segmentId INT
)
AS
BEGIN

	DECLARE @userIds TABLE(Id INT PRIMARY KEY)
	-- get all users subscribed to the segment
	INSERT INTO @userIds
	SELECT DISTINCT(ObjectId)
	FROM ObjectSegments
	WHERE ObjectTypeId = 17
		AND Deleted = 0
		AND SegmentId = @segmentId

	SELECT Us.login, R.RoleName AS DictionaryRole, UOR.DenyObjectRole, ISNULL(DR.OID, 'All Dictionaries') AS RoleScope
	FROM UserObjectRole UOR
		JOIN @userIds U
			ON UOR.GrantToObjectId = U.Id
		JOIN Roles R
			ON R.RoleID = UOR.RoleID
		JOIN Users Us
			ON Us.UserId = U.Id
		LEFT JOIN DictionaryRef DR
			ON DR.DictionaryRefID = UOR.GrantOnObjectId
	WHERE UOR.SegmentID = @segmentId
		AND R.ModuleId = 3

	SELECT Us.login, R.RoleName AS StudyRole, UOR.DenyObjectRole, ISNULL(T.ExternalObjectName, 'All Studies') AS RoleScope
	FROM UserObjectRole UOR
		JOIN @userIds U
			ON UOR.GrantToObjectId = U.Id
		JOIN Roles R
			ON R.RoleID = UOR.RoleID
		JOIN Users Us
			ON Us.UserId = U.Id
		LEFT JOIN TrackableObjects T
			ON T.TrackableObjectId = UOR.GrantOnObjectId
	WHERE UOR.SegmentID = @segmentId
		AND R.ModuleId = 2

	SELECT Us.login, R.RoleName AS SegmentRole, UOR.DenyObjectRole, 'SegmentSecurity' AS RoleScope
	FROM UserObjectRole UOR
		JOIN @userIds U
			ON UOR.GrantToObjectId = U.Id
		JOIN Roles R
			ON R.RoleID = UOR.RoleID
		JOIN Users Us
			ON Us.UserId = U.Id
	WHERE UOR.SegmentID = @segmentId
		AND R.ModuleId = 4

	SELECT Us.login, R.RoleName AS WorkflowRole, UOR.DenyObjectRole, ISNULL(T.ExternalObjectName, 'All Studies') AS RoleScope
	FROM UserObjectWorkflowRole UOR
		JOIN @userIds U
			ON UOR.GrantToObjectId = U.Id
		JOIN WorkflowRoles R
			ON R.WorkflowRoleId = UOR.WorkflowRoleId
		JOIN Users Us
			ON Us.UserId = U.Id
		LEFT JOIN TrackableObjects T
			ON T.TrackableObjectId = UOR.GrantOnObjectId
	WHERE UOR.SegmentID = @segmentId
		AND R.ModuleId = 1

END

