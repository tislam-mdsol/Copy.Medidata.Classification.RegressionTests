IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_CodingQueries_VerbatimTerm')
	ALTER TABLE CodingQueries
	DROP CONSTRAINT DF_CodingQueries_VerbatimTerm

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'VerbatimTerm')
	ALTER TABLE CodingQueries
	DROP COLUMN VerbatimTerm

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'CodingElementGroupId')
	ALTER TABLE CodingQueries
	ADD CodingElementGroupId BIGINT NOT NULL CONSTRAINT DF_CodingQueries_CodingElementGroupId DEFAULT (-1)
