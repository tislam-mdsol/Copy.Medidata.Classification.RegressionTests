﻿IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingPatterns'
		 AND COLUMN_NAME = 'PathCount')
	ALTER TABLE CodingPatterns
	ADD PathCount INT NOT NULL CONSTRAINT DF_CodingPatterns_PathCount DEFAULT (-1)
GO

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
		 AND COLUMN_NAME = 'IsExactMatch')
	ALTER TABLE SegmentedGroupCodingPatterns
	ADD IsExactMatch BIT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_IsExactMatch DEFAULT (0)
GO