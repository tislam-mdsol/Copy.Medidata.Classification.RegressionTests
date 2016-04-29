IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'LastFailedTransmissionDate')
	)
	ALTER TABLE TransmissionQueueItems
	DROP COLUMN LastFailedTransmissionDate
GO

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'LastSuccessfulTransmissionDate')
	)
	ALTER TABLE TransmissionQueueItems
	DROP COLUMN LastSuccessfulTransmissionDate
GO

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'HttpStatusCode')
	)
	ALTER TABLE TransmissionQueueItems
	DROP COLUMN HttpStatusCode
GO

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'WebExceptionStatus')
	)
	ALTER TABLE TransmissionQueueItems
	DROP COLUMN WebExceptionStatus
GO

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'ResponseText')
	)
	ALTER TABLE TransmissionQueueItems
	DROP COLUMN ResponseText
GO


-- add new column
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'CumulativeFailCount')
	)
BEGIN
	ALTER TABLE TransmissionQueueItems
	ADD CumulativeFailCount INT NOT NULL DEFAULT(0)
END 
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'OutTransmissionID')
	)
BEGIN
	ALTER TABLE TransmissionQueueItems
	ADD OutTransmissionID BIGINT NOT NULL DEFAULT(-1)
END 
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'ServiceWillContinueSending')
	)
BEGIN
	ALTER TABLE TransmissionQueueItems
	ADD ServiceWillContinueSending BIT NOT NULL DEFAULT(1)
END 
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TransmissionQueueItems' AND COLUMN_NAME = 'IsForUnloadService')
	)
BEGIN
	ALTER TABLE TransmissionQueueItems
	ADD IsForUnloadService BIT NOT NULL DEFAULT(0)
END 
GO
