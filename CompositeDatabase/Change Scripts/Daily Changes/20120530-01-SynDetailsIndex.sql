IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_MedicalDictionaryTerm_SynDetails')
	CREATE NONCLUSTERED INDEX IX_MedicalDictionaryTerm_SynDetails
	ON [dbo].[MedicalDictionaryTerm] ([SegmentId])
	INCLUDE ([TermId],[MasterTermId],[Term_ENG],[FromVersionOrdinal],[ToVersionOrdinal],[Term_JPN],[Term_LOC],[IORVersionLocaleValidity])
 