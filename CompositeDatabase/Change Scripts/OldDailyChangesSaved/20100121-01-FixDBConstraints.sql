IF (OBJECT_ID('FK_MedDictTermUpdates_In_MedicalDictionaryTerm') IS NOT NULL)
	ALTER TABLE MedDictTermUpdates
	DROP CONSTRAINT FK_MedDictTermUpdates_In_MedicalDictionaryTerm
GO

IF (OBJECT_ID('FK_MedDictTermUpdates_MedicalDictionary') IS NOT NULL)
	ALTER TABLE MedDictTermUpdates
	DROP CONSTRAINT FK_MedDictTermUpdates_MedicalDictionary
GO

IF (OBJECT_ID('FK_MedDictTermUpdates_MedicalDictVerTerm') IS NOT NULL)
	ALTER TABLE MedDictTermUpdates
	DROP CONSTRAINT FK_MedDictTermUpdates_MedicalDictVerTerm
GO

IF (OBJECT_ID('FK_MedDictTermVerUpdates_In_MedicalDictionaryTerm') IS NOT NULL)
	ALTER TABLE MedDictTermVerUpdates
	DROP CONSTRAINT FK_MedDictTermVerUpdates_In_MedicalDictionaryTerm
GO

IF (OBJECT_ID('FK_MedDictTermVerUpdates_MedicalDictionary') IS NOT NULL)
	ALTER TABLE MedDictTermVerUpdates
	DROP CONSTRAINT FK_MedDictTermVerUpdates_MedicalDictionary
GO

IF (OBJECT_ID('FK_MedDictTermVerUpdates_MedicalDictVerTerm') IS NOT NULL)
	ALTER TABLE MedDictTermVerUpdates
	DROP CONSTRAINT FK_MedDictTermVerUpdates_MedicalDictVerTerm
GO

IF (OBJECT_ID('FK_MedDictVerTermComponents_MedicalDictionary') IS NOT NULL)
	ALTER TABLE MedDictVerTermComponents
	DROP CONSTRAINT FK_MedDictVerTermComponents_MedicalDictionary
GO

IF (OBJECT_ID('FK_MedDictComponentUpdates_MedDictVerTermComponents') IS NOT NULL)
	ALTER TABLE MedDictComponentUpdates
	DROP CONSTRAINT FK_MedDictComponentUpdates_MedDictVerTermComponents
GO

IF (OBJECT_ID('FK_MedDictComponentVerUpdates_MedDictVerTermComponents') IS NOT NULL)
	ALTER TABLE MedDictComponentVerUpdates
	DROP CONSTRAINT FK_MedDictComponentVerUpdates_MedDictVerTermComponents
GO

IF (OBJECT_ID('FK_MedDictTermRelUpdates_MedicalDictVerTermRel') IS NOT NULL)
	ALTER TABLE MedDictTermRelUpdates
	DROP CONSTRAINT FK_MedDictTermRelUpdates_MedicalDictVerTermRel
GO

IF (OBJECT_ID('FK_MedDictTermRelVerUpdates_MedicalDictVerTermRel') IS NOT NULL)
	ALTER TABLE MedDictTermRelVerUpdates
	DROP CONSTRAINT FK_MedDictTermRelVerUpdates_MedicalDictVerTermRel
GO

IF (OBJECT_ID('FK_MedicalDictVerTermRel_From_MedicalDictVerTerm') IS NOT NULL)
	ALTER TABLE MedicalDictVerTermRel
	DROP CONSTRAINT FK_MedicalDictVerTermRel_From_MedicalDictVerTerm
GO

IF (OBJECT_ID('FK_MedicalDictVerTermRel_To_MedicalDictVerTerm') IS NOT NULL)
	ALTER TABLE MedicalDictVerTermRel
	DROP CONSTRAINT FK_MedicalDictVerTermRel_To_MedicalDictVerTerm	
GO

IF (OBJECT_ID('FK_MedDictVerTermComponents_MedicalDictVerTerm') IS NOT NULL)
	ALTER TABLE MedDictVerTermComponents
	DROP CONSTRAINT FK_MedDictVerTermComponents_MedicalDictVerTerm
GO

IF (OBJECT_ID('FK_DictionaryVersionSubscriptions_HistoricalVersionLocaleStatusID') IS NOT NULL)
	ALTER TABLE DictionaryVersionSubscriptions
	DROP CONSTRAINT FK_DictionaryVersionSubscriptions_HistoricalVersionLocaleStatusID 
GO

IF (OBJECT_ID('FK_MedDictComponentVerUpdates_In_MedicalDictTermComponents') IS NOT NULL)
    ALTER TABLE MedDictComponentVerUpdates
    DROP CONSTRAINT FK_MedDictComponentVerUpdates_In_MedicalDictTermComponents
GO
 
IF (OBJECT_ID('FK_MedDictComponentVerUpdates_Fn_MedicalDictTermComponents') IS NOT NULL)
    ALTER TABLE MedDictComponentVerUpdates
    DROP CONSTRAINT FK_MedDictComponentVerUpdates_Fn_MedicalDictTermComponents
GO

IF (OBJECT_ID('FK_MedDictComponentUpdates_Fn_MedicalDictTermComponents') IS NOT NULL)
    ALTER TABLE MedDictComponentUpdates
    DROP CONSTRAINT FK_MedDictComponentUpdates_Fn_MedicalDictTermComponents
GO

IF (OBJECT_ID('FK_MedDictComponentUpdates_In_MedicalDictTermComponents') IS NOT NULL)
    ALTER TABLE MedDictComponentUpdates
    DROP CONSTRAINT FK_MedDictComponentUpdates_In_MedicalDictTermComponents    
GO
    
IF (OBJECT_ID('FK_MedDictTermRelUpdates_In_MedicalDictionaryTermRel') IS NOT NULL)
    ALTER TABLE MedDictTermRelUpdates
    DROP CONSTRAINT FK_MedDictTermRelUpdates_In_MedicalDictionaryTermRel
GO
    
IF (OBJECT_ID('FK_MedDictTermRelVerUpdates_In_MedicalDictionaryTermRel') IS NOT NULL)
    ALTER TABLE MedDictTermRelVerUpdates
    DROP CONSTRAINT FK_MedDictTermRelVerUpdates_In_MedicalDictionaryTermRel
GO

IF (OBJECT_ID('FK_SynonymHistory_SynonymTermID') IS NOT NULL)
	ALTER TABLE SynonymHistory
	DROP CONSTRAINT FK_SynonymHistory_SynonymTermID
GO

IF (OBJECT_ID('FK_MedDictLevelCmpntVerUpdates_In_MedicalDictLevelComponents') IS NOT NULL)
	ALTER TABLE MedDictLevelCmpntVerUpdates
	DROP CONSTRAINT FK_MedDictLevelCmpntVerUpdates_In_MedicalDictLevelComponents
GO

IF (OBJECT_ID('FK_MedDictLevelCmpntVerUpdates_Fn_MedicalDictLevelComponents') IS NOT NULL)
	ALTER TABLE MedDictLevelCmpntVerUpdates
	DROP CONSTRAINT FK_MedDictLevelCmpntVerUpdates_Fn_MedicalDictLevelComponents
GO