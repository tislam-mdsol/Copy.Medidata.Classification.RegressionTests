IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupFindExisting')
	DROP PROCEDURE spCodingElementGroupFindExisting
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'BasicTermComponent_UDT')
	DROP TYPE BasicTermComponent_UDT
GO

CREATE TYPE [dbo].[BasicTermComponent_UDT] AS TABLE(
	[KeyId] [int] NOT NULL,
	[StringId] [int] NOT NULL
)
GO

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroupComponents'
		AND COLUMN_NAME = 'CodeText')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	DROP COLUMN CodeText
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroupComponents'
		AND COLUMN_NAME = 'SearchType')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	DROP COLUMN SearchType
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroupComponents'
		AND COLUMN_NAME = 'SearchOperator')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	DROP COLUMN SearchOperator
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_CodingElementGroupComponents_Updated')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	DROP CONSTRAINT DF_CodingElementGroupComponents_Updated
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroupComponents'
		AND COLUMN_NAME = 'Updated')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	DROP COLUMN Updated
END

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE NAME = 'DF_CodingElementGroupComponents_IsSupplement')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	DROP CONSTRAINT DF_CodingElementGroupComponents_IsSupplement
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingElementGroupComponents'
		AND COLUMN_NAME = 'IsSupplement')
BEGIN
	ALTER TABLE CodingElementGroupComponents
	DROP COLUMN IsSupplement
END
