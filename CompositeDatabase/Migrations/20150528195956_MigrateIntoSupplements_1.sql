IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_CodingSourceTermSupplementals_ValueId')
	ALTER TABLE CodingSourceTermSupplementals
	DROP CONSTRAINT DF_CodingSourceTermSupplementals_ValueId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSourceTermSupplementals'
		 AND COLUMN_NAME = 'ValueId')
	ALTER TABLE CodingSourceTermSupplementals
	DROP COLUMN ValueId
GO

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_CodingSourceTermSupplementals_KeyId')
	ALTER TABLE CodingSourceTermSupplementals
	DROP CONSTRAINT DF_CodingSourceTermSupplementals_KeyId
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSourceTermSupplementals'
		 AND COLUMN_NAME = 'KeyId')
	ALTER TABLE CodingSourceTermSupplementals
	DROP COLUMN KeyId
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSourceTermSupplementals'
		 AND COLUMN_NAME = 'IsComponent')
	ALTER TABLE CodingSourceTermSupplementals
	ADD IsComponent BIT NOT NULL CONSTRAINT DF_CodingSourceTermSupplementals_IsComponent DEFAULT (0)
GO
