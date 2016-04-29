/*******************************************************************************************************
 *	THIS IS AN AUTO-GENERATED FILE.  
 *  DO NOT ALTER OR YOUR CHANGES WILL BE LOST.
 *******************************************************************************************************/

using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.CodeDom.Compiler;
using Medidata.Dapper;

namespace Coder.DeclarativeBrowser.Db {

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class CommandExtensions
    {
        public static spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse  Execute(this IDbConnection connection, spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spActivateSynonymListForDictionaryVersionLocaleSegmentCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spAgeSynonymCreationDateCommandResponse  Execute(this IDbConnection connection, spAgeSynonymCreationDateCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spAgeSynonymCreationDateCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spConfigurationCloneCommandResponse  Execute(this IDbConnection connection, spConfigurationCloneCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spConfigurationCloneCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spCreateSynonymListCommandResponse  Execute(this IDbConnection connection, spCreateSynonymListCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spCreateSynonymListCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spCreateWorkFlowRoleCommandResponse  Execute(this IDbConnection connection, spCreateWorkFlowRoleCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spCreateWorkFlowRoleCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spCreationDateAgingByCodingElementUUIDCommandResponse  Execute(this IDbConnection connection, spCreationDateAgingByCodingElementUUIDCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spCreationDateAgingByCodingElementUUIDCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spDeleteDoNotAutoCodeTermsCommandResponse  Execute(this IDbConnection connection, spDeleteDoNotAutoCodeTermsCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spDeleteDoNotAutoCodeTermsCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spDeleteGeneralRoleCommandResponse  Execute(this IDbConnection connection, spDeleteGeneralRoleCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spDeleteGeneralRoleCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spDeleteGeneratedUserCommandResponse  Execute(this IDbConnection connection, spDeleteGeneratedUserCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spDeleteGeneratedUserCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spDeleteWorkFlowRoleCommandResponse  Execute(this IDbConnection connection, spDeleteWorkFlowRoleCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spDeleteWorkFlowRoleCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spDictionaryLicenceInformationInsertCommandResponse  Execute(this IDbConnection connection, spDictionaryLicenceInformationInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spDictionaryLicenceInformationInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spDictionarySegmentConfigurationInsertCommandResponse  Execute(this IDbConnection connection, spDictionarySegmentConfigurationInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spDictionarySegmentConfigurationInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spDoProjectRegistrationCommandResponse  Execute(this IDbConnection connection, spDoProjectRegistrationCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spDoProjectRegistrationCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spFakeStudyMigrationFailureCommandResponse  Execute(this IDbConnection connection, spFakeStudyMigrationFailureCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spFakeStudyMigrationFailureCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetCurrentCodingElementCommandResponse  Execute(this IDbConnection connection, spGetCurrentCodingElementCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetCurrentCodingElementCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetDictionaryAndVersionsCommandResponse  Execute(this IDbConnection connection, spGetDictionaryAndVersionsCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetDictionaryAndVersionsCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetQueryUUIDByCodingElementUUIDCommandResponse  Execute(this IDbConnection connection, spGetQueryUUIDByCodingElementUUIDCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetQueryUUIDByCodingElementUUIDCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetRolesManagementSetupDataCommandResponse  Execute(this IDbConnection connection, spGetRolesManagementSetupDataCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetRolesManagementSetupDataCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetSegmentSetupDataByUserNameCommandResponse  Execute(this IDbConnection connection, spGetSegmentSetupDataByUserNameCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetSegmentSetupDataByUserNameCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetSourceSystemApplicationDataCommandResponse  Execute(this IDbConnection connection, spGetSourceSystemApplicationDataCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetSourceSystemApplicationDataCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetStudyDataByProjectCommandResponse  Execute(this IDbConnection connection, spGetStudyDataByProjectCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetStudyDataByProjectCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spGetUserNameByLoginCommandResponse  Execute(this IDbConnection connection, spGetUserNameByLoginCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spGetUserNameByLoginCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spInsertDoNotAutoCodeTermsCommandResponse  Execute(this IDbConnection connection, spInsertDoNotAutoCodeTermsCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spInsertDoNotAutoCodeTermsCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spObjectSegmentInsertCommandResponse  Execute(this IDbConnection connection, spObjectSegmentInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spObjectSegmentInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spRoleActionInsertCommandResponse  Execute(this IDbConnection connection, spRoleActionInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spRoleActionInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spRoleInsertCommandResponse  Execute(this IDbConnection connection, spRoleInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spRoleInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spRuntimeLockDeleteCommandResponse  Execute(this IDbConnection connection, spRuntimeLockDeleteCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spRuntimeLockDeleteCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spRuntimeLockInsertCommandResponse  Execute(this IDbConnection connection, spRuntimeLockInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spRuntimeLockInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spSegmentGetByIMedidataIdCommandResponse  Execute(this IDbConnection connection, spSegmentGetByIMedidataIdCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spSegmentGetByIMedidataIdCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spSegmentInsertCommandResponse  Execute(this IDbConnection connection, spSegmentInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spSegmentInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spSetupDefaultConfigurationCommandResponse  Execute(this IDbConnection connection, spSetupDefaultConfigurationCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spSetupDefaultConfigurationCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spSetupGranularDefaultConfigurationCommandResponse  Execute(this IDbConnection connection, spSetupGranularDefaultConfigurationCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spSetupGranularDefaultConfigurationCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spStudyProjectInsertCommandResponse  Execute(this IDbConnection connection, spStudyProjectInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spStudyProjectInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spTrackableObjectInsertCommandResponse  Execute(this IDbConnection connection, spTrackableObjectInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spTrackableObjectInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spUserGetByIMedidataIdCommandResponse  Execute(this IDbConnection connection, spUserGetByIMedidataIdCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spUserGetByIMedidataIdCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spUserInsertCommandResponse  Execute(this IDbConnection connection, spUserInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spUserInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spUserObjectRoleInsertCommandResponse  Execute(this IDbConnection connection, spUserObjectRoleInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spUserObjectRoleInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spUserObjectWorkflowRoleInsertCommandResponse  Execute(this IDbConnection connection, spUserObjectWorkflowRoleInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spUserObjectWorkflowRoleInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spWorkflowRoleActionInsertCommandResponse  Execute(this IDbConnection connection, spWorkflowRoleActionInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spWorkflowRoleActionInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

        public static spWorkflowRoleInsertCommandResponse  Execute(this IDbConnection connection, spWorkflowRoleInsertCommandRequest request, Int32? commandTimeout = null)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            var command = new spWorkflowRoleInsertCommand(connection, commandTimeout);
            var result = command.Execute(request);
            return result;
        }

    }
}
