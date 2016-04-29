IF (EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'Ix_CodingAssignment_DictionaryTermID'))
	DROP INDEX Ix_CodingAssignment_DictionaryTermID ON CodingAssignment
	
IF (EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_CodingAssignment_MedicalDictionaryTermID'))
	DROP INDEX IX_CodingAssignment_MedicalDictionaryTermID ON CodingAssignment

IF (EXISTS (SELECT NULL FROM sys.foreign_keys WHERE name = 'FK_Assignment_MedicalDictionaryTerm'))
BEGIN
	ALTER TABLE CodingAssignment
	DROP CONSTRAINT FK_Assignment_MedicalDictionaryTerm
END

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
				AND COLUMN_NAME = 'MedicalDictionaryTermID')
				)
BEGIN
	ALTER TABLE CodingAssignment
	DROP COLUMN MedicalDictionaryTermID
END


IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
				AND COLUMN_NAME = 'MatchPercent')
				)
BEGIN
	ALTER TABLE CodingAssignment
	DROP COLUMN MatchPercent
END

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
				AND COLUMN_NAME = 'CodingPath')
				)
BEGIN
	ALTER TABLE CodingAssignment
	DROP COLUMN CodingPath
END


IF (EXISTS (SELECT NULL FROM sys.default_constraints WHERE name = 'DF_CodingAssignment_IsPrimaryPath'))
BEGIN
	ALTER TABLE CodingAssignment
	DROP CONSTRAINT DF_CodingAssignment_IsPrimaryPath
END

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
				AND COLUMN_NAME = 'IsPrimaryPath')
				)
BEGIN
	ALTER TABLE CodingAssignment
	DROP COLUMN IsPrimaryPath
END


IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
				AND COLUMN_NAME = 'SynonymTermId')
				)
BEGIN
	ALTER TABLE CodingAssignment
	DROP COLUMN SynonymTermId
END


IF (EXISTS (SELECT NULL FROM sys.default_constraints WHERE name = 'DF_CodingAssignment_IsValidForAutoCode'))
BEGIN
	ALTER TABLE CodingAssignment
	DROP CONSTRAINT DF_CodingAssignment_IsValidForAutoCode
END


IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingAssignment'
				AND COLUMN_NAME = 'IsValidForAutoCode')
				)
BEGIN
	ALTER TABLE CodingAssignment
	DROP COLUMN IsValidForAutoCode
END

 