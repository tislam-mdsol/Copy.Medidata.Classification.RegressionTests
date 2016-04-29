IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'Ix_MedicalDictionaryTerm_SynMigr')
	DROP INDEX MedicalDictionaryTerm.Ix_MedicalDictionaryTerm_SynMigr

CREATE NONCLUSTERED INDEX Ix_MedicalDictionaryTerm_SynMigr
ON [dbo].MedicalDictionaryTerm 
([DictionaryLevelId],[MedicalDictionaryID],[IsCurrent],[FromVersionOrdinal],[ToVersionOrdinal])
INCLUDE ([TermId],[NodePath],[Code],[Term_ENG],[Term_JPN],[Term_LOC],[IORVersionLocaleValidity])
 
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_MedDictTermUpdates_Primary')
	DROP INDEX MedDictTermUpdates.IX_MedDictTermUpdates_Primary

CREATE NONCLUSTERED INDEX IX_MedDictTermUpdates_Primary
ON [dbo].[MedDictTermUpdates] 
([MedicalDictionaryID],[FromVersionOrdinal],[ToVersionOrdinal],[Locale],[PriorTermID])
INCLUDE (VersionTermId, [FinalTermId])