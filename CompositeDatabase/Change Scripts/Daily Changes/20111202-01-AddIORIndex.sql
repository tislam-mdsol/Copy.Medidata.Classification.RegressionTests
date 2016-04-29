IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_MedicalDictionaryTerm_IOR')
	DROP INDEX MedicalDictionaryTerm.IX_MedicalDictionaryTerm_IOR
	
CREATE NONCLUSTERED INDEX IX_MedicalDictionaryTerm_IOR
ON [dbo].MedicalDictionaryTerm
(MasterTermId,FromVersionOrdinal,ToVersionOrdinal,IORVersionLocaleValidity)
WHERE SegmentId = -1 