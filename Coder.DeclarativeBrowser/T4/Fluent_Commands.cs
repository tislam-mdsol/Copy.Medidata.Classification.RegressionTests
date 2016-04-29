
/*******************************************************************************************************
 *	THIS IS AN AUTO-GENERATED FILE.  
 *  DO NOT ALTER OR YOUR CHANGES WILL BE LOST.
 *******************************************************************************************************/
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Medidata;
using Dapper;
using System.CodeDom.Compiler;
using Medidata.Dapper;

namespace Coder.DeclarativeBrowser.Db 
{
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderDbCommands
    {
            /// <summary>
        /// Executes the specified spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse</returns>
        spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse Request(spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest request);

        spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse spActivateSynonymListForDictionaryVersionLocaleSegment
        (
            String pMedicalDictionaryVersionLocaleKey ,
            String pSegment ,
            String pSynonymListName 
        );

        /// <summary>
        /// Executes the specified spAgeSynonymCreationDateCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spAgeSynonymCreationDateCommandResponse</returns>
        spAgeSynonymCreationDateCommandResponse Request(spAgeSynonymCreationDateCommandRequest request);

        spAgeSynonymCreationDateCommandResponse spAgeSynonymCreationDate
        (
            String pSegmentName ,
            String pVerbatimText ,
            Int32? pHoursToAge ,
            Boolean? pAgeCreatedOnly 
        );

        /// <summary>
        /// Executes the specified spConfigurationCloneCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spConfigurationCloneCommandResponse</returns>
        spConfigurationCloneCommandResponse Request(spConfigurationCloneCommandRequest request);

        spConfigurationCloneCommandResponse spConfigurationClone
        (
            Int32? pNewSegmentID ,
            Int32? pTemplateSegmentID 
        );

        /// <summary>
        /// Executes the specified spCreateSynonymListCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateSynonymListCommandResponse</returns>
        spCreateSynonymListCommandResponse Request(spCreateSynonymListCommandRequest request);

        spCreateSynonymListCommandResponse spCreateSynonymList
        (
            String pSegment ,
            String pMedicalDictionaryVersionLocaleKey ,
            String pSynonymListName 
        );

        /// <summary>
        /// Executes the specified spCreateWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateWorkFlowRoleCommandResponse</returns>
        spCreateWorkFlowRoleCommandResponse Request(spCreateWorkFlowRoleCommandRequest request);

        spCreateWorkFlowRoleCommandResponse spCreateWorkFlowRole
        (
            String pRoleName ,
            String pSegmentName 
        );

        /// <summary>
        /// Executes the specified spCreationDateAgingByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreationDateAgingByCodingElementUUIDCommandResponse</returns>
        spCreationDateAgingByCodingElementUUIDCommandResponse Request(spCreationDateAgingByCodingElementUUIDCommandRequest request);

        spCreationDateAgingByCodingElementUUIDCommandResponse spCreationDateAgingByCodingElementUUID
        (
            String pcodingElementUUID ,
            Int32? phoursToAge 
        );

        /// <summary>
        /// Executes the specified spDeleteDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteDoNotAutoCodeTermsCommandResponse</returns>
        spDeleteDoNotAutoCodeTermsCommandResponse Request(spDeleteDoNotAutoCodeTermsCommandRequest request);

        spDeleteDoNotAutoCodeTermsCommandResponse spDeleteDoNotAutoCodeTerms
        (
            String pSegmentName ,
            String pDictionaryList 
        );

        /// <summary>
        /// Executes the specified spDeleteGeneralRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneralRoleCommandResponse</returns>
        spDeleteGeneralRoleCommandResponse Request(spDeleteGeneralRoleCommandRequest request);

        spDeleteGeneralRoleCommandResponse spDeleteGeneralRole
        (
            String pRoleName ,
            String pSegmentName 
        );

        /// <summary>
        /// Executes the specified spDeleteGeneratedUserCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneratedUserCommandResponse</returns>
        spDeleteGeneratedUserCommandResponse Request(spDeleteGeneratedUserCommandRequest request);

        spDeleteGeneratedUserCommandResponse spDeleteGeneratedUser
        (
            Int32? pSegmentId ,
            String pUsername 
        );

        /// <summary>
        /// Executes the specified spDeleteWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteWorkFlowRoleCommandResponse</returns>
        spDeleteWorkFlowRoleCommandResponse Request(spDeleteWorkFlowRoleCommandRequest request);

        spDeleteWorkFlowRoleCommandResponse spDeleteWorkFlowRole
        (
            String pRoleName ,
            String pSegmentName 
        );

        /// <summary>
        /// Executes the specified spDictionaryLicenceInformationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionaryLicenceInformationInsertCommandResponse</returns>
        spDictionaryLicenceInformationInsertCommandResponse Request(spDictionaryLicenceInformationInsertCommandRequest request);

        spDictionaryLicenceInformationInsertCommandResponse spDictionaryLicenceInformationInsert
        (
            Boolean? pDeleted ,
            Int32? pUserID ,
            DateTime? pStartLicenceDate ,
            DateTime? pEndLicenceDate ,
            String pLicenceCode ,
            String pDictionaryLocale ,
            Int32? pSegmentID ,
            String pMedicalDictionaryKey ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pDictionaryLicenceInformationID 
        );

        /// <summary>
        /// Executes the specified spDictionarySegmentConfigurationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionarySegmentConfigurationInsertCommandResponse</returns>
        spDictionarySegmentConfigurationInsertCommandResponse Request(spDictionarySegmentConfigurationInsertCommandRequest request);

        spDictionarySegmentConfigurationInsertCommandResponse spDictionarySegmentConfigurationInsert
        (
            Int32? pSegmentId ,
            String pMedicalDictionaryKey ,
            Int32? pUserId ,
            Int32? pMaxNumberofSearchResults ,
            Boolean? pIsAutoAddSynonym ,
            Boolean? pIsAutoApproval ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pDictionarySegmentConfigurationId 
        );

        /// <summary>
        /// Executes the specified spDoProjectRegistrationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDoProjectRegistrationCommandResponse</returns>
        spDoProjectRegistrationCommandResponse Request(spDoProjectRegistrationCommandRequest request);

        spDoProjectRegistrationCommandResponse spDoProjectRegistration
        (
            String pProject ,
            String pSegment ,
            String pMedicalDictionaryVersionLocaleKey ,
            String pSynonymListName ,
            String pDictionaryRegistration 
        );

        /// <summary>
        /// Executes the specified spFakeStudyMigrationFailureCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spFakeStudyMigrationFailureCommandResponse</returns>
        spFakeStudyMigrationFailureCommandResponse Request(spFakeStudyMigrationFailureCommandRequest request);

        spFakeStudyMigrationFailureCommandResponse spFakeStudyMigrationFailure
        (
            String pUserLogin ,
            String pSegmentName ,
            String pStudyName ,
            String pFromSynonymListName ,
            String pToSynonymListName ,
            String pFromMedicalDictionaryVersionLocaleKey ,
            String pToMedicalDictionaryVersionLocaleKey 
        );

        /// <summary>
        /// Executes the specified spGetCurrentCodingElementCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetCurrentCodingElementCommandResponse</returns>
        spGetCurrentCodingElementCommandResponse Request(spGetCurrentCodingElementCommandRequest request);

        spGetCurrentCodingElementCommandResponse spGetCurrentCodingElement
        (
            String pSegment 
        );

        /// <summary>
        /// Executes the specified spGetDictionaryAndVersionsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetDictionaryAndVersionsCommandResponse</returns>
        spGetDictionaryAndVersionsCommandResponse Request(spGetDictionaryAndVersionsCommandRequest request);

        spGetDictionaryAndVersionsCommandResponse spGetDictionaryAndVersions
        (
        );

        /// <summary>
        /// Executes the specified spGetQueryUUIDByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetQueryUUIDByCodingElementUUIDCommandResponse</returns>
        spGetQueryUUIDByCodingElementUUIDCommandResponse Request(spGetQueryUUIDByCodingElementUUIDCommandRequest request);

        spGetQueryUUIDByCodingElementUUIDCommandResponse spGetQueryUUIDByCodingElementUUID
        (
            String pcodingElementUUID 
        );

        /// <summary>
        /// Executes the specified spGetRolesManagementSetupDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetRolesManagementSetupDataCommandResponse</returns>
        spGetRolesManagementSetupDataCommandResponse Request(spGetRolesManagementSetupDataCommandRequest request);

        spGetRolesManagementSetupDataCommandResponse spGetRolesManagementSetupData
        (
            String pUserName 
        );

        /// <summary>
        /// Executes the specified spGetSegmentSetupDataByUserNameCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSegmentSetupDataByUserNameCommandResponse</returns>
        spGetSegmentSetupDataByUserNameCommandResponse Request(spGetSegmentSetupDataByUserNameCommandRequest request);

        spGetSegmentSetupDataByUserNameCommandResponse spGetSegmentSetupDataByUserName
        (
            String pUserName ,
            Boolean? pIsProductionStudy 
        );

        /// <summary>
        /// Executes the specified spGetSourceSystemApplicationDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSourceSystemApplicationDataCommandResponse</returns>
        spGetSourceSystemApplicationDataCommandResponse Request(spGetSourceSystemApplicationDataCommandRequest request);

        spGetSourceSystemApplicationDataCommandResponse spGetSourceSystemApplicationData
        (
            String pApplicationName 
        );

        /// <summary>
        /// Executes the specified spGetStudyDataByProjectCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetStudyDataByProjectCommandResponse</returns>
        spGetStudyDataByProjectCommandResponse Request(spGetStudyDataByProjectCommandRequest request);

        spGetStudyDataByProjectCommandResponse spGetStudyDataByProject
        (
            String pSegmentName ,
            String pProjectName 
        );

        /// <summary>
        /// Executes the specified spGetUserNameByLoginCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetUserNameByLoginCommandResponse</returns>
        spGetUserNameByLoginCommandResponse Request(spGetUserNameByLoginCommandRequest request);

        spGetUserNameByLoginCommandResponse spGetUserNameByLogin
        (
            String pLogin 
        );

        /// <summary>
        /// Executes the specified spInsertDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spInsertDoNotAutoCodeTermsCommandResponse</returns>
        spInsertDoNotAutoCodeTermsCommandResponse Request(spInsertDoNotAutoCodeTermsCommandRequest request);

        spInsertDoNotAutoCodeTermsCommandResponse spInsertDoNotAutoCodeTerms
        (
            String pSegmentName ,
            String pDictionaryList ,
            String pTerm ,
            String pDictionary ,
            String pLevel ,
            String pLogin 
        );

        /// <summary>
        /// Executes the specified spObjectSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spObjectSegmentInsertCommandResponse</returns>
        spObjectSegmentInsertCommandResponse Request(spObjectSegmentInsertCommandRequest request);

        spObjectSegmentInsertCommandResponse spObjectSegmentInsert
        (
            Int32? pObjectID ,
            Int32? pObjectTypeId ,
            Int32? pSegmentId ,
            Boolean? pReadonly ,
            Boolean? pDefaultSegment ,
            Boolean? pDeleted ,
            Int64? pObjectSegmentID ,
            DateTime? pCreated ,
            DateTime? pUpdated 
        );

        /// <summary>
        /// Executes the specified spRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleActionInsertCommandResponse</returns>
        spRoleActionInsertCommandResponse Request(spRoleActionInsertCommandRequest request);

        spRoleActionInsertCommandResponse spRoleActionInsert
        (
            Int32? pRoleID ,
            Int32? pModuleActionId ,
            Int32? pSegmentID ,
            Int32? pRoleActionID 
        );

        /// <summary>
        /// Executes the specified spRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleInsertCommandResponse</returns>
        spRoleInsertCommandResponse Request(spRoleInsertCommandRequest request);

        spRoleInsertCommandResponse spRoleInsert
        (
            Boolean? pActive ,
            String pRoleName ,
            Int32? pModuleId ,
            Int32? pSegmentID ,
            Int32? pRoleID 
        );

        /// <summary>
        /// Executes the specified spRuntimeLockDeleteCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockDeleteCommandResponse</returns>
        spRuntimeLockDeleteCommandResponse Request(spRuntimeLockDeleteCommandRequest request);

        spRuntimeLockDeleteCommandResponse spRuntimeLockDelete
        (
            String plockKey 
        );

        /// <summary>
        /// Executes the specified spRuntimeLockInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockInsertCommandResponse</returns>
        spRuntimeLockInsertCommandResponse Request(spRuntimeLockInsertCommandRequest request);

        spRuntimeLockInsertCommandResponse spRuntimeLockInsert
        (
            String plockKey ,
            Int32? pexpireInSeconds ,
            Boolean? pLockSuccess 
        );

        /// <summary>
        /// Executes the specified spSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSegmentInsertCommandResponse</returns>
        spSegmentInsertCommandResponse Request(spSegmentInsertCommandRequest request);

        spSegmentInsertCommandResponse spSegmentInsert
        (
            String pOID ,
            Boolean? pDeleted ,
            Boolean? pActive ,
            String pSegmentName ,
            Boolean? pUserDeactivated ,
            String pIMedidataId ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pSegmentID 
        );

        /// <summary>
        /// Executes the specified spSetupDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupDefaultConfigurationCommandResponse</returns>
        spSetupDefaultConfigurationCommandResponse Request(spSetupDefaultConfigurationCommandRequest request);

        spSetupDefaultConfigurationCommandResponse spSetupDefaultConfiguration
        (
            String pSegmentOID ,
            String pJDrugOID 
        );

        /// <summary>
        /// Executes the specified spSetupGranularDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupGranularDefaultConfigurationCommandResponse</returns>
        spSetupGranularDefaultConfigurationCommandResponse Request(spSetupGranularDefaultConfigurationCommandRequest request);

        spSetupGranularDefaultConfigurationCommandResponse spSetupGranularDefaultConfiguration
        (
            String pSegmentOID ,
            String pDefaultLocale ,
            String pCodingTaskPageSize ,
            String pForcePrimaryPathSelection ,
            String pSearchLimitReclassificationResult ,
            String pSynonymCreationPolicyFlag ,
            String pBypassReconsiderUponReclassifyFlag ,
            String pDictOID ,
            String pIsAutoAddSynonym ,
            String pIsAutoApproval ,
            String pMaxNumberofSearchResults 
        );

        /// <summary>
        /// Executes the specified spStudyProjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spStudyProjectInsertCommandResponse</returns>
        spStudyProjectInsertCommandResponse Request(spStudyProjectInsertCommandRequest request);

        spStudyProjectInsertCommandResponse spStudyProjectInsert
        (
            Int64? pStudyProjectId ,
            String pProjectName ,
            String piMedidataId ,
            Int32? pSegmentID ,
            DateTime? pCreated ,
            DateTime? pUpdated 
        );

        /// <summary>
        /// Executes the specified spTrackableObjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spTrackableObjectInsertCommandResponse</returns>
        spTrackableObjectInsertCommandResponse Request(spTrackableObjectInsertCommandRequest request);

        spTrackableObjectInsertCommandResponse spTrackableObjectInsert
        (
            Int64? pTrackableObjectID ,
            Int64? pExternalObjectTypeId ,
            String pExternalObjectId ,
            String pExternalObjectOID ,
            String pExternalObjectName ,
            String pProtocolName ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pExternalObjectNameId ,
            Int32? pTaskCounter ,
            Boolean? pIsTestStudy ,
            Int32? pStudyProjectID ,
            String pAuditStudyGroupUUID ,
            DateTime? pSourceUpdatedAt ,
            Int32? pSegmentId 
        );

        /// <summary>
        /// Executes the specified spUserInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserInsertCommandResponse</returns>
        spUserInsertCommandResponse Request(spUserInsertCommandRequest request);

        spUserInsertCommandResponse spUserInsert
        (
            String pFirstName ,
            String pLastName ,
            String pEmail ,
            String pLogin ,
            String pTimeZoneInfo ,
            String pIMedidataId ,
            String pLocale ,
            Boolean? pActive ,
            Int32? pUserID 
        );

        /// <summary>
        /// Executes the specified spUserObjectRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectRoleInsertCommandResponse</returns>
        spUserObjectRoleInsertCommandResponse Request(spUserObjectRoleInsertCommandRequest request);

        spUserObjectRoleInsertCommandResponse spUserObjectRoleInsert
        (
            Int32? pGrantToObjectId ,
            String pGrantOnObjectKey ,
            Int32? pRoleID ,
            Boolean? pActive ,
            Boolean? pDenyObjectRole ,
            Int32? pSegmentID ,
            Int32? pUserObjectRoleId 
        );

        /// <summary>
        /// Executes the specified spUserObjectWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectWorkflowRoleInsertCommandResponse</returns>
        spUserObjectWorkflowRoleInsertCommandResponse Request(spUserObjectWorkflowRoleInsertCommandRequest request);

        spUserObjectWorkflowRoleInsertCommandResponse spUserObjectWorkflowRoleInsert
        (
            Int64? pGrantToObjectID ,
            Int64? pGrantOnObjectID ,
            Int64? pWorkflowRoleID ,
            Boolean? pActive ,
            Boolean? pDenyObjectRole ,
            Int64? pUserObjectWorkflowRoleID ,
            Int32? pSegmentId 
        );

        /// <summary>
        /// Executes the specified spWorkflowRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleActionInsertCommandResponse</returns>
        spWorkflowRoleActionInsertCommandResponse Request(spWorkflowRoleActionInsertCommandRequest request);

        spWorkflowRoleActionInsertCommandResponse spWorkflowRoleActionInsert
        (
            Int64? pWorkflowRoleId ,
            Int32? pWorkflowActionId ,
            Int32? pSegmentId ,
            Int64? pWorkflowRoleActionID ,
            DateTime? pCreated ,
            DateTime? pUpdated 
        );

        /// <summary>
        /// Executes the specified spWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleInsertCommandResponse</returns>
        spWorkflowRoleInsertCommandResponse Request(spWorkflowRoleInsertCommandRequest request);

        spWorkflowRoleInsertCommandResponse spWorkflowRoleInsert
        (
            String pRoleName ,
            Byte? pModuleId ,
            Boolean? pActive ,
            Int32? pWorkflowRoleID ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pSegmentId 
        );

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal abstract class CoderDbCommandsBase:ICoderDbCommands
    {
        /// <summary>
        /// Executes the specified spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse</returns>
        public abstract spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse Request(spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest request);

        public spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse spActivateSynonymListForDictionaryVersionLocaleSegment
        (
            String pMedicalDictionaryVersionLocaleKey ,
            String pSegment ,
            String pSynonymListName 
        )
        {
            var request = new spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest
            {
                    MedicalDictionaryVersionLocaleKey = pMedicalDictionaryVersionLocaleKey,
                    Segment = pSegment,
                    SynonymListName = pSynonymListName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spAgeSynonymCreationDateCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spAgeSynonymCreationDateCommandResponse</returns>
        public abstract spAgeSynonymCreationDateCommandResponse Request(spAgeSynonymCreationDateCommandRequest request);

        public spAgeSynonymCreationDateCommandResponse spAgeSynonymCreationDate
        (
            String pSegmentName ,
            String pVerbatimText ,
            Int32? pHoursToAge ,
            Boolean? pAgeCreatedOnly 
        )
        {
            var request = new spAgeSynonymCreationDateCommandRequest
            {
                    SegmentName = pSegmentName,
                    VerbatimText = pVerbatimText,
                    HoursToAge = pHoursToAge,
                    AgeCreatedOnly = pAgeCreatedOnly,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spConfigurationCloneCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spConfigurationCloneCommandResponse</returns>
        public abstract spConfigurationCloneCommandResponse Request(spConfigurationCloneCommandRequest request);

        public spConfigurationCloneCommandResponse spConfigurationClone
        (
            Int32? pNewSegmentID ,
            Int32? pTemplateSegmentID 
        )
        {
            var request = new spConfigurationCloneCommandRequest
            {
                    NewSegmentID = pNewSegmentID,
                    TemplateSegmentID = pTemplateSegmentID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spCreateSynonymListCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateSynonymListCommandResponse</returns>
        public abstract spCreateSynonymListCommandResponse Request(spCreateSynonymListCommandRequest request);

        public spCreateSynonymListCommandResponse spCreateSynonymList
        (
            String pSegment ,
            String pMedicalDictionaryVersionLocaleKey ,
            String pSynonymListName 
        )
        {
            var request = new spCreateSynonymListCommandRequest
            {
                    Segment = pSegment,
                    MedicalDictionaryVersionLocaleKey = pMedicalDictionaryVersionLocaleKey,
                    SynonymListName = pSynonymListName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spCreateWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateWorkFlowRoleCommandResponse</returns>
        public abstract spCreateWorkFlowRoleCommandResponse Request(spCreateWorkFlowRoleCommandRequest request);

        public spCreateWorkFlowRoleCommandResponse spCreateWorkFlowRole
        (
            String pRoleName ,
            String pSegmentName 
        )
        {
            var request = new spCreateWorkFlowRoleCommandRequest
            {
                    RoleName = pRoleName,
                    SegmentName = pSegmentName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spCreationDateAgingByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreationDateAgingByCodingElementUUIDCommandResponse</returns>
        public abstract spCreationDateAgingByCodingElementUUIDCommandResponse Request(spCreationDateAgingByCodingElementUUIDCommandRequest request);

        public spCreationDateAgingByCodingElementUUIDCommandResponse spCreationDateAgingByCodingElementUUID
        (
            String pcodingElementUUID ,
            Int32? phoursToAge 
        )
        {
            var request = new spCreationDateAgingByCodingElementUUIDCommandRequest
            {
                    codingElementUUID = pcodingElementUUID,
                    hoursToAge = phoursToAge,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteDoNotAutoCodeTermsCommandResponse</returns>
        public abstract spDeleteDoNotAutoCodeTermsCommandResponse Request(spDeleteDoNotAutoCodeTermsCommandRequest request);

        public spDeleteDoNotAutoCodeTermsCommandResponse spDeleteDoNotAutoCodeTerms
        (
            String pSegmentName ,
            String pDictionaryList 
        )
        {
            var request = new spDeleteDoNotAutoCodeTermsCommandRequest
            {
                    SegmentName = pSegmentName,
                    DictionaryList = pDictionaryList,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteGeneralRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneralRoleCommandResponse</returns>
        public abstract spDeleteGeneralRoleCommandResponse Request(spDeleteGeneralRoleCommandRequest request);

        public spDeleteGeneralRoleCommandResponse spDeleteGeneralRole
        (
            String pRoleName ,
            String pSegmentName 
        )
        {
            var request = new spDeleteGeneralRoleCommandRequest
            {
                    RoleName = pRoleName,
                    SegmentName = pSegmentName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteGeneratedUserCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneratedUserCommandResponse</returns>
        public abstract spDeleteGeneratedUserCommandResponse Request(spDeleteGeneratedUserCommandRequest request);

        public spDeleteGeneratedUserCommandResponse spDeleteGeneratedUser
        (
            Int32? pSegmentId ,
            String pUsername 
        )
        {
            var request = new spDeleteGeneratedUserCommandRequest
            {
                    SegmentId = pSegmentId,
                    Username = pUsername,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteWorkFlowRoleCommandResponse</returns>
        public abstract spDeleteWorkFlowRoleCommandResponse Request(spDeleteWorkFlowRoleCommandRequest request);

        public spDeleteWorkFlowRoleCommandResponse spDeleteWorkFlowRole
        (
            String pRoleName ,
            String pSegmentName 
        )
        {
            var request = new spDeleteWorkFlowRoleCommandRequest
            {
                    RoleName = pRoleName,
                    SegmentName = pSegmentName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spDictionaryLicenceInformationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionaryLicenceInformationInsertCommandResponse</returns>
        public abstract spDictionaryLicenceInformationInsertCommandResponse Request(spDictionaryLicenceInformationInsertCommandRequest request);

        public spDictionaryLicenceInformationInsertCommandResponse spDictionaryLicenceInformationInsert
        (
            Boolean? pDeleted ,
            Int32? pUserID ,
            DateTime? pStartLicenceDate ,
            DateTime? pEndLicenceDate ,
            String pLicenceCode ,
            String pDictionaryLocale ,
            Int32? pSegmentID ,
            String pMedicalDictionaryKey ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pDictionaryLicenceInformationID 
        )
        {
            var request = new spDictionaryLicenceInformationInsertCommandRequest
            {
                    Deleted = pDeleted,
                    UserID = pUserID,
                    StartLicenceDate = pStartLicenceDate,
                    EndLicenceDate = pEndLicenceDate,
                    LicenceCode = pLicenceCode,
                    DictionaryLocale = pDictionaryLocale,
                    SegmentID = pSegmentID,
                    MedicalDictionaryKey = pMedicalDictionaryKey,
                    Created = pCreated,
                    Updated = pUpdated,
                    DictionaryLicenceInformationID = pDictionaryLicenceInformationID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spDictionarySegmentConfigurationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionarySegmentConfigurationInsertCommandResponse</returns>
        public abstract spDictionarySegmentConfigurationInsertCommandResponse Request(spDictionarySegmentConfigurationInsertCommandRequest request);

        public spDictionarySegmentConfigurationInsertCommandResponse spDictionarySegmentConfigurationInsert
        (
            Int32? pSegmentId ,
            String pMedicalDictionaryKey ,
            Int32? pUserId ,
            Int32? pMaxNumberofSearchResults ,
            Boolean? pIsAutoAddSynonym ,
            Boolean? pIsAutoApproval ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pDictionarySegmentConfigurationId 
        )
        {
            var request = new spDictionarySegmentConfigurationInsertCommandRequest
            {
                    SegmentId = pSegmentId,
                    MedicalDictionaryKey = pMedicalDictionaryKey,
                    UserId = pUserId,
                    MaxNumberofSearchResults = pMaxNumberofSearchResults,
                    IsAutoAddSynonym = pIsAutoAddSynonym,
                    IsAutoApproval = pIsAutoApproval,
                    Created = pCreated,
                    Updated = pUpdated,
                    DictionarySegmentConfigurationId = pDictionarySegmentConfigurationId,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spDoProjectRegistrationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDoProjectRegistrationCommandResponse</returns>
        public abstract spDoProjectRegistrationCommandResponse Request(spDoProjectRegistrationCommandRequest request);

        public spDoProjectRegistrationCommandResponse spDoProjectRegistration
        (
            String pProject ,
            String pSegment ,
            String pMedicalDictionaryVersionLocaleKey ,
            String pSynonymListName ,
            String pDictionaryRegistration 
        )
        {
            var request = new spDoProjectRegistrationCommandRequest
            {
                    Project = pProject,
                    Segment = pSegment,
                    MedicalDictionaryVersionLocaleKey = pMedicalDictionaryVersionLocaleKey,
                    SynonymListName = pSynonymListName,
                    DictionaryRegistration = pDictionaryRegistration,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spFakeStudyMigrationFailureCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spFakeStudyMigrationFailureCommandResponse</returns>
        public abstract spFakeStudyMigrationFailureCommandResponse Request(spFakeStudyMigrationFailureCommandRequest request);

        public spFakeStudyMigrationFailureCommandResponse spFakeStudyMigrationFailure
        (
            String pUserLogin ,
            String pSegmentName ,
            String pStudyName ,
            String pFromSynonymListName ,
            String pToSynonymListName ,
            String pFromMedicalDictionaryVersionLocaleKey ,
            String pToMedicalDictionaryVersionLocaleKey 
        )
        {
            var request = new spFakeStudyMigrationFailureCommandRequest
            {
                    UserLogin = pUserLogin,
                    SegmentName = pSegmentName,
                    StudyName = pStudyName,
                    FromSynonymListName = pFromSynonymListName,
                    ToSynonymListName = pToSynonymListName,
                    FromMedicalDictionaryVersionLocaleKey = pFromMedicalDictionaryVersionLocaleKey,
                    ToMedicalDictionaryVersionLocaleKey = pToMedicalDictionaryVersionLocaleKey,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetCurrentCodingElementCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetCurrentCodingElementCommandResponse</returns>
        public abstract spGetCurrentCodingElementCommandResponse Request(spGetCurrentCodingElementCommandRequest request);

        public spGetCurrentCodingElementCommandResponse spGetCurrentCodingElement
        (
            String pSegment 
        )
        {
            var request = new spGetCurrentCodingElementCommandRequest
            {
                    Segment = pSegment,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetDictionaryAndVersionsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetDictionaryAndVersionsCommandResponse</returns>
        public abstract spGetDictionaryAndVersionsCommandResponse Request(spGetDictionaryAndVersionsCommandRequest request);

        public spGetDictionaryAndVersionsCommandResponse spGetDictionaryAndVersions
        (
        )
        {
            var request = new spGetDictionaryAndVersionsCommandRequest
            {
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetQueryUUIDByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetQueryUUIDByCodingElementUUIDCommandResponse</returns>
        public abstract spGetQueryUUIDByCodingElementUUIDCommandResponse Request(spGetQueryUUIDByCodingElementUUIDCommandRequest request);

        public spGetQueryUUIDByCodingElementUUIDCommandResponse spGetQueryUUIDByCodingElementUUID
        (
            String pcodingElementUUID 
        )
        {
            var request = new spGetQueryUUIDByCodingElementUUIDCommandRequest
            {
                    codingElementUUID = pcodingElementUUID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetRolesManagementSetupDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetRolesManagementSetupDataCommandResponse</returns>
        public abstract spGetRolesManagementSetupDataCommandResponse Request(spGetRolesManagementSetupDataCommandRequest request);

        public spGetRolesManagementSetupDataCommandResponse spGetRolesManagementSetupData
        (
            String pUserName 
        )
        {
            var request = new spGetRolesManagementSetupDataCommandRequest
            {
                    UserName = pUserName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetSegmentSetupDataByUserNameCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSegmentSetupDataByUserNameCommandResponse</returns>
        public abstract spGetSegmentSetupDataByUserNameCommandResponse Request(spGetSegmentSetupDataByUserNameCommandRequest request);

        public spGetSegmentSetupDataByUserNameCommandResponse spGetSegmentSetupDataByUserName
        (
            String pUserName ,
            Boolean? pIsProductionStudy 
        )
        {
            var request = new spGetSegmentSetupDataByUserNameCommandRequest
            {
                    UserName = pUserName,
                    IsProductionStudy = pIsProductionStudy,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetSourceSystemApplicationDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSourceSystemApplicationDataCommandResponse</returns>
        public abstract spGetSourceSystemApplicationDataCommandResponse Request(spGetSourceSystemApplicationDataCommandRequest request);

        public spGetSourceSystemApplicationDataCommandResponse spGetSourceSystemApplicationData
        (
            String pApplicationName 
        )
        {
            var request = new spGetSourceSystemApplicationDataCommandRequest
            {
                    ApplicationName = pApplicationName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetStudyDataByProjectCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetStudyDataByProjectCommandResponse</returns>
        public abstract spGetStudyDataByProjectCommandResponse Request(spGetStudyDataByProjectCommandRequest request);

        public spGetStudyDataByProjectCommandResponse spGetStudyDataByProject
        (
            String pSegmentName ,
            String pProjectName 
        )
        {
            var request = new spGetStudyDataByProjectCommandRequest
            {
                    SegmentName = pSegmentName,
                    ProjectName = pProjectName,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetUserNameByLoginCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetUserNameByLoginCommandResponse</returns>
        public abstract spGetUserNameByLoginCommandResponse Request(spGetUserNameByLoginCommandRequest request);

        public spGetUserNameByLoginCommandResponse spGetUserNameByLogin
        (
            String pLogin 
        )
        {
            var request = new spGetUserNameByLoginCommandRequest
            {
                    Login = pLogin,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spInsertDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spInsertDoNotAutoCodeTermsCommandResponse</returns>
        public abstract spInsertDoNotAutoCodeTermsCommandResponse Request(spInsertDoNotAutoCodeTermsCommandRequest request);

        public spInsertDoNotAutoCodeTermsCommandResponse spInsertDoNotAutoCodeTerms
        (
            String pSegmentName ,
            String pDictionaryList ,
            String pTerm ,
            String pDictionary ,
            String pLevel ,
            String pLogin 
        )
        {
            var request = new spInsertDoNotAutoCodeTermsCommandRequest
            {
                    SegmentName = pSegmentName,
                    DictionaryList = pDictionaryList,
                    Term = pTerm,
                    Dictionary = pDictionary,
                    Level = pLevel,
                    Login = pLogin,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spObjectSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spObjectSegmentInsertCommandResponse</returns>
        public abstract spObjectSegmentInsertCommandResponse Request(spObjectSegmentInsertCommandRequest request);

        public spObjectSegmentInsertCommandResponse spObjectSegmentInsert
        (
            Int32? pObjectID ,
            Int32? pObjectTypeId ,
            Int32? pSegmentId ,
            Boolean? pReadonly ,
            Boolean? pDefaultSegment ,
            Boolean? pDeleted ,
            Int64? pObjectSegmentID ,
            DateTime? pCreated ,
            DateTime? pUpdated 
        )
        {
            var request = new spObjectSegmentInsertCommandRequest
            {
                    ObjectID = pObjectID,
                    ObjectTypeId = pObjectTypeId,
                    SegmentId = pSegmentId,
                    Readonly = pReadonly,
                    DefaultSegment = pDefaultSegment,
                    Deleted = pDeleted,
                    ObjectSegmentID = pObjectSegmentID,
                    Created = pCreated,
                    Updated = pUpdated,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleActionInsertCommandResponse</returns>
        public abstract spRoleActionInsertCommandResponse Request(spRoleActionInsertCommandRequest request);

        public spRoleActionInsertCommandResponse spRoleActionInsert
        (
            Int32? pRoleID ,
            Int32? pModuleActionId ,
            Int32? pSegmentID ,
            Int32? pRoleActionID 
        )
        {
            var request = new spRoleActionInsertCommandRequest
            {
                    RoleID = pRoleID,
                    ModuleActionId = pModuleActionId,
                    SegmentID = pSegmentID,
                    RoleActionID = pRoleActionID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleInsertCommandResponse</returns>
        public abstract spRoleInsertCommandResponse Request(spRoleInsertCommandRequest request);

        public spRoleInsertCommandResponse spRoleInsert
        (
            Boolean? pActive ,
            String pRoleName ,
            Int32? pModuleId ,
            Int32? pSegmentID ,
            Int32? pRoleID 
        )
        {
            var request = new spRoleInsertCommandRequest
            {
                    Active = pActive,
                    RoleName = pRoleName,
                    ModuleId = pModuleId,
                    SegmentID = pSegmentID,
                    RoleID = pRoleID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spRuntimeLockDeleteCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockDeleteCommandResponse</returns>
        public abstract spRuntimeLockDeleteCommandResponse Request(spRuntimeLockDeleteCommandRequest request);

        public spRuntimeLockDeleteCommandResponse spRuntimeLockDelete
        (
            String plockKey 
        )
        {
            var request = new spRuntimeLockDeleteCommandRequest
            {
                    lockKey = plockKey,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spRuntimeLockInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockInsertCommandResponse</returns>
        public abstract spRuntimeLockInsertCommandResponse Request(spRuntimeLockInsertCommandRequest request);

        public spRuntimeLockInsertCommandResponse spRuntimeLockInsert
        (
            String plockKey ,
            Int32? pexpireInSeconds ,
            Boolean? pLockSuccess 
        )
        {
            var request = new spRuntimeLockInsertCommandRequest
            {
                    lockKey = plockKey,
                    expireInSeconds = pexpireInSeconds,
                    LockSuccess = pLockSuccess,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSegmentInsertCommandResponse</returns>
        public abstract spSegmentInsertCommandResponse Request(spSegmentInsertCommandRequest request);

        public spSegmentInsertCommandResponse spSegmentInsert
        (
            String pOID ,
            Boolean? pDeleted ,
            Boolean? pActive ,
            String pSegmentName ,
            Boolean? pUserDeactivated ,
            String pIMedidataId ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pSegmentID 
        )
        {
            var request = new spSegmentInsertCommandRequest
            {
                    OID = pOID,
                    Deleted = pDeleted,
                    Active = pActive,
                    SegmentName = pSegmentName,
                    UserDeactivated = pUserDeactivated,
                    IMedidataId = pIMedidataId,
                    Created = pCreated,
                    Updated = pUpdated,
                    SegmentID = pSegmentID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spSetupDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupDefaultConfigurationCommandResponse</returns>
        public abstract spSetupDefaultConfigurationCommandResponse Request(spSetupDefaultConfigurationCommandRequest request);

        public spSetupDefaultConfigurationCommandResponse spSetupDefaultConfiguration
        (
            String pSegmentOID ,
            String pJDrugOID 
        )
        {
            var request = new spSetupDefaultConfigurationCommandRequest
            {
                    SegmentOID = pSegmentOID,
                    JDrugOID = pJDrugOID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spSetupGranularDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupGranularDefaultConfigurationCommandResponse</returns>
        public abstract spSetupGranularDefaultConfigurationCommandResponse Request(spSetupGranularDefaultConfigurationCommandRequest request);

        public spSetupGranularDefaultConfigurationCommandResponse spSetupGranularDefaultConfiguration
        (
            String pSegmentOID ,
            String pDefaultLocale ,
            String pCodingTaskPageSize ,
            String pForcePrimaryPathSelection ,
            String pSearchLimitReclassificationResult ,
            String pSynonymCreationPolicyFlag ,
            String pBypassReconsiderUponReclassifyFlag ,
            String pDictOID ,
            String pIsAutoAddSynonym ,
            String pIsAutoApproval ,
            String pMaxNumberofSearchResults 
        )
        {
            var request = new spSetupGranularDefaultConfigurationCommandRequest
            {
                    SegmentOID = pSegmentOID,
                    DefaultLocale = pDefaultLocale,
                    CodingTaskPageSize = pCodingTaskPageSize,
                    ForcePrimaryPathSelection = pForcePrimaryPathSelection,
                    SearchLimitReclassificationResult = pSearchLimitReclassificationResult,
                    SynonymCreationPolicyFlag = pSynonymCreationPolicyFlag,
                    BypassReconsiderUponReclassifyFlag = pBypassReconsiderUponReclassifyFlag,
                    DictOID = pDictOID,
                    IsAutoAddSynonym = pIsAutoAddSynonym,
                    IsAutoApproval = pIsAutoApproval,
                    MaxNumberofSearchResults = pMaxNumberofSearchResults,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spStudyProjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spStudyProjectInsertCommandResponse</returns>
        public abstract spStudyProjectInsertCommandResponse Request(spStudyProjectInsertCommandRequest request);

        public spStudyProjectInsertCommandResponse spStudyProjectInsert
        (
            Int64? pStudyProjectId ,
            String pProjectName ,
            String piMedidataId ,
            Int32? pSegmentID ,
            DateTime? pCreated ,
            DateTime? pUpdated 
        )
        {
            var request = new spStudyProjectInsertCommandRequest
            {
                    StudyProjectId = pStudyProjectId,
                    ProjectName = pProjectName,
                    iMedidataId = piMedidataId,
                    SegmentID = pSegmentID,
                    Created = pCreated,
                    Updated = pUpdated,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spTrackableObjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spTrackableObjectInsertCommandResponse</returns>
        public abstract spTrackableObjectInsertCommandResponse Request(spTrackableObjectInsertCommandRequest request);

        public spTrackableObjectInsertCommandResponse spTrackableObjectInsert
        (
            Int64? pTrackableObjectID ,
            Int64? pExternalObjectTypeId ,
            String pExternalObjectId ,
            String pExternalObjectOID ,
            String pExternalObjectName ,
            String pProtocolName ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pExternalObjectNameId ,
            Int32? pTaskCounter ,
            Boolean? pIsTestStudy ,
            Int32? pStudyProjectID ,
            String pAuditStudyGroupUUID ,
            DateTime? pSourceUpdatedAt ,
            Int32? pSegmentId 
        )
        {
            var request = new spTrackableObjectInsertCommandRequest
            {
                    TrackableObjectID = pTrackableObjectID,
                    ExternalObjectTypeId = pExternalObjectTypeId,
                    ExternalObjectId = pExternalObjectId,
                    ExternalObjectOID = pExternalObjectOID,
                    ExternalObjectName = pExternalObjectName,
                    ProtocolName = pProtocolName,
                    Created = pCreated,
                    Updated = pUpdated,
                    ExternalObjectNameId = pExternalObjectNameId,
                    TaskCounter = pTaskCounter,
                    IsTestStudy = pIsTestStudy,
                    StudyProjectID = pStudyProjectID,
                    AuditStudyGroupUUID = pAuditStudyGroupUUID,
                    SourceUpdatedAt = pSourceUpdatedAt,
                    SegmentId = pSegmentId,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spUserInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserInsertCommandResponse</returns>
        public abstract spUserInsertCommandResponse Request(spUserInsertCommandRequest request);

        public spUserInsertCommandResponse spUserInsert
        (
            String pFirstName ,
            String pLastName ,
            String pEmail ,
            String pLogin ,
            String pTimeZoneInfo ,
            String pIMedidataId ,
            String pLocale ,
            Boolean? pActive ,
            Int32? pUserID 
        )
        {
            var request = new spUserInsertCommandRequest
            {
                    FirstName = pFirstName,
                    LastName = pLastName,
                    Email = pEmail,
                    Login = pLogin,
                    TimeZoneInfo = pTimeZoneInfo,
                    IMedidataId = pIMedidataId,
                    Locale = pLocale,
                    Active = pActive,
                    UserID = pUserID,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spUserObjectRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectRoleInsertCommandResponse</returns>
        public abstract spUserObjectRoleInsertCommandResponse Request(spUserObjectRoleInsertCommandRequest request);

        public spUserObjectRoleInsertCommandResponse spUserObjectRoleInsert
        (
            Int32? pGrantToObjectId ,
            String pGrantOnObjectKey ,
            Int32? pRoleID ,
            Boolean? pActive ,
            Boolean? pDenyObjectRole ,
            Int32? pSegmentID ,
            Int32? pUserObjectRoleId 
        )
        {
            var request = new spUserObjectRoleInsertCommandRequest
            {
                    GrantToObjectId = pGrantToObjectId,
                    GrantOnObjectKey = pGrantOnObjectKey,
                    RoleID = pRoleID,
                    Active = pActive,
                    DenyObjectRole = pDenyObjectRole,
                    SegmentID = pSegmentID,
                    UserObjectRoleId = pUserObjectRoleId,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spUserObjectWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectWorkflowRoleInsertCommandResponse</returns>
        public abstract spUserObjectWorkflowRoleInsertCommandResponse Request(spUserObjectWorkflowRoleInsertCommandRequest request);

        public spUserObjectWorkflowRoleInsertCommandResponse spUserObjectWorkflowRoleInsert
        (
            Int64? pGrantToObjectID ,
            Int64? pGrantOnObjectID ,
            Int64? pWorkflowRoleID ,
            Boolean? pActive ,
            Boolean? pDenyObjectRole ,
            Int64? pUserObjectWorkflowRoleID ,
            Int32? pSegmentId 
        )
        {
            var request = new spUserObjectWorkflowRoleInsertCommandRequest
            {
                    GrantToObjectID = pGrantToObjectID,
                    GrantOnObjectID = pGrantOnObjectID,
                    WorkflowRoleID = pWorkflowRoleID,
                    Active = pActive,
                    DenyObjectRole = pDenyObjectRole,
                    UserObjectWorkflowRoleID = pUserObjectWorkflowRoleID,
                    SegmentId = pSegmentId,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spWorkflowRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleActionInsertCommandResponse</returns>
        public abstract spWorkflowRoleActionInsertCommandResponse Request(spWorkflowRoleActionInsertCommandRequest request);

        public spWorkflowRoleActionInsertCommandResponse spWorkflowRoleActionInsert
        (
            Int64? pWorkflowRoleId ,
            Int32? pWorkflowActionId ,
            Int32? pSegmentId ,
            Int64? pWorkflowRoleActionID ,
            DateTime? pCreated ,
            DateTime? pUpdated 
        )
        {
            var request = new spWorkflowRoleActionInsertCommandRequest
            {
                    WorkflowRoleId = pWorkflowRoleId,
                    WorkflowActionId = pWorkflowActionId,
                    SegmentId = pSegmentId,
                    WorkflowRoleActionID = pWorkflowRoleActionID,
                    Created = pCreated,
                    Updated = pUpdated,
            };

            var response = Request(request);
            return response;
        }

        /// <summary>
        /// Executes the specified spWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleInsertCommandResponse</returns>
        public abstract spWorkflowRoleInsertCommandResponse Request(spWorkflowRoleInsertCommandRequest request);

        public spWorkflowRoleInsertCommandResponse spWorkflowRoleInsert
        (
            String pRoleName ,
            Byte? pModuleId ,
            Boolean? pActive ,
            Int32? pWorkflowRoleID ,
            DateTime? pCreated ,
            DateTime? pUpdated ,
            Int32? pSegmentId 
        )
        {
            var request = new spWorkflowRoleInsertCommandRequest
            {
                    RoleName = pRoleName,
                    ModuleId = pModuleId,
                    Active = pActive,
                    WorkflowRoleID = pWorkflowRoleID,
                    Created = pCreated,
                    Updated = pUpdated,
                    SegmentId = pSegmentId,
            };

            var response = Request(request);
            return response;
        }


    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderDbCommands:CoderDbCommandsBase
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        /// <summary>
        /// Initializes a new instance of the spApplicationAdminFetchCommand class.
        /// </summary>
        /// <param name="connection"></param>
        public CoderDbCommands(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        /// <summary>
        /// Executes the specified spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse</returns>
        public override spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse Request(spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spAgeSynonymCreationDateCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spAgeSynonymCreationDateCommandResponse</returns>
        public override spAgeSynonymCreationDateCommandResponse Request(spAgeSynonymCreationDateCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spConfigurationCloneCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spConfigurationCloneCommandResponse</returns>
        public override spConfigurationCloneCommandResponse Request(spConfigurationCloneCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spCreateSynonymListCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateSynonymListCommandResponse</returns>
        public override spCreateSynonymListCommandResponse Request(spCreateSynonymListCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spCreateWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateWorkFlowRoleCommandResponse</returns>
        public override spCreateWorkFlowRoleCommandResponse Request(spCreateWorkFlowRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spCreationDateAgingByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreationDateAgingByCodingElementUUIDCommandResponse</returns>
        public override spCreationDateAgingByCodingElementUUIDCommandResponse Request(spCreationDateAgingByCodingElementUUIDCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteDoNotAutoCodeTermsCommandResponse</returns>
        public override spDeleteDoNotAutoCodeTermsCommandResponse Request(spDeleteDoNotAutoCodeTermsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteGeneralRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneralRoleCommandResponse</returns>
        public override spDeleteGeneralRoleCommandResponse Request(spDeleteGeneralRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteGeneratedUserCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneratedUserCommandResponse</returns>
        public override spDeleteGeneratedUserCommandResponse Request(spDeleteGeneratedUserCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spDeleteWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteWorkFlowRoleCommandResponse</returns>
        public override spDeleteWorkFlowRoleCommandResponse Request(spDeleteWorkFlowRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spDictionaryLicenceInformationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionaryLicenceInformationInsertCommandResponse</returns>
        public override spDictionaryLicenceInformationInsertCommandResponse Request(spDictionaryLicenceInformationInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spDictionarySegmentConfigurationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionarySegmentConfigurationInsertCommandResponse</returns>
        public override spDictionarySegmentConfigurationInsertCommandResponse Request(spDictionarySegmentConfigurationInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spDoProjectRegistrationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDoProjectRegistrationCommandResponse</returns>
        public override spDoProjectRegistrationCommandResponse Request(spDoProjectRegistrationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spFakeStudyMigrationFailureCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spFakeStudyMigrationFailureCommandResponse</returns>
        public override spFakeStudyMigrationFailureCommandResponse Request(spFakeStudyMigrationFailureCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetCurrentCodingElementCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetCurrentCodingElementCommandResponse</returns>
        public override spGetCurrentCodingElementCommandResponse Request(spGetCurrentCodingElementCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetDictionaryAndVersionsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetDictionaryAndVersionsCommandResponse</returns>
        public override spGetDictionaryAndVersionsCommandResponse Request(spGetDictionaryAndVersionsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetQueryUUIDByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetQueryUUIDByCodingElementUUIDCommandResponse</returns>
        public override spGetQueryUUIDByCodingElementUUIDCommandResponse Request(spGetQueryUUIDByCodingElementUUIDCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetRolesManagementSetupDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetRolesManagementSetupDataCommandResponse</returns>
        public override spGetRolesManagementSetupDataCommandResponse Request(spGetRolesManagementSetupDataCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetSegmentSetupDataByUserNameCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSegmentSetupDataByUserNameCommandResponse</returns>
        public override spGetSegmentSetupDataByUserNameCommandResponse Request(spGetSegmentSetupDataByUserNameCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetSourceSystemApplicationDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSourceSystemApplicationDataCommandResponse</returns>
        public override spGetSourceSystemApplicationDataCommandResponse Request(spGetSourceSystemApplicationDataCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetStudyDataByProjectCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetStudyDataByProjectCommandResponse</returns>
        public override spGetStudyDataByProjectCommandResponse Request(spGetStudyDataByProjectCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spGetUserNameByLoginCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetUserNameByLoginCommandResponse</returns>
        public override spGetUserNameByLoginCommandResponse Request(spGetUserNameByLoginCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spInsertDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spInsertDoNotAutoCodeTermsCommandResponse</returns>
        public override spInsertDoNotAutoCodeTermsCommandResponse Request(spInsertDoNotAutoCodeTermsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spObjectSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spObjectSegmentInsertCommandResponse</returns>
        public override spObjectSegmentInsertCommandResponse Request(spObjectSegmentInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleActionInsertCommandResponse</returns>
        public override spRoleActionInsertCommandResponse Request(spRoleActionInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleInsertCommandResponse</returns>
        public override spRoleInsertCommandResponse Request(spRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spRuntimeLockDeleteCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockDeleteCommandResponse</returns>
        public override spRuntimeLockDeleteCommandResponse Request(spRuntimeLockDeleteCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spRuntimeLockInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockInsertCommandResponse</returns>
        public override spRuntimeLockInsertCommandResponse Request(spRuntimeLockInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSegmentInsertCommandResponse</returns>
        public override spSegmentInsertCommandResponse Request(spSegmentInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spSetupDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupDefaultConfigurationCommandResponse</returns>
        public override spSetupDefaultConfigurationCommandResponse Request(spSetupDefaultConfigurationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spSetupGranularDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupGranularDefaultConfigurationCommandResponse</returns>
        public override spSetupGranularDefaultConfigurationCommandResponse Request(spSetupGranularDefaultConfigurationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spStudyProjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spStudyProjectInsertCommandResponse</returns>
        public override spStudyProjectInsertCommandResponse Request(spStudyProjectInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spTrackableObjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spTrackableObjectInsertCommandResponse</returns>
        public override spTrackableObjectInsertCommandResponse Request(spTrackableObjectInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spUserInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserInsertCommandResponse</returns>
        public override spUserInsertCommandResponse Request(spUserInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spUserObjectRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectRoleInsertCommandResponse</returns>
        public override spUserObjectRoleInsertCommandResponse Request(spUserObjectRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spUserObjectWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectWorkflowRoleInsertCommandResponse</returns>
        public override spUserObjectWorkflowRoleInsertCommandResponse Request(spUserObjectWorkflowRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spWorkflowRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleActionInsertCommandResponse</returns>
        public override spWorkflowRoleActionInsertCommandResponse Request(spWorkflowRoleActionInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }

        /// <summary>
        /// Executes the specified spWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleInsertCommandResponse</returns>
        public override spWorkflowRoleInsertCommandResponse Request(spWorkflowRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var response = _Connection.Execute(request, _CommandTimeout);
            return response;
        }


    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderDbCommandsTester:CoderDbCommandsBase
    {

        public Func<spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest, spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse> spActivateSynonymListForDictionaryVersionLocaleSegmentBehavior { get; set; }

        /// <summary>
        /// Executes the specified spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse</returns>
        public override spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse Request(spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spActivateSynonymListForDictionaryVersionLocaleSegmentBehavior, null))
                return null;

            var response = spActivateSynonymListForDictionaryVersionLocaleSegmentBehavior(request);
            return response;
        }


        public Func<spAgeSynonymCreationDateCommandRequest, spAgeSynonymCreationDateCommandResponse> spAgeSynonymCreationDateBehavior { get; set; }

        /// <summary>
        /// Executes the specified spAgeSynonymCreationDateCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spAgeSynonymCreationDateCommandResponse</returns>
        public override spAgeSynonymCreationDateCommandResponse Request(spAgeSynonymCreationDateCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spAgeSynonymCreationDateBehavior, null))
                return null;

            var response = spAgeSynonymCreationDateBehavior(request);
            return response;
        }


        public Func<spConfigurationCloneCommandRequest, spConfigurationCloneCommandResponse> spConfigurationCloneBehavior { get; set; }

        /// <summary>
        /// Executes the specified spConfigurationCloneCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spConfigurationCloneCommandResponse</returns>
        public override spConfigurationCloneCommandResponse Request(spConfigurationCloneCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spConfigurationCloneBehavior, null))
                return null;

            var response = spConfigurationCloneBehavior(request);
            return response;
        }


        public Func<spCreateSynonymListCommandRequest, spCreateSynonymListCommandResponse> spCreateSynonymListBehavior { get; set; }

        /// <summary>
        /// Executes the specified spCreateSynonymListCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateSynonymListCommandResponse</returns>
        public override spCreateSynonymListCommandResponse Request(spCreateSynonymListCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spCreateSynonymListBehavior, null))
                return null;

            var response = spCreateSynonymListBehavior(request);
            return response;
        }


        public Func<spCreateWorkFlowRoleCommandRequest, spCreateWorkFlowRoleCommandResponse> spCreateWorkFlowRoleBehavior { get; set; }

        /// <summary>
        /// Executes the specified spCreateWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreateWorkFlowRoleCommandResponse</returns>
        public override spCreateWorkFlowRoleCommandResponse Request(spCreateWorkFlowRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spCreateWorkFlowRoleBehavior, null))
                return null;

            var response = spCreateWorkFlowRoleBehavior(request);
            return response;
        }


        public Func<spCreationDateAgingByCodingElementUUIDCommandRequest, spCreationDateAgingByCodingElementUUIDCommandResponse> spCreationDateAgingByCodingElementUUIDBehavior { get; set; }

        /// <summary>
        /// Executes the specified spCreationDateAgingByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spCreationDateAgingByCodingElementUUIDCommandResponse</returns>
        public override spCreationDateAgingByCodingElementUUIDCommandResponse Request(spCreationDateAgingByCodingElementUUIDCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spCreationDateAgingByCodingElementUUIDBehavior, null))
                return null;

            var response = spCreationDateAgingByCodingElementUUIDBehavior(request);
            return response;
        }


        public Func<spDeleteDoNotAutoCodeTermsCommandRequest, spDeleteDoNotAutoCodeTermsCommandResponse> spDeleteDoNotAutoCodeTermsBehavior { get; set; }

        /// <summary>
        /// Executes the specified spDeleteDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteDoNotAutoCodeTermsCommandResponse</returns>
        public override spDeleteDoNotAutoCodeTermsCommandResponse Request(spDeleteDoNotAutoCodeTermsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spDeleteDoNotAutoCodeTermsBehavior, null))
                return null;

            var response = spDeleteDoNotAutoCodeTermsBehavior(request);
            return response;
        }


        public Func<spDeleteGeneralRoleCommandRequest, spDeleteGeneralRoleCommandResponse> spDeleteGeneralRoleBehavior { get; set; }

        /// <summary>
        /// Executes the specified spDeleteGeneralRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneralRoleCommandResponse</returns>
        public override spDeleteGeneralRoleCommandResponse Request(spDeleteGeneralRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spDeleteGeneralRoleBehavior, null))
                return null;

            var response = spDeleteGeneralRoleBehavior(request);
            return response;
        }


        public Func<spDeleteGeneratedUserCommandRequest, spDeleteGeneratedUserCommandResponse> spDeleteGeneratedUserBehavior { get; set; }

        /// <summary>
        /// Executes the specified spDeleteGeneratedUserCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteGeneratedUserCommandResponse</returns>
        public override spDeleteGeneratedUserCommandResponse Request(spDeleteGeneratedUserCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spDeleteGeneratedUserBehavior, null))
                return null;

            var response = spDeleteGeneratedUserBehavior(request);
            return response;
        }


        public Func<spDeleteWorkFlowRoleCommandRequest, spDeleteWorkFlowRoleCommandResponse> spDeleteWorkFlowRoleBehavior { get; set; }

        /// <summary>
        /// Executes the specified spDeleteWorkFlowRoleCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDeleteWorkFlowRoleCommandResponse</returns>
        public override spDeleteWorkFlowRoleCommandResponse Request(spDeleteWorkFlowRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spDeleteWorkFlowRoleBehavior, null))
                return null;

            var response = spDeleteWorkFlowRoleBehavior(request);
            return response;
        }


        public Func<spDictionaryLicenceInformationInsertCommandRequest, spDictionaryLicenceInformationInsertCommandResponse> spDictionaryLicenceInformationInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spDictionaryLicenceInformationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionaryLicenceInformationInsertCommandResponse</returns>
        public override spDictionaryLicenceInformationInsertCommandResponse Request(spDictionaryLicenceInformationInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spDictionaryLicenceInformationInsertBehavior, null))
                return null;

            var response = spDictionaryLicenceInformationInsertBehavior(request);
            return response;
        }


        public Func<spDictionarySegmentConfigurationInsertCommandRequest, spDictionarySegmentConfigurationInsertCommandResponse> spDictionarySegmentConfigurationInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spDictionarySegmentConfigurationInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDictionarySegmentConfigurationInsertCommandResponse</returns>
        public override spDictionarySegmentConfigurationInsertCommandResponse Request(spDictionarySegmentConfigurationInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spDictionarySegmentConfigurationInsertBehavior, null))
                return null;

            var response = spDictionarySegmentConfigurationInsertBehavior(request);
            return response;
        }


        public Func<spDoProjectRegistrationCommandRequest, spDoProjectRegistrationCommandResponse> spDoProjectRegistrationBehavior { get; set; }

        /// <summary>
        /// Executes the specified spDoProjectRegistrationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spDoProjectRegistrationCommandResponse</returns>
        public override spDoProjectRegistrationCommandResponse Request(spDoProjectRegistrationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spDoProjectRegistrationBehavior, null))
                return null;

            var response = spDoProjectRegistrationBehavior(request);
            return response;
        }


        public Func<spFakeStudyMigrationFailureCommandRequest, spFakeStudyMigrationFailureCommandResponse> spFakeStudyMigrationFailureBehavior { get; set; }

        /// <summary>
        /// Executes the specified spFakeStudyMigrationFailureCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spFakeStudyMigrationFailureCommandResponse</returns>
        public override spFakeStudyMigrationFailureCommandResponse Request(spFakeStudyMigrationFailureCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spFakeStudyMigrationFailureBehavior, null))
                return null;

            var response = spFakeStudyMigrationFailureBehavior(request);
            return response;
        }


        public Func<spGetCurrentCodingElementCommandRequest, spGetCurrentCodingElementCommandResponse> spGetCurrentCodingElementBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetCurrentCodingElementCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetCurrentCodingElementCommandResponse</returns>
        public override spGetCurrentCodingElementCommandResponse Request(spGetCurrentCodingElementCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetCurrentCodingElementBehavior, null))
                return null;

            var response = spGetCurrentCodingElementBehavior(request);
            return response;
        }


        public Func<spGetDictionaryAndVersionsCommandRequest, spGetDictionaryAndVersionsCommandResponse> spGetDictionaryAndVersionsBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetDictionaryAndVersionsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetDictionaryAndVersionsCommandResponse</returns>
        public override spGetDictionaryAndVersionsCommandResponse Request(spGetDictionaryAndVersionsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetDictionaryAndVersionsBehavior, null))
                return null;

            var response = spGetDictionaryAndVersionsBehavior(request);
            return response;
        }


        public Func<spGetQueryUUIDByCodingElementUUIDCommandRequest, spGetQueryUUIDByCodingElementUUIDCommandResponse> spGetQueryUUIDByCodingElementUUIDBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetQueryUUIDByCodingElementUUIDCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetQueryUUIDByCodingElementUUIDCommandResponse</returns>
        public override spGetQueryUUIDByCodingElementUUIDCommandResponse Request(spGetQueryUUIDByCodingElementUUIDCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetQueryUUIDByCodingElementUUIDBehavior, null))
                return null;

            var response = spGetQueryUUIDByCodingElementUUIDBehavior(request);
            return response;
        }


        public Func<spGetRolesManagementSetupDataCommandRequest, spGetRolesManagementSetupDataCommandResponse> spGetRolesManagementSetupDataBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetRolesManagementSetupDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetRolesManagementSetupDataCommandResponse</returns>
        public override spGetRolesManagementSetupDataCommandResponse Request(spGetRolesManagementSetupDataCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetRolesManagementSetupDataBehavior, null))
                return null;

            var response = spGetRolesManagementSetupDataBehavior(request);
            return response;
        }


        public Func<spGetSegmentSetupDataByUserNameCommandRequest, spGetSegmentSetupDataByUserNameCommandResponse> spGetSegmentSetupDataByUserNameBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetSegmentSetupDataByUserNameCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSegmentSetupDataByUserNameCommandResponse</returns>
        public override spGetSegmentSetupDataByUserNameCommandResponse Request(spGetSegmentSetupDataByUserNameCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetSegmentSetupDataByUserNameBehavior, null))
                return null;

            var response = spGetSegmentSetupDataByUserNameBehavior(request);
            return response;
        }


        public Func<spGetSourceSystemApplicationDataCommandRequest, spGetSourceSystemApplicationDataCommandResponse> spGetSourceSystemApplicationDataBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetSourceSystemApplicationDataCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetSourceSystemApplicationDataCommandResponse</returns>
        public override spGetSourceSystemApplicationDataCommandResponse Request(spGetSourceSystemApplicationDataCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetSourceSystemApplicationDataBehavior, null))
                return null;

            var response = spGetSourceSystemApplicationDataBehavior(request);
            return response;
        }


        public Func<spGetStudyDataByProjectCommandRequest, spGetStudyDataByProjectCommandResponse> spGetStudyDataByProjectBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetStudyDataByProjectCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetStudyDataByProjectCommandResponse</returns>
        public override spGetStudyDataByProjectCommandResponse Request(spGetStudyDataByProjectCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetStudyDataByProjectBehavior, null))
                return null;

            var response = spGetStudyDataByProjectBehavior(request);
            return response;
        }


        public Func<spGetUserNameByLoginCommandRequest, spGetUserNameByLoginCommandResponse> spGetUserNameByLoginBehavior { get; set; }

        /// <summary>
        /// Executes the specified spGetUserNameByLoginCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spGetUserNameByLoginCommandResponse</returns>
        public override spGetUserNameByLoginCommandResponse Request(spGetUserNameByLoginCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spGetUserNameByLoginBehavior, null))
                return null;

            var response = spGetUserNameByLoginBehavior(request);
            return response;
        }


        public Func<spInsertDoNotAutoCodeTermsCommandRequest, spInsertDoNotAutoCodeTermsCommandResponse> spInsertDoNotAutoCodeTermsBehavior { get; set; }

        /// <summary>
        /// Executes the specified spInsertDoNotAutoCodeTermsCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spInsertDoNotAutoCodeTermsCommandResponse</returns>
        public override spInsertDoNotAutoCodeTermsCommandResponse Request(spInsertDoNotAutoCodeTermsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spInsertDoNotAutoCodeTermsBehavior, null))
                return null;

            var response = spInsertDoNotAutoCodeTermsBehavior(request);
            return response;
        }


        public Func<spObjectSegmentInsertCommandRequest, spObjectSegmentInsertCommandResponse> spObjectSegmentInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spObjectSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spObjectSegmentInsertCommandResponse</returns>
        public override spObjectSegmentInsertCommandResponse Request(spObjectSegmentInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spObjectSegmentInsertBehavior, null))
                return null;

            var response = spObjectSegmentInsertBehavior(request);
            return response;
        }


        public Func<spRoleActionInsertCommandRequest, spRoleActionInsertCommandResponse> spRoleActionInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleActionInsertCommandResponse</returns>
        public override spRoleActionInsertCommandResponse Request(spRoleActionInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spRoleActionInsertBehavior, null))
                return null;

            var response = spRoleActionInsertBehavior(request);
            return response;
        }


        public Func<spRoleInsertCommandRequest, spRoleInsertCommandResponse> spRoleInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRoleInsertCommandResponse</returns>
        public override spRoleInsertCommandResponse Request(spRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spRoleInsertBehavior, null))
                return null;

            var response = spRoleInsertBehavior(request);
            return response;
        }


        public Func<spRuntimeLockDeleteCommandRequest, spRuntimeLockDeleteCommandResponse> spRuntimeLockDeleteBehavior { get; set; }

        /// <summary>
        /// Executes the specified spRuntimeLockDeleteCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockDeleteCommandResponse</returns>
        public override spRuntimeLockDeleteCommandResponse Request(spRuntimeLockDeleteCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spRuntimeLockDeleteBehavior, null))
                return null;

            var response = spRuntimeLockDeleteBehavior(request);
            return response;
        }


        public Func<spRuntimeLockInsertCommandRequest, spRuntimeLockInsertCommandResponse> spRuntimeLockInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spRuntimeLockInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spRuntimeLockInsertCommandResponse</returns>
        public override spRuntimeLockInsertCommandResponse Request(spRuntimeLockInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spRuntimeLockInsertBehavior, null))
                return null;

            var response = spRuntimeLockInsertBehavior(request);
            return response;
        }


        public Func<spSegmentInsertCommandRequest, spSegmentInsertCommandResponse> spSegmentInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spSegmentInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSegmentInsertCommandResponse</returns>
        public override spSegmentInsertCommandResponse Request(spSegmentInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spSegmentInsertBehavior, null))
                return null;

            var response = spSegmentInsertBehavior(request);
            return response;
        }


        public Func<spSetupDefaultConfigurationCommandRequest, spSetupDefaultConfigurationCommandResponse> spSetupDefaultConfigurationBehavior { get; set; }

        /// <summary>
        /// Executes the specified spSetupDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupDefaultConfigurationCommandResponse</returns>
        public override spSetupDefaultConfigurationCommandResponse Request(spSetupDefaultConfigurationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spSetupDefaultConfigurationBehavior, null))
                return null;

            var response = spSetupDefaultConfigurationBehavior(request);
            return response;
        }


        public Func<spSetupGranularDefaultConfigurationCommandRequest, spSetupGranularDefaultConfigurationCommandResponse> spSetupGranularDefaultConfigurationBehavior { get; set; }

        /// <summary>
        /// Executes the specified spSetupGranularDefaultConfigurationCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spSetupGranularDefaultConfigurationCommandResponse</returns>
        public override spSetupGranularDefaultConfigurationCommandResponse Request(spSetupGranularDefaultConfigurationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spSetupGranularDefaultConfigurationBehavior, null))
                return null;

            var response = spSetupGranularDefaultConfigurationBehavior(request);
            return response;
        }


        public Func<spStudyProjectInsertCommandRequest, spStudyProjectInsertCommandResponse> spStudyProjectInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spStudyProjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spStudyProjectInsertCommandResponse</returns>
        public override spStudyProjectInsertCommandResponse Request(spStudyProjectInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spStudyProjectInsertBehavior, null))
                return null;

            var response = spStudyProjectInsertBehavior(request);
            return response;
        }


        public Func<spTrackableObjectInsertCommandRequest, spTrackableObjectInsertCommandResponse> spTrackableObjectInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spTrackableObjectInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spTrackableObjectInsertCommandResponse</returns>
        public override spTrackableObjectInsertCommandResponse Request(spTrackableObjectInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spTrackableObjectInsertBehavior, null))
                return null;

            var response = spTrackableObjectInsertBehavior(request);
            return response;
        }


        public Func<spUserInsertCommandRequest, spUserInsertCommandResponse> spUserInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spUserInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserInsertCommandResponse</returns>
        public override spUserInsertCommandResponse Request(spUserInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spUserInsertBehavior, null))
                return null;

            var response = spUserInsertBehavior(request);
            return response;
        }


        public Func<spUserObjectRoleInsertCommandRequest, spUserObjectRoleInsertCommandResponse> spUserObjectRoleInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spUserObjectRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectRoleInsertCommandResponse</returns>
        public override spUserObjectRoleInsertCommandResponse Request(spUserObjectRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spUserObjectRoleInsertBehavior, null))
                return null;

            var response = spUserObjectRoleInsertBehavior(request);
            return response;
        }


        public Func<spUserObjectWorkflowRoleInsertCommandRequest, spUserObjectWorkflowRoleInsertCommandResponse> spUserObjectWorkflowRoleInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spUserObjectWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spUserObjectWorkflowRoleInsertCommandResponse</returns>
        public override spUserObjectWorkflowRoleInsertCommandResponse Request(spUserObjectWorkflowRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spUserObjectWorkflowRoleInsertBehavior, null))
                return null;

            var response = spUserObjectWorkflowRoleInsertBehavior(request);
            return response;
        }


        public Func<spWorkflowRoleActionInsertCommandRequest, spWorkflowRoleActionInsertCommandResponse> spWorkflowRoleActionInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spWorkflowRoleActionInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleActionInsertCommandResponse</returns>
        public override spWorkflowRoleActionInsertCommandResponse Request(spWorkflowRoleActionInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spWorkflowRoleActionInsertBehavior, null))
                return null;

            var response = spWorkflowRoleActionInsertBehavior(request);
            return response;
        }


        public Func<spWorkflowRoleInsertCommandRequest, spWorkflowRoleInsertCommandResponse> spWorkflowRoleInsertBehavior { get; set; }

        /// <summary>
        /// Executes the specified spWorkflowRoleInsertCommandRequest.
        /// </summary>
        /// <param name="request">The request.</param>
        /// <returns>The spWorkflowRoleInsertCommandResponse</returns>
        public override spWorkflowRoleInsertCommandResponse Request(spWorkflowRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");


            if(ReferenceEquals(spWorkflowRoleInsertBehavior, null))
                return null;

            var response = spWorkflowRoleInsertBehavior(request);
            return response;
        }


    }
}
