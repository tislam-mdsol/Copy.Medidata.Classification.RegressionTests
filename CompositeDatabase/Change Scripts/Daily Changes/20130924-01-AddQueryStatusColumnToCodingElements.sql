IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_CodingElements_QueryStatus')
	ALTER TABLE CodingElements
	DROP CONSTRAINT DF_CodingElements_QueryStatus

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingElements'
			AND COLUMN_NAME = 'QueryStatus')
	ALTER TABLE CodingElements
	DROP COLUMN QueryStatus

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingElements'
			AND COLUMN_NAME = 'QueryStatus')
	ALTER TABLE CodingElements
	ADD QueryStatus SMALLINT NOT NULL CONSTRAINT DF_CodingElements_QueryStatus DEFAULT (0)