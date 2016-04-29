 -- first clear existing security
DELETE FROM UserObjectRole
GO
DELETE FROM RoleActions
GO
DELETE FROM RolesAllModules
GO
DELETE FROM ModuleActions
GO
DELETE FROM ImpliedActionTypes
GO
DELETE FROM ActionGroup
GO
DELETE FROM ActionTypeR
GO
DELETE from ModulesR
GO


DECLARE @objTypeID INT

DECLARE @WorkflowModuleID INT,
	@StudyModuleID INT,
	@DictionaryModuleID INT,
	@SegmentModuleID INT,
	@ApplicationModuleID INT


SELECT @WorkflowModuleID = 1,
	@StudyModuleID = 2,
	@DictionaryModuleID = 3,
	@SegmentModuleID = 4,
	@ApplicationModuleID = 5




-- 1. ModulesR
	SELECT @objTypeID = ObjectTypeId
	FROM ObjectTypeR
	WHERE ObjectTypeName = 'TrackableObject'
	
	IF (@objTypeID IS NULL)
		SET @objTypeID = 2168	
	
	INSERT INTO ModulesR (ModuleId, ModuleName, ObjectTypeId, Active)
	VALUES(@WorkflowModuleID, 'WorkflowStudySecurity', @objTypeID, 1)
	
	INSERT INTO ModulesR (ModuleId, ModuleName, ObjectTypeId, Active)
	VALUES(@StudyModuleID, 'PageStudySecurity', @objTypeID, 1)
	
	SET @objTypeID = NULL
	
	SELECT @objTypeID = ObjectTypeId
	FROM ObjectTypeR
	WHERE ObjectTypeName = 'MedicalDictionary'
	
	IF (@objTypeID IS NULL)
		SET @objTypeID = 2001
	
	INSERT INTO ModulesR (ModuleId, ModuleName, ObjectTypeId, Active)
	VALUES(@DictionaryModuleID, 'PageDictionarySecurity', @objTypeID, 1)


	SET @objTypeID = NULL

	SELECT @objTypeID = ObjectTypeId
	FROM ObjectTypeR
	WHERE ObjectTypeName = 'Segment'
	
	IF (@objTypeID IS NULL)
		SET @objTypeID = 139

	INSERT INTO ModulesR (ModuleId, ModuleName, ObjectTypeId, Active)
	VALUES(@SegmentModuleID, 'SegmentSecurity', @objTypeID, 1)

	INSERT INTO ModulesR (ModuleId, ModuleName, ObjectTypeId, Active)
	VALUES(@ApplicationModuleID, 'ApplicationSecurity', @objTypeID, 1)
	
-- 2. ActionTypeR

	-- synonym admin
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(1, 'SynonymMigration')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(2, 'SynonymMigration_Reconcile')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(3, 'SynonymDetails')
	
	-- synonym detail retire action
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(4, 'SynonymDetail_RetireSynonyms')

	-- synonym approval
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(5, 'SynonymApproval')

	-- reclassification
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(6, 'CodingReclassification')

	-- impact analysis
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(7, 'MigrateStudy')
	
	-- task page
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(8, 'Task_EditWorkflowVariables')

	-- security page
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(9, 'WorkflowRoleManagement')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(10, 'UserWorkflowRoleManagement')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(11, 'RoleManagement')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(12, 'UserRoleManagement')

	
	-- Configuration
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(13, 'ConfigurationEditVersionDefaults')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(14, 'ConfigurationBasic')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(15, 'ConfigurationEditDictionaryDefaults')

	-- CodingHistoryReport
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(16, 'CodingHistoryReport')
	
	-- CodingTaskReport
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(17, 'CodingTaskReport')
	
	-- impact analysis
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(18, 'EditStudyIncludeKeep')

	-- study history
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(19, 'StudyVersionHistory')

	-- impact analysis view
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(20, 'ImpactAnalysisView')
	
	-- synonymadmin view
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(21, 'SynonymAdminView')

	INSERT INTO ActionTypeR (ActionType, Name) VALUES(22, 'ViewConfiguration')
	INSERT INTO ActionTypeR (ActionType, Name) VALUES(23, 'ViewWorkflowPages')

	INSERT INTO ActionTypeR (ActionType, Name) VALUES(24, 'ViewTransmitCodingResponse')


	INSERT INTO ActionTypeR (ActionType, Name) VALUES(25, 'CanAccessMedidataAdminConsole')


-- 3. ActionGroup
SET IDENTITY_INSERT ActionGroup ON
	INSERT INTO ActionGroup (ActionGroupID, OID) VALUES(1, 'ALL')
SET IDENTITY_INSERT ActionGroup OFF
-- 4. ModuleActions

	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 1, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 2, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 3, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 4, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 5, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 6, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 7, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 18, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 19, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 20, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 21, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@DictionaryModuleID, 17, 1)


	-- security pages
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 9, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 10, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 11, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 12, 1)

	-- configuration
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 13, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 14, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 15, 1)
	
	-- coding task report
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 17, 1)

	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 19, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 6, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 7, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 18, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 20, 1)

	-- edit workflow variables in task page
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 8, 1)
	
	-- coding history report
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@StudyModuleID, 16, 1)

	-- view config and workflow
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 22, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 23, 1)
	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@SegmentModuleID, 24, 1)

	INSERT INTO ModuleActions (ModuleID, ActionType, ActionGroupId) VALUES(@ApplicationModuleID, 25, 1)
	
GO

--exec spSetupSuperUser 'SegmentAdmin', 'SegmentAdmin', 2, 'eng', 'cdm1'
 