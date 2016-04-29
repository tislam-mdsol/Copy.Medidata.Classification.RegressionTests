-- security
--ActionTypeR
--ModulesR
--ModuleActions


--ActivationStatusR
DELETE FROM ActivationStatusR
INSERT ActivationStatusR (ActivationStatus, Name) VALUES (0, N'RequiresActivation')
INSERT ActivationStatusR (ActivationStatus, Name) VALUES (1, N'ActivationPending')
INSERT ActivationStatusR (ActivationStatus, Name) VALUES (2, N'Activated')
INSERT ActivationStatusR (ActivationStatus, Name) VALUES (3, N'BadActivationCode')
INSERT ActivationStatusR (ActivationStatus, Name) VALUES (4, N'BadPIN')
INSERT ActivationStatusR (ActivationStatus, Name) VALUES (5, N'MaxAttempts')

--MedicalDictionaryAlgorithm
DELETE FROM MedicalDictionaryAlgorithm
INSERT MedicalDictionaryAlgorithm (MedicalDictionaryAlgorithmID, OID, SelectThreshold, SuggestThreshold, Active) 
	VALUES (1, 'FreeTextNoStem', 100, 50, 1)
INSERT MedicalDictionaryAlgorithm (MedicalDictionaryAlgorithmID, OID, SelectThreshold, SuggestThreshold, Active) 
	VALUES (2, 'FreeTextStemTerms', 100, 50, 1)
INSERT MedicalDictionaryAlgorithm (MedicalDictionaryAlgorithmID, OID, SelectThreshold, SuggestThreshold, Active) 
	VALUES (3, 'ExactNoStem', 100, 50, 1)
INSERT MedicalDictionaryAlgorithm (MedicalDictionaryAlgorithmID, OID, SelectThreshold, SuggestThreshold, Active) 
	VALUES (4, 'ExactStemAll', 100, 50, 1)
INSERT MedicalDictionaryAlgorithm (MedicalDictionaryAlgorithmID, OID, SelectThreshold, SuggestThreshold, Active) 
	VALUES (5, 'ExactStemTerms', 100, 50, 1)
INSERT MedicalDictionaryAlgorithm (MedicalDictionaryAlgorithmID, OID, SelectThreshold, SuggestThreshold, Active) 
	VALUES (6, 'ExactStemPhrases', 100, 50, 1)

-- ServiceCommands
DELETE FROM ServiceCommands

INSERT INTO ServiceCommands (Active, CommandName)
VALUES(1, 'RestartCron')

INSERT INTO ServiceCommands (Active, CommandName)
VALUES(1, 'ResetCronQueue')

INSERT INTO ServiceCommands (Active, CommandName)
VALUES(1, 'ResetODMRequestQueue')

INSERT INTO ServiceCommands (Active, CommandName)
VALUES(1, 'ResetODMRequestWorkerThreads')

INSERT INTO ServiceCommands (Active, CommandName)
VALUES(1, 'ApiDefinitionChange')

--RolePermissionR



--ObjRefModelR
DELETE FROM ObjRefModelR
INSERT ObjRefModelR (ObjRefModelId, Name) VALUES (0, N'Literal')
INSERT ObjRefModelR (ObjRefModelId, Name) VALUES (1, N'Logical')
INSERT ObjRefModelR (ObjRefModelId, Name) VALUES (2, N'Database')

--Localizations
--CoderLocaleAddlInfo
DELETE FROM CoderLocaleAddlInfo
INSERT CoderLocaleAddlInfo (ID, Locale, LCID_Number, LocaleOffsetForIOR) VALUES (1, 'eng', 1033, 0)
INSERT CoderLocaleAddlInfo (ID, Locale, LCID_Number, LocaleOffsetForIOR) VALUES (2, 'jpn', 1041, 1)
INSERT CoderLocaleAddlInfo (ID, Locale, LCID_Number, LocaleOffsetForIOR) VALUES (3, 'loc', 0, 2)


--SET IDENTITY_INSERT Localizations ON
--INSERT Localizations (Locale, HelpFolder, NameFormat, NumberFormat, DateFormat, SubmitOnEnter, DescriptionID, DateTimeFormat, Culture, LocaleID) VALUES (N'eng', N'', N'{FNAME} {LNAME} {TITLE}', N'', N'dd MMM yyyy', 1, 58, N'dd MMM yyyy hh:nn:ss rr', NULL, 1)
--SET IDENTITY_INSERT Localizations OFF

--InteractionStatusR
DELETE FROM InteractionStatusR
INSERT InteractionStatusR (InteractionStatus, Name) VALUES (-4, N'NoInteraction')
INSERT InteractionStatusR (InteractionStatus, Name) VALUES (-3, N'PasswordExpired')
INSERT InteractionStatusR (InteractionStatus, Name) VALUES (-2, N'NoInteraction')
INSERT InteractionStatusR (InteractionStatus, Name) VALUES (-1, N'TimedOut')
INSERT InteractionStatusR (InteractionStatus, Name) VALUES (0, N'Open')
INSERT InteractionStatusR (InteractionStatus, Name) VALUES (1, N'Closed')
INSERT InteractionStatusR (InteractionStatus, Name) VALUES (2, N'ForceClosed')



--InstalledModules
--SET IDENTITY_INSERT InstalledModules ON
--INSERT InstalledModules (ModuleID, ModuleAbbrev, ModuleName, Options, FirstPage, Active, Icon, HelpFile) VALUES (1, N'EDC', N'EDC', 3, N'EDC/StudiesPage.aspx', 1, N'crf_bl.gif', N'Modules/EDC/EDC.htm')
--SET IDENTITY_INSERT InstalledModules OFF

--ImpliedActionTypes
--INSERT ImpliedActionTypes (ActionType, ImpliedActionType) VALUES (0, 0)

--WelcomeMessageTags

--WelcomeMessages


--ApplicationR
DELETE FROM ApplicationR
SET IDENTITY_INSERT ApplicationR ON
INSERT INTO ApplicationR (ApplicationId, ApplicationName) VALUES(1, 'MedidataCoder')
SET IDENTITY_INSERT ApplicationR OFF

--AuditTypeR
if (select COUNT(*) from AuditProcesses) = 0
Begin
	insert into AuditProcesses
	select 'CodR', 1
End

if (select COUNT(*) from audittyper) = 0
Begin
	insert into audittyper
	select 1, 'Create'
	union all
	select 2, 'Update'
	union all
	select 3, 'Delete'
	union all
	select 4, 'InActivate'
	union all
	select 5, 'Activate'
end

if (select COUNT(*) from AuditDetailTypes) = 0
Begin
	insert into AuditDetailTypes
	select null, null, 'aud_ObjectCreated', 1, null
	union all
	select null, null, 'aud_ObjectUpdate', 2, null
	union all
	select null, null, 'aud_ObjectDelete', 3, null
	union all
	select null, null, 'aud_ObjectInActivate', 4, null
	union all
	select null, null, 'aud_ObjectActivate', 5, null
End


--AutoCodeStatusR
--CodingActionR
--CodingInclusionTypeR
--CodingReasonR
--CodingStatusR

--ExternalObjectTypeR
DELETE FROM ExternalObjectTypeR
SET IDENTITY_INSERT ExternalObjectTypeR ON
INSERT INTO ExternalObjectTypeR (ExternalObjectTypeID, ObjectFullName, ObjectTypeName, AssemblyName) 
VALUES(1, 'CodingStudy', 'CodingStudy', NULL)
SET IDENTITY_INSERT ExternalObjectTypeR OFF

--ImpactAnalysisChangeTypeR
DELETE FROM ImpactAnalysisChangeTypeR
INSERT INTO ImpactAnalysisChangeTypeR (ImpactAnalysisChangeTypeID, OID) VALUES(1, 'NotAffected')
INSERT INTO ImpactAnalysisChangeTypeR (ImpactAnalysisChangeTypeID, OID) VALUES(2, 'Obsolete')
INSERT INTO ImpactAnalysisChangeTypeR (ImpactAnalysisChangeTypeID, OID) VALUES(3, 'ReInstated')
INSERT INTO ImpactAnalysisChangeTypeR (ImpactAnalysisChangeTypeID, OID) VALUES(4, 'NodepathChanged')
INSERT INTO ImpactAnalysisChangeTypeR (ImpactAnalysisChangeTypeID, OID) VALUES(5, 'TermNotFound')
INSERT INTO ImpactAnalysisChangeTypeR (ImpactAnalysisChangeTypeID, OID) VALUES(6, 'CodeNotFound')
INSERT INTO ImpactAnalysisChangeTypeR (ImpactAnalysisChangeTypeID, OID) VALUES(7, 'TermAndCodeNotFound')



--MedDictTermStatusR
--MedDictVerChangeTypeR
--MedicalDictTermTypeR

--MedicalDictVerStatusR --[ 1 - 10 ]
DELETE FROM MedicalDictVerStatusR
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('VERSION_CREATED',1, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('STAGING_COMPLETE',2, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('LOADING_COMPLETE',3, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('TERM_DIFF_COMPLETE',4, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('TERMREL_DIFF_COMPLETE',5, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('COMP_DIFF_COMPLETE',6, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('LVLCOMP_DIFF_COMPLETE',7, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('VERSION_ACTIVATED',8, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('VERSION_REWIRED',9, GETUTCDATE(), GETUTCDATE())
INSERT INTO MedicalDictVerStatusR (OID, VersionStatus, Created, Updated) VALUES('VERSION_COMPARISON',10, GETUTCDATE(), GETUTCDATE())


--ObjectSegmentStatusR --[ 0 - 4 ]
DELETE FROM ObjectSegmentStatusR
insert into ObjectSegmentStatusR (ObjectSegmentStatus, Name) values(0, 'None')
insert into ObjectSegmentStatusR (ObjectSegmentStatus, Name) values(1, 'IsProduction')
insert into ObjectSegmentStatusR (ObjectSegmentStatus, Name) values(2, 'AllowWorkflowChange')
insert into ObjectSegmentStatusR (ObjectSegmentStatus, Name) values(4, 'Unknown')


--PermissionR -- [?]
--StdStringTypeR -- [ used by FRM localization ]

-- synonym module
	--1. SynMigrReconciledCategoryR
DELETE FROM SynMigrReconciledCategoryR	
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('NOCLEARMATCH', 65)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('PRIORSYNNOWTERM', 80)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('CLEARMATCH', 100)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('TERMCHANGED', 200)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('PATHDOESNOTEXIST', 210)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('PRIMSOCCHANGE', 220)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('SYNPRIMPATHCHANGE', 230)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('MULTIAXCHANGE', 240)
	INSERT INTO SynMigrReconciledCategoryR (OID, CategoryStatus) VALUES ('NOMATCH', 255)

	--2. SynonymActionR
DELETE FROM SynonymActionR		
	INSERT INTO SynonymActionR (SynonymActionID, ActionOID) VALUES(1, 'CREATE')
	INSERT INTO SynonymActionR (SynonymActionID, ActionOID) VALUES(2, 'MIGRATE')
	INSERT INTO SynonymActionR (SynonymActionID, ActionOID) VALUES(3, 'SPLIT')
	INSERT INTO SynonymActionR (SynonymActionID, ActionOID) VALUES(4, 'RECONCILE')
	INSERT INTO SynonymActionR (SynonymActionID, ActionOID) VALUES(5, 'ACTIVATE')
	INSERT INTO SynonymActionR (SynonymActionID, ActionOID) VALUES(6, 'RETIRE')	
	INSERT INTO SynonymActionR (SynonymActionID, ActionOID) VALUES(7, 'ACTIVATEPROVISIONAL')	

	--3. SynonymMigrationStatusR
DELETE FROM SynonymMigrationStatusR		
	INSERT INTO SynonymMigrationStatusR (OID, SynonymMigrationStatus) VALUES ('SYNMIGR_NOTSTARTED', 1)
	INSERT INTO SynonymMigrationStatusR (OID, SynonymMigrationStatus) VALUES ('SYNMIGR_GENERATINGSUGGESTIONS', 2)
	INSERT INTO SynonymMigrationStatusR (OID, SynonymMigrationStatus) VALUES ('SYNMIGR_READYTOMIGRATE', 3)
	INSERT INTO SynonymMigrationStatusR (OID, SynonymMigrationStatus) VALUES ('SYNMIGR_ACTIVATIONINPROGRESS', 4)
	INSERT INTO SynonymMigrationStatusR (OID, SynonymMigrationStatus) VALUES ('SYNMIGR_COMPLETE', 6)
	INSERT INTO SynonymMigrationStatusR (OID, SynonymMigrationStatus) VALUES ('SYNUPL_LOADINGINPROGRESS', 5)	
	INSERT INTO SynonymMigrationStatusR (OID, SynonymMigrationStatus) VALUES ('SYNMIGR_FAILED', 7)	
	
	--4. SynonymSourceR
DELETE FROM SynonymSourceR
	INSERT INTO SynonymSourceR (SynonymSourceID, SourceOID) VALUES(1, 'LoadFromFile')
	INSERT INTO SynonymSourceR (SynonymSourceID, SourceOID) VALUES(2, 'MigrateFromVersion')
	INSERT INTO SynonymSourceR (SynonymSourceID, SourceOID) VALUES(3, 'CodingDecision')	


--WorkflowSystemActionR
DELETE FROM WorkflowSystemActionR
SET IDENTITY_INSERT WorkflowSystemActionR ON
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(1, 1, N'StartCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(2, 1, N'AutoCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(3, 1, N'SuggestManualCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(4, 1, N'ManualCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(5, 1, N'ReviewCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(6, 1, N'ApproveCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(7, 1, N'RejectCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(8, 1, N'ReCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(9, 1, N'TransmitCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(10, 1, N'TerminateCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(11, 1, N'CompleteCoding', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(12, 1, N'SetVariable', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(13, 1, N'SetWorkflowState', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(14, 1, N'SendEmail', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(15, 1, N'Reconsider', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(16, 1, N'ReClassify', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(17, 1, N'ReCodeDueToStudyMigration', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(18, 1, N'RejectCodingDecision', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(19, 1, N'LeaveAsItIs', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(20, 1, N'AutoApprovalIfCodingRuleMatch', 1)
insert into WorkflowSystemActionR(WorkflowSystemActionID, ApplicationID, ActionName, Active) values(21, 1, N'BypassTransmit', 1)
SET IDENTITY_INSERT WorkflowSystemActionR OFF


-- BitMaskLookup
DELETE FROM BitMaskLookup
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (1, 128)
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (2, 64)
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (3, 32)
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (4, 16)
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (5, 8)
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (6, 4)
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (7, 2)
	INSERT INTO BitMaskLookup (BitPosition, BitMask) VALUES (8, 1)


-- DictionarySpecificLogic

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='DictionarySpecificLogic') 
BEGIN
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

END
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
	
-- MedDRA (Loc)	
IF NOT EXISTS (SELECT NULL FROM DictionarySpecificLogic
	WHERE MedicalDictionaryType = 'MedDRA'
		AND Locale = 'loc')
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
		'loc',
		'spDropAndCreateMedDRAEngStagingTables',
		'spPopulateMedDRAEngStagingTables',
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
	
	
