IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ObjectiveReferences')
	DROP TABLE ObjectiveReferences
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ObjRefModelExclusions')
	DROP TABLE ObjRefModelExclusions
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SpugPaths')
	DROP TABLE SpugPaths
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_TransmissionQueueItems_ObjectTypeR')
	ALTER TABLE TransmissionQueueItems
	DROP CONSTRAINT FK_TransmissionQueueItems_ObjectTypeR
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_LclDataStringContexts_ObjectTypeId')
	ALTER TABLE LclDataStringContexts
	DROP CONSTRAINT FK_LclDataStringContexts_ObjectTypeId
GO

IF EXISTS
	(SELECT NULL FROM sys.foreign_keys
		WHERE name = 'FK_LclDataStringReferences_ObjectTypeId')
	ALTER TABLE LclDataStringReferences
	DROP CONSTRAINT FK_LclDataStringReferences_ObjectTypeId
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ObjectTypeR')
	DROP TABLE ObjectTypeR
GO