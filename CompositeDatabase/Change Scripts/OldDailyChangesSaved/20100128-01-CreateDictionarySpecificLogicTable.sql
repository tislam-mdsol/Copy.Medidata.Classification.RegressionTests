if not exists(select null from INFORMATION_SCHEMA.TABLES where TABLE_NAME='DictionarySpecificLogic') begin

	CREATE TABLE [dbo].[DictionarySpecificLogic](
		ID BIGINT IDENTITY(1,1) NOT NULL,
		MedicalDictionaryType VARCHAR(50) NOT NULL,
		Locale CHAR(3) NOT NULL,
		
		DropAndCreateStagingTablesSP VARCHAR(250) NOT NULL,
		PopulateStagingTablesSP VARCHAR(250) NOT NULL,
		
		LoadVersionSP VARCHAR(250) NOT NULL,
		CreateFirstVersionSP VARCHAR(250) NOT NULL,

		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_DictionarySpecificLogic] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

end 

GO

-- MedDRA (Eng, Jpn)
IF NOT EXISTS (SELECT NULL FROM DictionarySpecificLogic
	WHERE MedicalDictionaryType = 'MedDRA'
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
		'MedDRA',
		'eng',
		'spDropAndCreateMedDRAEngStagingTables',
		'spPopulateMedDRAEngStagingTables',
		'spMedicalDictionaryLoadMedDRAVersion',
		'spMedDRAFirstVersionSetup',
		GETUTCDATE(),
		GETUTCDATE()
	)

IF NOT EXISTS (SELECT NULL FROM DictionarySpecificLogic
	WHERE MedicalDictionaryType = 'MedDRA'
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
		'MedDRA',
		'jpn',
		'spDropAndCreateMedDRAJpnStagingTables',
		'spPopulateMedDRAJpnStagingTables',
		'spMedicalDictionaryLoadMedDRAVersion',
		'spMedDRAFirstVersionSetup',
		GETUTCDATE(),
		GETUTCDATE()
	)

-- WhoDRUGB2
IF NOT EXISTS (SELECT NULL FROM DictionarySpecificLogic
	WHERE MedicalDictionaryType = 'WhoDRUGB2'
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
		'WhoDRUGB2',
		'eng',
		'spDropAndCreateWhoDRUGB2EngStagingTables',
		'spPopulateWhoDRUGB2EngStagingTables',
		'spMedicalDictionaryLoadWhoDrugBVersion',
		'spWhoDrugBFirstVersionSetup',
		GETUTCDATE(),
		GETUTCDATE()
	)


-- WhoDRUGC
IF NOT EXISTS (SELECT NULL FROM DictionarySpecificLogic
	WHERE MedicalDictionaryType = 'WhoDRUGC'
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
		'WhoDRUGC',
		'eng',
		'spDropAndCreateWhoDRUGCEngStagingTables',
		'spPopulateWhoDRUGCEngStagingTables',
		'spMedicalDictionaryLoadWhoDrugVersion',
		'spWhoDrugFirstVersionSetup',
		GETUTCDATE(),
		GETUTCDATE()
	)