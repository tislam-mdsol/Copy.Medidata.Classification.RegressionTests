IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'medicaldictionarytemplatelevel'))
	DROP TABLE medicaldictionarytemplatelevel

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'SegmentMedicalDictionaryTemplates'))
	DROP TABLE SegmentMedicalDictionaryTemplates

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'VariableDictUseAlgorithm'))
	DROP TABLE VariableDictUseAlgorithm

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CodingSourceAlgorithm'))
	DROP TABLE CodingSourceAlgorithm

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'MedicalDictionaryUseAlgorithm'))
	DROP TABLE MedicalDictionaryUseAlgorithm

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'MedicalDictionaryAlgorithm'))
	DROP TABLE MedicalDictionaryAlgorithm