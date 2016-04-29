IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_CodingQueries_QueryRepeatKey')
	ALTER TABLE CodingQueries
	DROP CONSTRAINT DF_CodingQueries_QueryRepeatKey

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'QueryRepeatKey')
	ALTER TABLE CodingQueries
	DROP COLUMN QueryRepeatKey

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'QueryRepeatKey')
	ALTER TABLE CodingQueries
	ADD QueryRepeatKey NVARCHAR(50) NOT NULL CONSTRAINT DF_CodingQueries_QueryRepeatKey DEFAULT (N'')