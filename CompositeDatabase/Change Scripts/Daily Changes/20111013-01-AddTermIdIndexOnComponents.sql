
--Create Index to improve performance of getting components by TermId
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name = 'IX_MedicalDictTermComponents_TermId')
	DROP INDEX MedicalDictTermComponents.IX_MedicalDictTermComponents_TermId

CREATE NONCLUSTERED INDEX IX_MedicalDictTermComponents_TermId
ON [dbo].MedicalDictTermComponents (TermID)
GO 

--Add JDrug Dictionary Type 
IF NOT EXISTS (SELECT NULL FROM DictionarySpecificLogic
WHERE MedicalDictionaryType = 'JDrug'
	AND Locale = 'eng')
INSERT INTO DictionarySpecificLogic (
	MedicalDictionaryType,
	Locale,
	DropAndCreateStagingTablesSP,
	PopulateStagingTablesSP,
	LoadVersionSP,
	CreateFirstVersionSP,
	[Created],
	[Updated]
	)
VALUES(
	'JDrug',
	'eng',
	'spDropAndCreateJDrugStagingTables',
	'spPopulateJDrugStagingTables',
	'spMedicalDictionaryLoadJDrugVersion',
	'spJDrugFirstVersionSetup',
	GETUTCDATE(),
	GETUTCDATE()
)

IF NOT EXISTS (SELECT NULL FROM DictionarySpecificLogic
WHERE MedicalDictionaryType = 'JDrug'
	AND Locale = 'jpn')
INSERT INTO DictionarySpecificLogic (
	MedicalDictionaryType,
	Locale,
	DropAndCreateStagingTablesSP,
	PopulateStagingTablesSP,
	LoadVersionSP,
	CreateFirstVersionSP,
	[Created],
	[Updated]
	)
VALUES(
	'JDrug',
	'jpn',
	'spDropAndCreateJDrugStagingTables',
	'spPopulateJDrugStagingTables',
	'spMedicalDictionaryLoadJDrugVersion',
	'spJDrugFirstVersionSetup',
	GETUTCDATE(),
	GETUTCDATE()
)