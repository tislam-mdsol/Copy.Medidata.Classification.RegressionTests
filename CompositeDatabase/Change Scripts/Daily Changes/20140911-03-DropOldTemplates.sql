﻿IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'MedicalDictionaryTemplates'))
	DROP TABLE MedicalDictionaryTemplates
