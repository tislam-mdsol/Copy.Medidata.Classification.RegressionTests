DROP INDEX TrackableObjects.IX_TrackableObjects_ExternalObjectId

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_TrackableObjects_ExternalObjectId')
	CREATE UNIQUE NONCLUSTERED INDEX [IX_TrackableObjects_ExternalObjectId] ON [dbo].[TrackableObjects] 
	(
		ExternalObjectId ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO  