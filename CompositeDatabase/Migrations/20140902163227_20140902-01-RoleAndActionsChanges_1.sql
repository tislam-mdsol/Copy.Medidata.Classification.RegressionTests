﻿IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles'
		 AND COLUMN_NAME = 'OID')
	ALTER TABLE Roles
	DROP COLUMN OID
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RoleActions'
		 AND COLUMN_NAME = 'RestrictionMask')
	ALTER TABLE RoleActions
	DROP COLUMN RestrictionMask
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RoleActions'
		 AND COLUMN_NAME = 'RestrictionStatus')
	ALTER TABLE RoleActions
	DROP COLUMN RestrictionStatus
GO
