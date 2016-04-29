IF NOT EXISTS
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TransmissionQueueItems'
		 AND COLUMN_NAME = 'SegmentID')
	BEGIN
		ALTER TABLE TransmissionQueueItems ADD SegmentID INT NOT NULL CONSTRAINT DF_TransmissionQueueItems_SegmentID DEFAULT (1)
	END
GO


UPDATE TQI
SET TQI.SegmentID = TOS.SegmentID
FROM TransmissionQueueItems TQI
	JOIN TrackableObjects TOS
		ON TQI.studyoid = TOS.ExternalObjectOID
GO		

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_TransmissionQueueItems_SegmentID')
BEGIN
	ALTER TABLE TransmissionQueueItems
	DROP CONSTRAINT DF_TransmissionQueueItems_SegmentID
END
GO	