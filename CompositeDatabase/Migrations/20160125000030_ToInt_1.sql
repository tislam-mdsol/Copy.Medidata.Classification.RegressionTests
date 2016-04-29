IF EXISTS (SELECT NULL FROM SYS.indexes WHERE NAME = 'UIX_UserObjectRole_Single')
BEGIN
	DROP INDEX UserObjectRole.UIX_UserObjectRole_Single
END

ALTER TABLE UserObjectRole 
ALTER COLUMN RoleId INT

CREATE NONCLUSTERED INDEX UIX_UserObjectRole_Single 
ON UserObjectRole
(
	GrantToObjectId, RoleID, SegmentID
)

IF EXISTS (SELECT NULL FROM SYS.indexes WHERE NAME = 'IX_RoleActions_roleid')
BEGIN
	DROP INDEX RoleActions.IX_RoleActions_roleid
END

ALTER TABLE RoleActions 
ALTER COLUMN RoleId INT

CREATE NONCLUSTERED INDEX IX_RoleActions_roleid 
ON RoleActions
(
	RoleID
)