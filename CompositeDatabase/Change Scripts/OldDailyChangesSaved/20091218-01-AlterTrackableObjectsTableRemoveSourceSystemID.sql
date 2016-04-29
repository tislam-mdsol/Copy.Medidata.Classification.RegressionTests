-- Remove SourceSystemID column from TrackableObjects table
IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TrackableObjects' AND COLUMN_NAME = 'SourceSystemID'))
BEGIN
	ALTER TABLE TrackableObjects DROP CONSTRAINT FK_TrackableObjects_SourceSystem
	ALTER TABLE TrackableObjects DROP COLUMN SourceSystemID
END
