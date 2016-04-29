IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_OutTransmissionLogs_OutTransmissionID')
	DROP INDEX OutTransmissionLogs.IX_OutTransmissionLogs_OutTransmissionID
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_TransmissionQueueItems_ObjectID')
	DROP INDEX TransmissionQueueItems.IX_TransmissionQueueItems_ObjectID
GO

IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingSourceTermSupplementals_CodingSourceTermID')
	DROP INDEX CodingSourceTermSupplementals.IX_CodingSourceTermSupplementals_CodingSourceTermID
GO

CREATE NONCLUSTERED INDEX [IX_OutTransmissionLogs_OutTransmissionID] ON OutTransmissionLogs
(
	OutTransmissionID ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_TransmissionQueueItems_ObjectID] ON TransmissionQueueItems
(
	ObjectID ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_CodingSourceTermSupplementals_CodingSourceTermID] ON CodingSourceTermSupplementals
(
	CodingSourceTermID ASC
)
GO