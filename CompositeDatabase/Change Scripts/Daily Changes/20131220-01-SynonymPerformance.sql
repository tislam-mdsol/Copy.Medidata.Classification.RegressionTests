IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElementGroupComponents_CodingElementGroupID')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_CodingElementGroupComponents_CodingElementGroupID] ON [dbo].[CodingElementGroupComponents] 
	(
		[CodingElementGroupID] ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO