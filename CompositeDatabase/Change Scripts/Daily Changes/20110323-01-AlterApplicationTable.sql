-- Add IsAlwaysBypassTransmit to Application
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Application'
		 AND COLUMN_NAME = 'IsAlwaysBypassTransmit')
	ALTER TABLE Application
	ADD IsAlwaysBypassTransmit BIT NOT NULL DEFAULT (1)
GO  

-- Add IsAlwaysBypassTransmit to ApplicationType
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ApplicationType'
		 AND COLUMN_NAME = 'IsAlwaysBypassTransmit')
	ALTER TABLE ApplicationType
	ADD IsAlwaysBypassTransmit BIT NOT NULL DEFAULT (1)
GO  
