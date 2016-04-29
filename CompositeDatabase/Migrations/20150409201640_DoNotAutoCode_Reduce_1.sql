IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_DoNotAutoCodeTerms_Multi')
BEGIN
	DROP INDEX DoNotAutoCodeTerms.IX_DoNotAutoCodeTerms_Multi
	CREATE NONCLUSTERED INDEX [IX_DoNotAutoCodeTerms_Multi] ON [dbo].[DoNotAutoCodeTerms] 
	(
		SegmentId, DictionaryVersionId, DictionaryLevelId, Locale, Active
	)
	INCLUDE
	( Term )
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DoNotAutoCodeTerms'
		 AND COLUMN_NAME = 'MedicalDictionaryID')
	ALTER TABLE DoNotAutoCodeTerms
	DROP COLUMN MedicalDictionaryID
GO

