IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'UIX_DictionarySegmentConfigurations_SegmentDictionary')
BEGIN
	DROP INDEX [DictionarySegmentConfigurations].[UIX_DictionarySegmentConfigurations_SegmentDictionary]

END

CREATE UNIQUE NONCLUSTERED INDEX [UIX_DictionarySegmentConfigurations_SegmentDictionary] 
ON [dbo].[DictionarySegmentConfigurations] 
(
	MedicalDictionaryKey ASC,
	SegmentID ASC
)