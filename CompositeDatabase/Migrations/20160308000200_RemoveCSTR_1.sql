IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CodingSourceTermReferences')
BEGIN
	DROP TABLE CodingSourceTermReferences
END