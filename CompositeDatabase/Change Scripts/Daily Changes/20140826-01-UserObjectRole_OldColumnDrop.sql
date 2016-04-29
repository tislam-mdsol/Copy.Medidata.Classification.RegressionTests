IF EXISTS (SELECT NULL FROM sys.default_constraints WHERE name = 'DF_UserObjectRole_GrantOnObjectTypeId')
	ALTER TABLE UserObjectRole
	DROP CONSTRAINT DF_UserObjectRole_GrantOnObjectTypeId

IF EXISTS (SELECT NULL FROM sys.default_constraints WHERE name = 'DF_UserObjectRole_GrantToObjectTypeId')
	ALTER TABLE UserObjectRole
	DROP CONSTRAINT DF_UserObjectRole_GrantToObjectTypeId

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_UserObjectRole_Single')
	DROP INDEX UserObjectRole.UIX_UserObjectRole_Single

CREATE NONCLUSTERED INDEX [UIX_UserObjectRole_Single] ON [dbo].[UserObjectRole] 
(
	GrantToObjectId, GrantOnObjectId, RoleID, SegmentID
)

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserObjectRole'
		 AND COLUMN_NAME = 'GrantOnObjectTypeId')
	ALTER TABLE UserObjectRole
	DROP COLUMN GrantOnObjectTypeId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserObjectRole'
		 AND COLUMN_NAME = 'GrantToObjectTypeId')
	ALTER TABLE UserObjectRole
	DROP COLUMN GrantToObjectTypeId
GO
