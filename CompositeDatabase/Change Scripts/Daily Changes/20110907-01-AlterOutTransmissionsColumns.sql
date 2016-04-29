IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OutTransmissions'
		 AND COLUMN_NAME = 'TextToTransmit' AND DATA_TYPE = 'varchar')
	ALTER TABLE OutTransmissions 
	ALTER COLUMN TextToTransmit nvarchar(max) null
GO

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OutTransmissions'
		 AND COLUMN_NAME = 'ResponseText' AND DATA_TYPE = 'varchar')
	ALTER TABLE OutTransmissions 
	ALTER COLUMN ResponseText nvarchar(max) null
GO
 