IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymUploadRequests'
		 AND COLUMN_NAME = 'SynonymAdded')
	ALTER TABLE SynonymUploadRequests
	ADD SynonymAdded INT NOT NULL CONSTRAINT DF_SynonymUploadRequests_SynonymAdded DEFAULT (0)
	
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymUploadRequests'
		 AND COLUMN_NAME = 'SynonymSkipped')
	ALTER TABLE SynonymUploadRequests
	ADD SynonymSkipped INT NOT NULL CONSTRAINT DF_SynonymUploadRequests_SynonymSkipped DEFAULT (0)

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymUploadRequests'
		 AND COLUMN_NAME = 'SynonymErrored')
	ALTER TABLE SynonymUploadRequests
	ADD SynonymErrored INT NOT NULL CONSTRAINT DF_SynonymUploadRequests_SynonymErrored DEFAULT (0)

IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymUploadRequests'
		 AND COLUMN_NAME = 'TotalSynonymLines')
	ALTER TABLE SynonymUploadRequests
	ADD TotalSynonymLines INT NOT NULL CONSTRAINT DF_SynonymUploadRequests_TotalSynonymLines DEFAULT (0)