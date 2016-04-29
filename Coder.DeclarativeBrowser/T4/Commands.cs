


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
using Medidata.Dapper;
using Dapper;
using System.CodeDom.Compiler;

namespace Coder.DeclarativeBrowser.Db {


    #region  spActivateSynonymListForDictionaryVersionLocaleSegment

    #region  spActivateSynonymListForDictionaryVersionLocaleSegment Command
    
    /// <summary>
    /// A class which represents the spActivateSynonymListForDictionaryVersionLocaleSegment procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spActivateSynonymListForDictionaryVersionLocaleSegmentCommand:ICommand<spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest, spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spActivateSynonymListForDictionaryVersionLocaleSegmentCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse Execute(spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse response = new spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse();

            var p = new DynamicParameters();

            p.Add("@MedicalDictionaryVersionLocaleKey", request.MedicalDictionaryVersionLocaleKey);

            p.Add("@Segment", request.Segment);

            p.Add("@SynonymListName", request.SynonymListName);


            var data = 
                _Connection
                .Execute(
                    "spActivateSynonymListForDictionaryVersionLocaleSegment", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spActivateSynonymListForDictionaryVersionLocaleSegment Command Request
        /// <summary>
    /// A class which represents the spActivateSynonymListForDictionaryVersionLocaleSegment procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spActivateSynonymListForDictionaryVersionLocaleSegmentCommandRequest
    {
        public String MedicalDictionaryVersionLocaleKey { get ; set; }
        public String Segment { get ; set; }
        public String SynonymListName { get ; set; }

    }

    #endregion

    #region  spActivateSynonymListForDictionaryVersionLocaleSegment Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spActivateSynonymListForDictionaryVersionLocaleSegment procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponse
    {

    }

    #endregion

    #region spActivateSynonymListForDictionaryVersionLocaleSegment Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spActivateSynonymListForDictionaryVersionLocaleSegment procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spActivateSynonymListForDictionaryVersionLocaleSegmentCommandResponseData{}


    #endregion

    #endregion


    #region  spAgeSynonymCreationDate

    #region  spAgeSynonymCreationDate Command
    
    /// <summary>
    /// A class which represents the spAgeSynonymCreationDate procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spAgeSynonymCreationDateCommand:ICommand<spAgeSynonymCreationDateCommandRequest, spAgeSynonymCreationDateCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spAgeSynonymCreationDateCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spAgeSynonymCreationDateCommandResponse Execute(spAgeSynonymCreationDateCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spAgeSynonymCreationDateCommandResponse response = new spAgeSynonymCreationDateCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentName", request.SegmentName);

            p.Add("@VerbatimText", request.VerbatimText);

            p.Add("@HoursToAge", request.HoursToAge);

            p.Add("@AgeCreatedOnly", request.AgeCreatedOnly);


            var data = 
                _Connection
                .Execute(
                    "spAgeSynonymCreationDate", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spAgeSynonymCreationDate Command Request
        /// <summary>
    /// A class which represents the spAgeSynonymCreationDate procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spAgeSynonymCreationDateCommandRequest
    {
        public String SegmentName { get ; set; }
        public String VerbatimText { get ; set; }
        public Int32? HoursToAge { get ; set; }
        public Boolean? AgeCreatedOnly { get ; set; }

    }

    #endregion

    #region  spAgeSynonymCreationDate Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spAgeSynonymCreationDate procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spAgeSynonymCreationDateCommandResponse
    {

    }

    #endregion

    #region spAgeSynonymCreationDate Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spAgeSynonymCreationDate procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spAgeSynonymCreationDateCommandResponseData{}


    #endregion

    #endregion


    #region  spConfigurationClone

    #region  spConfigurationClone Command
    
    /// <summary>
    /// A class which represents the spConfigurationClone procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spConfigurationCloneCommand:ICommand<spConfigurationCloneCommandRequest, spConfigurationCloneCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spConfigurationCloneCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spConfigurationCloneCommandResponse Execute(spConfigurationCloneCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spConfigurationCloneCommandResponse response = new spConfigurationCloneCommandResponse();

            var p = new DynamicParameters();

            p.Add("@NewSegmentID", request.NewSegmentID);

            p.Add("@TemplateSegmentID", request.TemplateSegmentID);


            var data = 
                _Connection
                .Execute(
                    "spConfigurationClone", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spConfigurationClone Command Request
        /// <summary>
    /// A class which represents the spConfigurationClone procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spConfigurationCloneCommandRequest
    {
        public Int32? NewSegmentID { get ; set; }
        public Int32? TemplateSegmentID { get ; set; }

    }

    #endregion

    #region  spConfigurationClone Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spConfigurationClone procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spConfigurationCloneCommandResponse
    {

    }

    #endregion

    #region spConfigurationClone Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spConfigurationClone procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spConfigurationCloneCommandResponseData{}


    #endregion

    #endregion


    #region  spCreateSynonymList

    #region  spCreateSynonymList Command
    
    /// <summary>
    /// A class which represents the spCreateSynonymList procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateSynonymListCommand:ICommand<spCreateSynonymListCommandRequest, spCreateSynonymListCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spCreateSynonymListCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spCreateSynonymListCommandResponse Execute(spCreateSynonymListCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spCreateSynonymListCommandResponse response = new spCreateSynonymListCommandResponse();

            var p = new DynamicParameters();

            p.Add("@Segment", request.Segment);

            p.Add("@MedicalDictionaryVersionLocaleKey", request.MedicalDictionaryVersionLocaleKey);

            p.Add("@SynonymListName", request.SynonymListName);


            var data = 
                _Connection
                .Execute(
                    "spCreateSynonymList", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spCreateSynonymList Command Request
        /// <summary>
    /// A class which represents the spCreateSynonymList procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateSynonymListCommandRequest
    {
        public String Segment { get ; set; }
        public String MedicalDictionaryVersionLocaleKey { get ; set; }
        public String SynonymListName { get ; set; }

    }

    #endregion

    #region  spCreateSynonymList Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spCreateSynonymList procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateSynonymListCommandResponse
    {

    }

    #endregion

    #region spCreateSynonymList Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spCreateSynonymList procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateSynonymListCommandResponseData{}


    #endregion

    #endregion


    #region  spCreateWorkFlowRole

    #region  spCreateWorkFlowRole Command
    
    /// <summary>
    /// A class which represents the spCreateWorkFlowRole procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateWorkFlowRoleCommand:ICommand<spCreateWorkFlowRoleCommandRequest, spCreateWorkFlowRoleCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spCreateWorkFlowRoleCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spCreateWorkFlowRoleCommandResponse Execute(spCreateWorkFlowRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spCreateWorkFlowRoleCommandResponse response = new spCreateWorkFlowRoleCommandResponse();

            var p = new DynamicParameters();

            p.Add("@RoleName", request.RoleName);

            p.Add("@SegmentName", request.SegmentName);


            var data = 
                _Connection
                .Execute(
                    "spCreateWorkFlowRole", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spCreateWorkFlowRole Command Request
        /// <summary>
    /// A class which represents the spCreateWorkFlowRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateWorkFlowRoleCommandRequest
    {
        public String RoleName { get ; set; }
        public String SegmentName { get ; set; }

    }

    #endregion

    #region  spCreateWorkFlowRole Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spCreateWorkFlowRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateWorkFlowRoleCommandResponse
    {

    }

    #endregion

    #region spCreateWorkFlowRole Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spCreateWorkFlowRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreateWorkFlowRoleCommandResponseData{}


    #endregion

    #endregion


    #region  spCreationDateAgingByCodingElementUUID

    #region  spCreationDateAgingByCodingElementUUID Command
    
    /// <summary>
    /// A class which represents the spCreationDateAgingByCodingElementUUID procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreationDateAgingByCodingElementUUIDCommand:ICommand<spCreationDateAgingByCodingElementUUIDCommandRequest, spCreationDateAgingByCodingElementUUIDCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spCreationDateAgingByCodingElementUUIDCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spCreationDateAgingByCodingElementUUIDCommandResponse Execute(spCreationDateAgingByCodingElementUUIDCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spCreationDateAgingByCodingElementUUIDCommandResponse response = new spCreationDateAgingByCodingElementUUIDCommandResponse();

            var p = new DynamicParameters();

            p.Add("@codingElementUUID", request.codingElementUUID);

            p.Add("@hoursToAge", request.hoursToAge);


            var data = 
                _Connection
                .Execute(
                    "spCreationDateAgingByCodingElementUUID", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spCreationDateAgingByCodingElementUUID Command Request
        /// <summary>
    /// A class which represents the spCreationDateAgingByCodingElementUUID procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreationDateAgingByCodingElementUUIDCommandRequest
    {
        public String codingElementUUID { get ; set; }
        public Int32? hoursToAge { get ; set; }

    }

    #endregion

    #region  spCreationDateAgingByCodingElementUUID Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spCreationDateAgingByCodingElementUUID procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreationDateAgingByCodingElementUUIDCommandResponse
    {

    }

    #endregion

    #region spCreationDateAgingByCodingElementUUID Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spCreationDateAgingByCodingElementUUID procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spCreationDateAgingByCodingElementUUIDCommandResponseData{}


    #endregion

    #endregion


    #region  spDeleteDoNotAutoCodeTerms

    #region  spDeleteDoNotAutoCodeTerms Command
    
    /// <summary>
    /// A class which represents the spDeleteDoNotAutoCodeTerms procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteDoNotAutoCodeTermsCommand:ICommand<spDeleteDoNotAutoCodeTermsCommandRequest, spDeleteDoNotAutoCodeTermsCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spDeleteDoNotAutoCodeTermsCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spDeleteDoNotAutoCodeTermsCommandResponse Execute(spDeleteDoNotAutoCodeTermsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spDeleteDoNotAutoCodeTermsCommandResponse response = new spDeleteDoNotAutoCodeTermsCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentName", request.SegmentName);

            p.Add("@DictionaryList", request.DictionaryList);


            var data = 
                _Connection
                .Execute(
                    "spDeleteDoNotAutoCodeTerms", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spDeleteDoNotAutoCodeTerms Command Request
        /// <summary>
    /// A class which represents the spDeleteDoNotAutoCodeTerms procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteDoNotAutoCodeTermsCommandRequest
    {
        public String SegmentName { get ; set; }
        public String DictionaryList { get ; set; }

    }

    #endregion

    #region  spDeleteDoNotAutoCodeTerms Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spDeleteDoNotAutoCodeTerms procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteDoNotAutoCodeTermsCommandResponse
    {

    }

    #endregion

    #region spDeleteDoNotAutoCodeTerms Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spDeleteDoNotAutoCodeTerms procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteDoNotAutoCodeTermsCommandResponseData{}


    #endregion

    #endregion


    #region  spDeleteGeneralRole

    #region  spDeleteGeneralRole Command
    
    /// <summary>
    /// A class which represents the spDeleteGeneralRole procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneralRoleCommand:ICommand<spDeleteGeneralRoleCommandRequest, spDeleteGeneralRoleCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spDeleteGeneralRoleCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spDeleteGeneralRoleCommandResponse Execute(spDeleteGeneralRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spDeleteGeneralRoleCommandResponse response = new spDeleteGeneralRoleCommandResponse();

            var p = new DynamicParameters();

            p.Add("@RoleName", request.RoleName);

            p.Add("@SegmentName", request.SegmentName);


            var data = 
                _Connection
                .Execute(
                    "spDeleteGeneralRole", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spDeleteGeneralRole Command Request
        /// <summary>
    /// A class which represents the spDeleteGeneralRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneralRoleCommandRequest
    {
        public String RoleName { get ; set; }
        public String SegmentName { get ; set; }

    }

    #endregion

    #region  spDeleteGeneralRole Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spDeleteGeneralRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneralRoleCommandResponse
    {

    }

    #endregion

    #region spDeleteGeneralRole Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spDeleteGeneralRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneralRoleCommandResponseData{}


    #endregion

    #endregion


    #region  spDeleteGeneratedUser

    #region  spDeleteGeneratedUser Command
    
    /// <summary>
    /// A class which represents the spDeleteGeneratedUser procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneratedUserCommand:ICommand<spDeleteGeneratedUserCommandRequest, spDeleteGeneratedUserCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spDeleteGeneratedUserCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spDeleteGeneratedUserCommandResponse Execute(spDeleteGeneratedUserCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spDeleteGeneratedUserCommandResponse response = new spDeleteGeneratedUserCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentId", request.SegmentId);

            p.Add("@Username", request.Username);


            var data = 
                _Connection
                .Execute(
                    "spDeleteGeneratedUser", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spDeleteGeneratedUser Command Request
        /// <summary>
    /// A class which represents the spDeleteGeneratedUser procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneratedUserCommandRequest
    {
        public Int32? SegmentId { get ; set; }
        public String Username { get ; set; }

    }

    #endregion

    #region  spDeleteGeneratedUser Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spDeleteGeneratedUser procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneratedUserCommandResponse
    {

    }

    #endregion

    #region spDeleteGeneratedUser Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spDeleteGeneratedUser procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteGeneratedUserCommandResponseData{}


    #endregion

    #endregion


    #region  spDeleteWorkFlowRole

    #region  spDeleteWorkFlowRole Command
    
    /// <summary>
    /// A class which represents the spDeleteWorkFlowRole procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteWorkFlowRoleCommand:ICommand<spDeleteWorkFlowRoleCommandRequest, spDeleteWorkFlowRoleCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spDeleteWorkFlowRoleCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spDeleteWorkFlowRoleCommandResponse Execute(spDeleteWorkFlowRoleCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spDeleteWorkFlowRoleCommandResponse response = new spDeleteWorkFlowRoleCommandResponse();

            var p = new DynamicParameters();

            p.Add("@RoleName", request.RoleName);

            p.Add("@SegmentName", request.SegmentName);


            var data = 
                _Connection
                .Execute(
                    "spDeleteWorkFlowRole", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spDeleteWorkFlowRole Command Request
        /// <summary>
    /// A class which represents the spDeleteWorkFlowRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteWorkFlowRoleCommandRequest
    {
        public String RoleName { get ; set; }
        public String SegmentName { get ; set; }

    }

    #endregion

    #region  spDeleteWorkFlowRole Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spDeleteWorkFlowRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteWorkFlowRoleCommandResponse
    {

    }

    #endregion

    #region spDeleteWorkFlowRole Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spDeleteWorkFlowRole procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDeleteWorkFlowRoleCommandResponseData{}


    #endregion

    #endregion


    #region  spDictionaryLicenceInformationInsert

    #region  spDictionaryLicenceInformationInsert Command
    
    /// <summary>
    /// A class which represents the spDictionaryLicenceInformationInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionaryLicenceInformationInsertCommand:ICommand<spDictionaryLicenceInformationInsertCommandRequest, spDictionaryLicenceInformationInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spDictionaryLicenceInformationInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spDictionaryLicenceInformationInsertCommandResponse Execute(spDictionaryLicenceInformationInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spDictionaryLicenceInformationInsertCommandResponse response = new spDictionaryLicenceInformationInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@Deleted", request.Deleted);

            p.Add("@UserID", request.UserID);

            p.Add("@StartLicenceDate", request.StartLicenceDate);

            p.Add("@EndLicenceDate", request.EndLicenceDate);

            p.Add("@LicenceCode", request.LicenceCode);

            p.Add("@DictionaryLocale", request.DictionaryLocale);

            p.Add("@SegmentID", request.SegmentID);

            p.Add("@MedicalDictionaryKey", request.MedicalDictionaryKey);

            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@DictionaryLicenceInformationID", value: request.DictionaryLicenceInformationID, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spDictionaryLicenceInformationInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					
             response.DictionaryLicenceInformationID = p.Get<Int32?>("@DictionaryLicenceInformationID");					

            return response;
        }

    }

    #endregion

    #region  spDictionaryLicenceInformationInsert Command Request
        /// <summary>
    /// A class which represents the spDictionaryLicenceInformationInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionaryLicenceInformationInsertCommandRequest
    {
        public Boolean? Deleted { get ; set; }
        public Int32? UserID { get ; set; }
        public DateTime? StartLicenceDate { get ; set; }
        public DateTime? EndLicenceDate { get ; set; }
        public String LicenceCode { get ; set; }
        public String DictionaryLocale { get ; set; }
        public Int32? SegmentID { get ; set; }
        public String MedicalDictionaryKey { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }
        public Int32? DictionaryLicenceInformationID { get ; set; }

    }

    #endregion

    #region  spDictionaryLicenceInformationInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spDictionaryLicenceInformationInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionaryLicenceInformationInsertCommandResponse
    {
            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					

            public Int32? DictionaryLicenceInformationID{ get; set; }					


    }

    #endregion

    #region spDictionaryLicenceInformationInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spDictionaryLicenceInformationInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionaryLicenceInformationInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spDictionarySegmentConfigurationInsert

    #region  spDictionarySegmentConfigurationInsert Command
    
    /// <summary>
    /// A class which represents the spDictionarySegmentConfigurationInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionarySegmentConfigurationInsertCommand:ICommand<spDictionarySegmentConfigurationInsertCommandRequest, spDictionarySegmentConfigurationInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spDictionarySegmentConfigurationInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spDictionarySegmentConfigurationInsertCommandResponse Execute(spDictionarySegmentConfigurationInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spDictionarySegmentConfigurationInsertCommandResponse response = new spDictionarySegmentConfigurationInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentId", request.SegmentId);

            p.Add("@MedicalDictionaryKey", request.MedicalDictionaryKey);

            p.Add("@UserId", request.UserId);

            p.Add("@MaxNumberofSearchResults", request.MaxNumberofSearchResults);

            p.Add("@IsAutoAddSynonym", request.IsAutoAddSynonym);

            p.Add("@IsAutoApproval", request.IsAutoApproval);

            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@DictionarySegmentConfigurationId", value: request.DictionarySegmentConfigurationId, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spDictionarySegmentConfigurationInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					
             response.DictionarySegmentConfigurationId = p.Get<Int32?>("@DictionarySegmentConfigurationId");					

            return response;
        }

    }

    #endregion

    #region  spDictionarySegmentConfigurationInsert Command Request
        /// <summary>
    /// A class which represents the spDictionarySegmentConfigurationInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionarySegmentConfigurationInsertCommandRequest
    {
        public Int32? SegmentId { get ; set; }
        public String MedicalDictionaryKey { get ; set; }
        public Int32? UserId { get ; set; }
        public Int32? MaxNumberofSearchResults { get ; set; }
        public Boolean? IsAutoAddSynonym { get ; set; }
        public Boolean? IsAutoApproval { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }
        public Int32? DictionarySegmentConfigurationId { get ; set; }

    }

    #endregion

    #region  spDictionarySegmentConfigurationInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spDictionarySegmentConfigurationInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionarySegmentConfigurationInsertCommandResponse
    {
            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					

            public Int32? DictionarySegmentConfigurationId{ get; set; }					


    }

    #endregion

    #region spDictionarySegmentConfigurationInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spDictionarySegmentConfigurationInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDictionarySegmentConfigurationInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spDoProjectRegistration

    #region  spDoProjectRegistration Command
    
    /// <summary>
    /// A class which represents the spDoProjectRegistration procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDoProjectRegistrationCommand:ICommand<spDoProjectRegistrationCommandRequest, spDoProjectRegistrationCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spDoProjectRegistrationCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spDoProjectRegistrationCommandResponse Execute(spDoProjectRegistrationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spDoProjectRegistrationCommandResponse response = new spDoProjectRegistrationCommandResponse();

            var p = new DynamicParameters();

            p.Add("@Project", request.Project);

            p.Add("@Segment", request.Segment);

            p.Add("@MedicalDictionaryVersionLocaleKey", request.MedicalDictionaryVersionLocaleKey);

            p.Add("@SynonymListName", request.SynonymListName);

            p.Add("@DictionaryRegistration", request.DictionaryRegistration);


            var data = 
                _Connection
                .Execute(
                    "spDoProjectRegistration", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spDoProjectRegistration Command Request
        /// <summary>
    /// A class which represents the spDoProjectRegistration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDoProjectRegistrationCommandRequest
    {
        public String Project { get ; set; }
        public String Segment { get ; set; }
        public String MedicalDictionaryVersionLocaleKey { get ; set; }
        public String SynonymListName { get ; set; }
        public String DictionaryRegistration { get ; set; }

    }

    #endregion

    #region  spDoProjectRegistration Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spDoProjectRegistration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDoProjectRegistrationCommandResponse
    {

    }

    #endregion

    #region spDoProjectRegistration Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spDoProjectRegistration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spDoProjectRegistrationCommandResponseData{}


    #endregion

    #endregion


    #region  spFakeStudyMigrationFailure

    #region  spFakeStudyMigrationFailure Command
    
    /// <summary>
    /// A class which represents the spFakeStudyMigrationFailure procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spFakeStudyMigrationFailureCommand:ICommand<spFakeStudyMigrationFailureCommandRequest, spFakeStudyMigrationFailureCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spFakeStudyMigrationFailureCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spFakeStudyMigrationFailureCommandResponse Execute(spFakeStudyMigrationFailureCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spFakeStudyMigrationFailureCommandResponse response = new spFakeStudyMigrationFailureCommandResponse();

            var p = new DynamicParameters();

            p.Add("@UserLogin", request.UserLogin);

            p.Add("@SegmentName", request.SegmentName);

            p.Add("@StudyName", request.StudyName);

            p.Add("@FromSynonymListName", request.FromSynonymListName);

            p.Add("@ToSynonymListName", request.ToSynonymListName);

            p.Add("@FromMedicalDictionaryVersionLocaleKey", request.FromMedicalDictionaryVersionLocaleKey);

            p.Add("@ToMedicalDictionaryVersionLocaleKey", request.ToMedicalDictionaryVersionLocaleKey);


            var data = 
                _Connection
                .Execute(
                    "spFakeStudyMigrationFailure", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spFakeStudyMigrationFailure Command Request
        /// <summary>
    /// A class which represents the spFakeStudyMigrationFailure procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spFakeStudyMigrationFailureCommandRequest
    {
        public String UserLogin { get ; set; }
        public String SegmentName { get ; set; }
        public String StudyName { get ; set; }
        public String FromSynonymListName { get ; set; }
        public String ToSynonymListName { get ; set; }
        public String FromMedicalDictionaryVersionLocaleKey { get ; set; }
        public String ToMedicalDictionaryVersionLocaleKey { get ; set; }

    }

    #endregion

    #region  spFakeStudyMigrationFailure Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spFakeStudyMigrationFailure procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spFakeStudyMigrationFailureCommandResponse
    {

    }

    #endregion

    #region spFakeStudyMigrationFailure Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spFakeStudyMigrationFailure procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spFakeStudyMigrationFailureCommandResponseData{}


    #endregion

    #endregion


    #region  spGetCurrentCodingElement

    #region  spGetCurrentCodingElement Command
    
    /// <summary>
    /// A class which represents the spGetCurrentCodingElement procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetCurrentCodingElementCommand:ICommand<spGetCurrentCodingElementCommandRequest, spGetCurrentCodingElementCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetCurrentCodingElementCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetCurrentCodingElementCommandResponse Execute(spGetCurrentCodingElementCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetCurrentCodingElementCommandResponse response = new spGetCurrentCodingElementCommandResponse();

            var p = new DynamicParameters();

            p.Add("@Segment", request.Segment);


            var data = 
                _Connection
                .Query<spGetCurrentCodingElementCommandResponseData>(
                    "spGetCurrentCodingElement", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetCurrentCodingElement Command Request
        /// <summary>
    /// A class which represents the spGetCurrentCodingElement procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetCurrentCodingElementCommandRequest
    {
        public String Segment { get ; set; }

    }

    #endregion

    #region  spGetCurrentCodingElement Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetCurrentCodingElement procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetCurrentCodingElementCommandResponse
    {
        public IList<spGetCurrentCodingElementCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetCurrentCodingElement Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetCurrentCodingElement procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetCurrentCodingElementCommandResponseData
    {

        public DateTime? Created { get ; set; }
        public DateTime? AutoCodeDate { get ; set; }

    }


    #endregion

    #endregion


    #region  spGetDictionaryAndVersions

    #region  spGetDictionaryAndVersions Command
    
    /// <summary>
    /// A class which represents the spGetDictionaryAndVersions procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetDictionaryAndVersionsCommand:ICommand<spGetDictionaryAndVersionsCommandRequest, spGetDictionaryAndVersionsCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetDictionaryAndVersionsCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetDictionaryAndVersionsCommandResponse Execute(spGetDictionaryAndVersionsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetDictionaryAndVersionsCommandResponse response = new spGetDictionaryAndVersionsCommandResponse();

            var p = new DynamicParameters();


            var data = 
                _Connection
                .Query<spGetDictionaryAndVersionsCommandResponseData>(
                    "spGetDictionaryAndVersions", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetDictionaryAndVersions Command Request
        /// <summary>
    /// A class which represents the spGetDictionaryAndVersions procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetDictionaryAndVersionsCommandRequest
    {

    }

    #endregion

    #region  spGetDictionaryAndVersions Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetDictionaryAndVersions procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetDictionaryAndVersionsCommandResponse
    {
        public IList<spGetDictionaryAndVersionsCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetDictionaryAndVersions Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetDictionaryAndVersions procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetDictionaryAndVersionsCommandResponseData
    {

        public Int32? versionId { get ; set; }
        public Int32? dictionaryid { get ; set; }
        public String dictionaryOid { get ; set; }
        public String versionOid { get ; set; }
        public String dictionaryKey { get ; set; }
        public String dictionaryVersionKey { get ; set; }

    }


    #endregion

    #endregion


    #region  spGetQueryUUIDByCodingElementUUID

    #region  spGetQueryUUIDByCodingElementUUID Command
    
    /// <summary>
    /// A class which represents the spGetQueryUUIDByCodingElementUUID procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetQueryUUIDByCodingElementUUIDCommand:ICommand<spGetQueryUUIDByCodingElementUUIDCommandRequest, spGetQueryUUIDByCodingElementUUIDCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetQueryUUIDByCodingElementUUIDCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetQueryUUIDByCodingElementUUIDCommandResponse Execute(spGetQueryUUIDByCodingElementUUIDCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetQueryUUIDByCodingElementUUIDCommandResponse response = new spGetQueryUUIDByCodingElementUUIDCommandResponse();

            var p = new DynamicParameters();

            p.Add("@codingElementUUID", request.codingElementUUID);


            var data = 
                _Connection
                .Query<spGetQueryUUIDByCodingElementUUIDCommandResponseData>(
                    "spGetQueryUUIDByCodingElementUUID", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetQueryUUIDByCodingElementUUID Command Request
        /// <summary>
    /// A class which represents the spGetQueryUUIDByCodingElementUUID procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetQueryUUIDByCodingElementUUIDCommandRequest
    {
        public String codingElementUUID { get ; set; }

    }

    #endregion

    #region  spGetQueryUUIDByCodingElementUUID Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetQueryUUIDByCodingElementUUID procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetQueryUUIDByCodingElementUUIDCommandResponse
    {
        public IList<spGetQueryUUIDByCodingElementUUIDCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetQueryUUIDByCodingElementUUID Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetQueryUUIDByCodingElementUUID procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetQueryUUIDByCodingElementUUIDCommandResponseData
    {

        public String QueryUUID { get ; set; }

    }


    #endregion

    #endregion


    #region  spGetRolesManagementSetupData

    #region  spGetRolesManagementSetupData Command
    
    /// <summary>
    /// A class which represents the spGetRolesManagementSetupData procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetRolesManagementSetupDataCommand:ICommand<spGetRolesManagementSetupDataCommandRequest, spGetRolesManagementSetupDataCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetRolesManagementSetupDataCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetRolesManagementSetupDataCommandResponse Execute(spGetRolesManagementSetupDataCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetRolesManagementSetupDataCommandResponse response = new spGetRolesManagementSetupDataCommandResponse();

            var p = new DynamicParameters();

            p.Add("@UserName", request.UserName);


            var data = 
                _Connection
                .Query<spGetRolesManagementSetupDataCommandResponseData>(
                    "spGetRolesManagementSetupData", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetRolesManagementSetupData Command Request
        /// <summary>
    /// A class which represents the spGetRolesManagementSetupData procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetRolesManagementSetupDataCommandRequest
    {
        public String UserName { get ; set; }

    }

    #endregion

    #region  spGetRolesManagementSetupData Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetRolesManagementSetupData procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetRolesManagementSetupDataCommandResponse
    {
        public IList<spGetRolesManagementSetupDataCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetRolesManagementSetupData Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetRolesManagementSetupData procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetRolesManagementSetupDataCommandResponseData
    {

        public String SegmentName { get ; set; }
        public String ProjectName { get ; set; }
        public String StudyOid { get ; set; }
        public Int32? SegmentId { get ; set; }

    }


    #endregion

    #endregion


    #region  spGetSegmentSetupDataByUserName

    #region  spGetSegmentSetupDataByUserName Command
    
    /// <summary>
    /// A class which represents the spGetSegmentSetupDataByUserName procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSegmentSetupDataByUserNameCommand:ICommand<spGetSegmentSetupDataByUserNameCommandRequest, spGetSegmentSetupDataByUserNameCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetSegmentSetupDataByUserNameCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetSegmentSetupDataByUserNameCommandResponse Execute(spGetSegmentSetupDataByUserNameCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetSegmentSetupDataByUserNameCommandResponse response = new spGetSegmentSetupDataByUserNameCommandResponse();

            var p = new DynamicParameters();

            p.Add("@UserName", request.UserName);

            p.Add("@IsProductionStudy", request.IsProductionStudy);


            var data = 
                _Connection
                .Query<spGetSegmentSetupDataByUserNameCommandResponseData>(
                    "spGetSegmentSetupDataByUserName", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetSegmentSetupDataByUserName Command Request
        /// <summary>
    /// A class which represents the spGetSegmentSetupDataByUserName procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSegmentSetupDataByUserNameCommandRequest
    {
        public String UserName { get ; set; }
        public Boolean? IsProductionStudy { get ; set; }

    }

    #endregion

    #region  spGetSegmentSetupDataByUserName Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetSegmentSetupDataByUserName procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSegmentSetupDataByUserNameCommandResponse
    {
        public IList<spGetSegmentSetupDataByUserNameCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetSegmentSetupDataByUserName Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetSegmentSetupDataByUserName procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSegmentSetupDataByUserNameCommandResponseData
    {

        public String SegmentName { get ; set; }
        public String ProjectName { get ; set; }
        public String SourceSystemStudyName { get ; set; }
        public String SourceSystemStudyDisplayName { get ; set; }
        public String StudyOid { get ; set; }
        public Int32? SegmentId { get ; set; }
        public String ProtocolNumber { get ; set; }

    }


    #endregion

    #endregion


    #region  spGetSourceSystemApplicationData

    #region  spGetSourceSystemApplicationData Command
    
    /// <summary>
    /// A class which represents the spGetSourceSystemApplicationData procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSourceSystemApplicationDataCommand:ICommand<spGetSourceSystemApplicationDataCommandRequest, spGetSourceSystemApplicationDataCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetSourceSystemApplicationDataCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetSourceSystemApplicationDataCommandResponse Execute(spGetSourceSystemApplicationDataCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetSourceSystemApplicationDataCommandResponse response = new spGetSourceSystemApplicationDataCommandResponse();

            var p = new DynamicParameters();

            p.Add("@ApplicationName", request.ApplicationName);


            var data = 
                _Connection
                .Query<spGetSourceSystemApplicationDataCommandResponseData>(
                    "spGetSourceSystemApplicationData", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetSourceSystemApplicationData Command Request
        /// <summary>
    /// A class which represents the spGetSourceSystemApplicationData procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSourceSystemApplicationDataCommandRequest
    {
        public String ApplicationName { get ; set; }

    }

    #endregion

    #region  spGetSourceSystemApplicationData Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetSourceSystemApplicationData procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSourceSystemApplicationDataCommandResponse
    {
        public IList<spGetSourceSystemApplicationDataCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetSourceSystemApplicationData Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetSourceSystemApplicationData procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetSourceSystemApplicationDataCommandResponseData
    {

        public String SourceSystem { get ; set; }
        public String SourceSystemLocale { get ; set; }
        public String ConnectionURI { get ; set; }

    }


    #endregion

    #endregion


    #region  spGetStudyDataByProject

    #region  spGetStudyDataByProject Command
    
    /// <summary>
    /// A class which represents the spGetStudyDataByProject procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetStudyDataByProjectCommand:ICommand<spGetStudyDataByProjectCommandRequest, spGetStudyDataByProjectCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetStudyDataByProjectCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetStudyDataByProjectCommandResponse Execute(spGetStudyDataByProjectCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetStudyDataByProjectCommandResponse response = new spGetStudyDataByProjectCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentName", request.SegmentName);

            p.Add("@ProjectName", request.ProjectName);


            var data = 
                _Connection
                .Query<spGetStudyDataByProjectCommandResponseData>(
                    "spGetStudyDataByProject", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetStudyDataByProject Command Request
        /// <summary>
    /// A class which represents the spGetStudyDataByProject procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetStudyDataByProjectCommandRequest
    {
        public String SegmentName { get ; set; }
        public String ProjectName { get ; set; }

    }

    #endregion

    #region  spGetStudyDataByProject Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetStudyDataByProject procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetStudyDataByProjectCommandResponse
    {
        public IList<spGetStudyDataByProjectCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetStudyDataByProject Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetStudyDataByProject procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetStudyDataByProjectCommandResponseData
    {

        public String SourceSystemStudyName { get ; set; }
        public String SourceSystemStudyDisplayName { get ; set; }
        public String StudyOid { get ; set; }
        public Int32? SegmentId { get ; set; }
        public String ProtocolNumber { get ; set; }

    }


    #endregion

    #endregion


    #region  spGetUserNameByLogin

    #region  spGetUserNameByLogin Command
    
    /// <summary>
    /// A class which represents the spGetUserNameByLogin procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetUserNameByLoginCommand:ICommand<spGetUserNameByLoginCommandRequest, spGetUserNameByLoginCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spGetUserNameByLoginCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spGetUserNameByLoginCommandResponse Execute(spGetUserNameByLoginCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spGetUserNameByLoginCommandResponse response = new spGetUserNameByLoginCommandResponse();

            var p = new DynamicParameters();

            p.Add("@Login", request.Login);


            var data = 
                _Connection
                .Query<spGetUserNameByLoginCommandResponseData>(
                    "spGetUserNameByLogin", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spGetUserNameByLogin Command Request
        /// <summary>
    /// A class which represents the spGetUserNameByLogin procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetUserNameByLoginCommandRequest
    {
        public String Login { get ; set; }

    }

    #endregion

    #region  spGetUserNameByLogin Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spGetUserNameByLogin procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetUserNameByLoginCommandResponse
    {
        public IList<spGetUserNameByLoginCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spGetUserNameByLogin Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spGetUserNameByLogin procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spGetUserNameByLoginCommandResponseData
    {

        public String UserName { get ; set; }

    }


    #endregion

    #endregion


    #region  spInsertDoNotAutoCodeTerms

    #region  spInsertDoNotAutoCodeTerms Command
    
    /// <summary>
    /// A class which represents the spInsertDoNotAutoCodeTerms procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spInsertDoNotAutoCodeTermsCommand:ICommand<spInsertDoNotAutoCodeTermsCommandRequest, spInsertDoNotAutoCodeTermsCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spInsertDoNotAutoCodeTermsCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spInsertDoNotAutoCodeTermsCommandResponse Execute(spInsertDoNotAutoCodeTermsCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spInsertDoNotAutoCodeTermsCommandResponse response = new spInsertDoNotAutoCodeTermsCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentName", request.SegmentName);

            p.Add("@DictionaryList", request.DictionaryList);

            p.Add("@Term", request.Term);

            p.Add("@Dictionary", request.Dictionary);

            p.Add("@Level", request.Level);

            p.Add("@Login", request.Login);


            var data = 
                _Connection
                .Execute(
                    "spInsertDoNotAutoCodeTerms", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spInsertDoNotAutoCodeTerms Command Request
        /// <summary>
    /// A class which represents the spInsertDoNotAutoCodeTerms procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spInsertDoNotAutoCodeTermsCommandRequest
    {
        public String SegmentName { get ; set; }
        public String DictionaryList { get ; set; }
        public String Term { get ; set; }
        public String Dictionary { get ; set; }
        public String Level { get ; set; }
        public String Login { get ; set; }

    }

    #endregion

    #region  spInsertDoNotAutoCodeTerms Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spInsertDoNotAutoCodeTerms procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spInsertDoNotAutoCodeTermsCommandResponse
    {

    }

    #endregion

    #region spInsertDoNotAutoCodeTerms Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spInsertDoNotAutoCodeTerms procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spInsertDoNotAutoCodeTermsCommandResponseData{}


    #endregion

    #endregion


    #region  spObjectSegmentInsert

    #region  spObjectSegmentInsert Command
    
    /// <summary>
    /// A class which represents the spObjectSegmentInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spObjectSegmentInsertCommand:ICommand<spObjectSegmentInsertCommandRequest, spObjectSegmentInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spObjectSegmentInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spObjectSegmentInsertCommandResponse Execute(spObjectSegmentInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spObjectSegmentInsertCommandResponse response = new spObjectSegmentInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@ObjectID", request.ObjectID);

            p.Add("@ObjectTypeId", request.ObjectTypeId);

            p.Add("@SegmentId", request.SegmentId);

            p.Add("@Readonly", request.Readonly);

            p.Add("@DefaultSegment", request.DefaultSegment);

            p.Add("@Deleted", request.Deleted);

            p.Add("@ObjectSegmentID", value: request.ObjectSegmentID, dbType: DbType.Int64, direction: ParameterDirection.InputOutput);					
            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spObjectSegmentInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.ObjectSegmentID = p.Get<Int64?>("@ObjectSegmentID");					
             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					

            return response;
        }

    }

    #endregion

    #region  spObjectSegmentInsert Command Request
        /// <summary>
    /// A class which represents the spObjectSegmentInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spObjectSegmentInsertCommandRequest
    {
        public Int32? ObjectID { get ; set; }
        public Int32? ObjectTypeId { get ; set; }
        public Int32? SegmentId { get ; set; }
        public Boolean? Readonly { get ; set; }
        public Boolean? DefaultSegment { get ; set; }
        public Boolean? Deleted { get ; set; }
        public Int64? ObjectSegmentID { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }

    }

    #endregion

    #region  spObjectSegmentInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spObjectSegmentInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spObjectSegmentInsertCommandResponse
    {
            public Int64? ObjectSegmentID{ get; set; }					

            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					


    }

    #endregion

    #region spObjectSegmentInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spObjectSegmentInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spObjectSegmentInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spRoleActionInsert

    #region  spRoleActionInsert Command
    
    /// <summary>
    /// A class which represents the spRoleActionInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleActionInsertCommand:ICommand<spRoleActionInsertCommandRequest, spRoleActionInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spRoleActionInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spRoleActionInsertCommandResponse Execute(spRoleActionInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spRoleActionInsertCommandResponse response = new spRoleActionInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@RoleID", request.RoleID);

            p.Add("@ModuleActionId", request.ModuleActionId);

            p.Add("@SegmentID", request.SegmentID);

            p.Add("@RoleActionID", value: request.RoleActionID, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spRoleActionInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.RoleActionID = p.Get<Int32?>("@RoleActionID");					

            return response;
        }

    }

    #endregion

    #region  spRoleActionInsert Command Request
        /// <summary>
    /// A class which represents the spRoleActionInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleActionInsertCommandRequest
    {
        public Int32? RoleID { get ; set; }
        public Int32? ModuleActionId { get ; set; }
        public Int32? SegmentID { get ; set; }
        public Int32? RoleActionID { get ; set; }

    }

    #endregion

    #region  spRoleActionInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spRoleActionInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleActionInsertCommandResponse
    {
            public Int32? RoleActionID{ get; set; }					


    }

    #endregion

    #region spRoleActionInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spRoleActionInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleActionInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spRoleInsert

    #region  spRoleInsert Command
    
    /// <summary>
    /// A class which represents the spRoleInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleInsertCommand:ICommand<spRoleInsertCommandRequest, spRoleInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spRoleInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spRoleInsertCommandResponse Execute(spRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spRoleInsertCommandResponse response = new spRoleInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@Active", request.Active);

            p.Add("@RoleName", request.RoleName);

            p.Add("@ModuleId", request.ModuleId);

            p.Add("@SegmentID", request.SegmentID);

            p.Add("@RoleID", value: request.RoleID, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spRoleInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.RoleID = p.Get<Int32?>("@RoleID");					

            return response;
        }

    }

    #endregion

    #region  spRoleInsert Command Request
        /// <summary>
    /// A class which represents the spRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleInsertCommandRequest
    {
        public Boolean? Active { get ; set; }
        public String RoleName { get ; set; }
        public Int32? ModuleId { get ; set; }
        public Int32? SegmentID { get ; set; }
        public Int32? RoleID { get ; set; }

    }

    #endregion

    #region  spRoleInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleInsertCommandResponse
    {
            public Int32? RoleID{ get; set; }					


    }

    #endregion

    #region spRoleInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRoleInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spRuntimeLockDelete

    #region  spRuntimeLockDelete Command
    
    /// <summary>
    /// A class which represents the spRuntimeLockDelete procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockDeleteCommand:ICommand<spRuntimeLockDeleteCommandRequest, spRuntimeLockDeleteCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spRuntimeLockDeleteCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spRuntimeLockDeleteCommandResponse Execute(spRuntimeLockDeleteCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spRuntimeLockDeleteCommandResponse response = new spRuntimeLockDeleteCommandResponse();

            var p = new DynamicParameters();

            p.Add("@lockKey", request.lockKey);


            var data = 
                _Connection
                .Execute(
                    "spRuntimeLockDelete", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spRuntimeLockDelete Command Request
        /// <summary>
    /// A class which represents the spRuntimeLockDelete procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockDeleteCommandRequest
    {
        public String lockKey { get ; set; }

    }

    #endregion

    #region  spRuntimeLockDelete Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spRuntimeLockDelete procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockDeleteCommandResponse
    {

    }

    #endregion

    #region spRuntimeLockDelete Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spRuntimeLockDelete procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockDeleteCommandResponseData{}


    #endregion

    #endregion


    #region  spRuntimeLockInsert

    #region  spRuntimeLockInsert Command
    
    /// <summary>
    /// A class which represents the spRuntimeLockInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockInsertCommand:ICommand<spRuntimeLockInsertCommandRequest, spRuntimeLockInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spRuntimeLockInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spRuntimeLockInsertCommandResponse Execute(spRuntimeLockInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spRuntimeLockInsertCommandResponse response = new spRuntimeLockInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@lockKey", request.lockKey);

            p.Add("@expireInSeconds", request.expireInSeconds);

            p.Add("@LockSuccess", value: request.LockSuccess, dbType: DbType.Boolean, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spRuntimeLockInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.LockSuccess = p.Get<Boolean?>("@LockSuccess");					

            return response;
        }

    }

    #endregion

    #region  spRuntimeLockInsert Command Request
        /// <summary>
    /// A class which represents the spRuntimeLockInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockInsertCommandRequest
    {
        public String lockKey { get ; set; }
        public Int32? expireInSeconds { get ; set; }
        public Boolean? LockSuccess { get ; set; }

    }

    #endregion

    #region  spRuntimeLockInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spRuntimeLockInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockInsertCommandResponse
    {
            public Boolean? LockSuccess{ get; set; }					


    }

    #endregion

    #region spRuntimeLockInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spRuntimeLockInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spRuntimeLockInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spSegmentGetByIMedidataId

    #region  spSegmentGetByIMedidataId Command
    
    /// <summary>
    /// A class which represents the spSegmentGetByIMedidataId procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentGetByIMedidataIdCommand:ICommand<spSegmentGetByIMedidataIdCommandRequest, spSegmentGetByIMedidataIdCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spSegmentGetByIMedidataIdCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spSegmentGetByIMedidataIdCommandResponse Execute(spSegmentGetByIMedidataIdCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spSegmentGetByIMedidataIdCommandResponse response = new spSegmentGetByIMedidataIdCommandResponse();

            var p = new DynamicParameters();

            p.Add("@iMedidataId", request.iMedidataId);


            var data = 
                _Connection
                .Query<spSegmentGetByIMedidataIdCommandResponseData>(
                    "spSegmentGetByIMedidataId", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spSegmentGetByIMedidataId Command Request
        /// <summary>
    /// A class which represents the spSegmentGetByIMedidataId procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentGetByIMedidataIdCommandRequest
    {
        public String iMedidataId { get ; set; }

    }

    #endregion

    #region  spSegmentGetByIMedidataId Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spSegmentGetByIMedidataId procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentGetByIMedidataIdCommandResponse
    {
        public IList<spSegmentGetByIMedidataIdCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spSegmentGetByIMedidataId Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spSegmentGetByIMedidataId procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentGetByIMedidataIdCommandResponseData
    {

        public Int32? SegmentId { get ; set; }
        public String SegmentName { get ; set; }
        public String OID { get ; set; }
        public Boolean? Deleted { get ; set; }
        public Boolean? Active { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }
        public Boolean? UserDeactivated { get ; set; }
        public String IMedidataId { get ; set; }

    }


    #endregion

    #endregion


    #region  spSegmentInsert

    #region  spSegmentInsert Command
    
    /// <summary>
    /// A class which represents the spSegmentInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentInsertCommand:ICommand<spSegmentInsertCommandRequest, spSegmentInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spSegmentInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spSegmentInsertCommandResponse Execute(spSegmentInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spSegmentInsertCommandResponse response = new spSegmentInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@OID", request.OID);

            p.Add("@Deleted", request.Deleted);

            p.Add("@Active", request.Active);

            p.Add("@SegmentName", request.SegmentName);

            p.Add("@UserDeactivated", request.UserDeactivated);

            p.Add("@IMedidataId", request.IMedidataId);

            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@SegmentID", value: request.SegmentID, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spSegmentInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					
             response.SegmentID = p.Get<Int32?>("@SegmentID");					

            return response;
        }

    }

    #endregion

    #region  spSegmentInsert Command Request
        /// <summary>
    /// A class which represents the spSegmentInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentInsertCommandRequest
    {
        public String OID { get ; set; }
        public Boolean? Deleted { get ; set; }
        public Boolean? Active { get ; set; }
        public String SegmentName { get ; set; }
        public Boolean? UserDeactivated { get ; set; }
        public String IMedidataId { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }
        public Int32? SegmentID { get ; set; }

    }

    #endregion

    #region  spSegmentInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spSegmentInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentInsertCommandResponse
    {
            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					

            public Int32? SegmentID{ get; set; }					


    }

    #endregion

    #region spSegmentInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spSegmentInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSegmentInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spSetupDefaultConfiguration

    #region  spSetupDefaultConfiguration Command
    
    /// <summary>
    /// A class which represents the spSetupDefaultConfiguration procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupDefaultConfigurationCommand:ICommand<spSetupDefaultConfigurationCommandRequest, spSetupDefaultConfigurationCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spSetupDefaultConfigurationCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spSetupDefaultConfigurationCommandResponse Execute(spSetupDefaultConfigurationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spSetupDefaultConfigurationCommandResponse response = new spSetupDefaultConfigurationCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentOID", request.SegmentOID);

            p.Add("@JDrugOID", request.JDrugOID);


            var data = 
                _Connection
                .Execute(
                    "spSetupDefaultConfiguration", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spSetupDefaultConfiguration Command Request
        /// <summary>
    /// A class which represents the spSetupDefaultConfiguration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupDefaultConfigurationCommandRequest
    {
        public String SegmentOID { get ; set; }
        public String JDrugOID { get ; set; }

    }

    #endregion

    #region  spSetupDefaultConfiguration Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spSetupDefaultConfiguration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupDefaultConfigurationCommandResponse
    {

    }

    #endregion

    #region spSetupDefaultConfiguration Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spSetupDefaultConfiguration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupDefaultConfigurationCommandResponseData{}


    #endregion

    #endregion


    #region  spSetupGranularDefaultConfiguration

    #region  spSetupGranularDefaultConfiguration Command
    
    /// <summary>
    /// A class which represents the spSetupGranularDefaultConfiguration procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupGranularDefaultConfigurationCommand:ICommand<spSetupGranularDefaultConfigurationCommandRequest, spSetupGranularDefaultConfigurationCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spSetupGranularDefaultConfigurationCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spSetupGranularDefaultConfigurationCommandResponse Execute(spSetupGranularDefaultConfigurationCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spSetupGranularDefaultConfigurationCommandResponse response = new spSetupGranularDefaultConfigurationCommandResponse();

            var p = new DynamicParameters();

            p.Add("@SegmentOID", request.SegmentOID);

            p.Add("@DefaultLocale", request.DefaultLocale);

            p.Add("@CodingTaskPageSize", request.CodingTaskPageSize);

            p.Add("@ForcePrimaryPathSelection", request.ForcePrimaryPathSelection);

            p.Add("@SearchLimitReclassificationResult", request.SearchLimitReclassificationResult);

            p.Add("@SynonymCreationPolicyFlag", request.SynonymCreationPolicyFlag);

            p.Add("@BypassReconsiderUponReclassifyFlag", request.BypassReconsiderUponReclassifyFlag);

            p.Add("@DictOID", request.DictOID);

            p.Add("@IsAutoAddSynonym", request.IsAutoAddSynonym);

            p.Add("@IsAutoApproval", request.IsAutoApproval);

            p.Add("@MaxNumberofSearchResults", request.MaxNumberofSearchResults);


            var data = 
                _Connection
                .Execute(
                    "spSetupGranularDefaultConfiguration", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);


            return response;
        }

    }

    #endregion

    #region  spSetupGranularDefaultConfiguration Command Request
        /// <summary>
    /// A class which represents the spSetupGranularDefaultConfiguration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupGranularDefaultConfigurationCommandRequest
    {
        public String SegmentOID { get ; set; }
        public String DefaultLocale { get ; set; }
        public String CodingTaskPageSize { get ; set; }
        public String ForcePrimaryPathSelection { get ; set; }
        public String SearchLimitReclassificationResult { get ; set; }
        public String SynonymCreationPolicyFlag { get ; set; }
        public String BypassReconsiderUponReclassifyFlag { get ; set; }
        public String DictOID { get ; set; }
        public String IsAutoAddSynonym { get ; set; }
        public String IsAutoApproval { get ; set; }
        public String MaxNumberofSearchResults { get ; set; }

    }

    #endregion

    #region  spSetupGranularDefaultConfiguration Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spSetupGranularDefaultConfiguration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupGranularDefaultConfigurationCommandResponse
    {

    }

    #endregion

    #region spSetupGranularDefaultConfiguration Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spSetupGranularDefaultConfiguration procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spSetupGranularDefaultConfigurationCommandResponseData{}


    #endregion

    #endregion


    #region  spStudyProjectInsert

    #region  spStudyProjectInsert Command
    
    /// <summary>
    /// A class which represents the spStudyProjectInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spStudyProjectInsertCommand:ICommand<spStudyProjectInsertCommandRequest, spStudyProjectInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spStudyProjectInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spStudyProjectInsertCommandResponse Execute(spStudyProjectInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spStudyProjectInsertCommandResponse response = new spStudyProjectInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@StudyProjectId", value: request.StudyProjectId, dbType: DbType.Int64, direction: ParameterDirection.InputOutput);					
            p.Add("@ProjectName", request.ProjectName);

            p.Add("@iMedidataId", request.iMedidataId);

            p.Add("@SegmentID", request.SegmentID);

            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spStudyProjectInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.StudyProjectId = p.Get<Int64?>("@StudyProjectId");					
             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					

            return response;
        }

    }

    #endregion

    #region  spStudyProjectInsert Command Request
        /// <summary>
    /// A class which represents the spStudyProjectInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spStudyProjectInsertCommandRequest
    {
        public Int64? StudyProjectId { get ; set; }
        public String ProjectName { get ; set; }
        public String iMedidataId { get ; set; }
        public Int32? SegmentID { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }

    }

    #endregion

    #region  spStudyProjectInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spStudyProjectInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spStudyProjectInsertCommandResponse
    {
            public Int64? StudyProjectId{ get; set; }					

            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					


    }

    #endregion

    #region spStudyProjectInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spStudyProjectInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spStudyProjectInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spTrackableObjectInsert

    #region  spTrackableObjectInsert Command
    
    /// <summary>
    /// A class which represents the spTrackableObjectInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spTrackableObjectInsertCommand:ICommand<spTrackableObjectInsertCommandRequest, spTrackableObjectInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spTrackableObjectInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spTrackableObjectInsertCommandResponse Execute(spTrackableObjectInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spTrackableObjectInsertCommandResponse response = new spTrackableObjectInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@TrackableObjectID", value: request.TrackableObjectID, dbType: DbType.Int64, direction: ParameterDirection.InputOutput);					
            p.Add("@ExternalObjectTypeId", request.ExternalObjectTypeId);

            p.Add("@ExternalObjectId", request.ExternalObjectId);

            p.Add("@ExternalObjectOID", request.ExternalObjectOID);

            p.Add("@ExternalObjectName", request.ExternalObjectName);

            p.Add("@ProtocolName", request.ProtocolName);

            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@ExternalObjectNameId", request.ExternalObjectNameId);

            p.Add("@TaskCounter", request.TaskCounter);

            p.Add("@IsTestStudy", request.IsTestStudy);

            p.Add("@StudyProjectID", request.StudyProjectID);

            p.Add("@AuditStudyGroupUUID", request.AuditStudyGroupUUID);

            p.Add("@SourceUpdatedAt", request.SourceUpdatedAt);

            p.Add("@SegmentId", request.SegmentId);


            var data = 
                _Connection
                .Execute(
                    "spTrackableObjectInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.TrackableObjectID = p.Get<Int64?>("@TrackableObjectID");					
             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					

            return response;
        }

    }

    #endregion

    #region  spTrackableObjectInsert Command Request
        /// <summary>
    /// A class which represents the spTrackableObjectInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spTrackableObjectInsertCommandRequest
    {
        public Int64? TrackableObjectID { get ; set; }
        public Int64? ExternalObjectTypeId { get ; set; }
        public String ExternalObjectId { get ; set; }
        public String ExternalObjectOID { get ; set; }
        public String ExternalObjectName { get ; set; }
        public String ProtocolName { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }
        public Int32? ExternalObjectNameId { get ; set; }
        public Int32? TaskCounter { get ; set; }
        public Boolean? IsTestStudy { get ; set; }
        public Int32? StudyProjectID { get ; set; }
        public String AuditStudyGroupUUID { get ; set; }
        public DateTime? SourceUpdatedAt { get ; set; }
        public Int32? SegmentId { get ; set; }

    }

    #endregion

    #region  spTrackableObjectInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spTrackableObjectInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spTrackableObjectInsertCommandResponse
    {
            public Int64? TrackableObjectID{ get; set; }					

            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					


    }

    #endregion

    #region spTrackableObjectInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spTrackableObjectInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spTrackableObjectInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spUserGetByIMedidataId

    #region  spUserGetByIMedidataId Command
    
    /// <summary>
    /// A class which represents the spUserGetByIMedidataId procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserGetByIMedidataIdCommand:ICommand<spUserGetByIMedidataIdCommandRequest, spUserGetByIMedidataIdCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spUserGetByIMedidataIdCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spUserGetByIMedidataIdCommandResponse Execute(spUserGetByIMedidataIdCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spUserGetByIMedidataIdCommandResponse response = new spUserGetByIMedidataIdCommandResponse();

            var p = new DynamicParameters();

            p.Add("@iMedidataId", request.iMedidataId);


            var data = 
                _Connection
                .Query<spUserGetByIMedidataIdCommandResponseData>(
                    "spUserGetByIMedidataId", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure)
                .ToList();


            // TODO: Hanlde multiple result sets

            response.Data = data;
            return response;
        }

    }

    #endregion

    #region  spUserGetByIMedidataId Command Request
        /// <summary>
    /// A class which represents the spUserGetByIMedidataId procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserGetByIMedidataIdCommandRequest
    {
        public String iMedidataId { get ; set; }

    }

    #endregion

    #region  spUserGetByIMedidataId Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spUserGetByIMedidataId procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserGetByIMedidataIdCommandResponse
    {
        public IList<spUserGetByIMedidataIdCommandResponseData> Data { get ; set; }

    }

    #endregion

    #region spUserGetByIMedidataId Response Data

    

    /// <summary>
    /// A class which represents the result data returned from executing spUserGetByIMedidataId procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserGetByIMedidataIdCommandResponseData
    {

        public Int32? UserID { get ; set; }
        public String FirstName { get ; set; }
        public String LastName { get ; set; }
        public String Email { get ; set; }
        public String Login { get ; set; }
        public String Locale { get ; set; }
        public Boolean? Active { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }
        public Boolean? Deleted { get ; set; }
        public String IMedidataId { get ; set; }
        public String TimeZoneInfo { get ; set; }

    }


    #endregion

    #endregion


    #region  spUserInsert

    #region  spUserInsert Command
    
    /// <summary>
    /// A class which represents the spUserInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserInsertCommand:ICommand<spUserInsertCommandRequest, spUserInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spUserInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spUserInsertCommandResponse Execute(spUserInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spUserInsertCommandResponse response = new spUserInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@FirstName", request.FirstName);

            p.Add("@LastName", request.LastName);

            p.Add("@Email", request.Email);

            p.Add("@Login", request.Login);

            p.Add("@TimeZoneInfo", request.TimeZoneInfo);

            p.Add("@IMedidataId", request.IMedidataId);

            p.Add("@Locale", request.Locale);

            p.Add("@Active", request.Active);

            p.Add("@UserID", value: request.UserID, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spUserInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.UserID = p.Get<Int32?>("@UserID");					

            return response;
        }

    }

    #endregion

    #region  spUserInsert Command Request
        /// <summary>
    /// A class which represents the spUserInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserInsertCommandRequest
    {
        public String FirstName { get ; set; }
        public String LastName { get ; set; }
        public String Email { get ; set; }
        public String Login { get ; set; }
        public String TimeZoneInfo { get ; set; }
        public String IMedidataId { get ; set; }
        public String Locale { get ; set; }
        public Boolean? Active { get ; set; }
        public Int32? UserID { get ; set; }

    }

    #endregion

    #region  spUserInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spUserInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserInsertCommandResponse
    {
            public Int32? UserID{ get; set; }					


    }

    #endregion

    #region spUserInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spUserInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spUserObjectRoleInsert

    #region  spUserObjectRoleInsert Command
    
    /// <summary>
    /// A class which represents the spUserObjectRoleInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectRoleInsertCommand:ICommand<spUserObjectRoleInsertCommandRequest, spUserObjectRoleInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spUserObjectRoleInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spUserObjectRoleInsertCommandResponse Execute(spUserObjectRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spUserObjectRoleInsertCommandResponse response = new spUserObjectRoleInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@GrantToObjectId", request.GrantToObjectId);

            p.Add("@GrantOnObjectKey", request.GrantOnObjectKey);

            p.Add("@RoleID", request.RoleID);

            p.Add("@Active", request.Active);

            p.Add("@DenyObjectRole", request.DenyObjectRole);

            p.Add("@SegmentID", request.SegmentID);

            p.Add("@UserObjectRoleId", value: request.UserObjectRoleId, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spUserObjectRoleInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.UserObjectRoleId = p.Get<Int32?>("@UserObjectRoleId");					

            return response;
        }

    }

    #endregion

    #region  spUserObjectRoleInsert Command Request
        /// <summary>
    /// A class which represents the spUserObjectRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectRoleInsertCommandRequest
    {
        public Int32? GrantToObjectId { get ; set; }
        public String GrantOnObjectKey { get ; set; }
        public Int32? RoleID { get ; set; }
        public Boolean? Active { get ; set; }
        public Boolean? DenyObjectRole { get ; set; }
        public Int32? SegmentID { get ; set; }
        public Int32? UserObjectRoleId { get ; set; }

    }

    #endregion

    #region  spUserObjectRoleInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spUserObjectRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectRoleInsertCommandResponse
    {
            public Int32? UserObjectRoleId{ get; set; }					


    }

    #endregion

    #region spUserObjectRoleInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spUserObjectRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectRoleInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spUserObjectWorkflowRoleInsert

    #region  spUserObjectWorkflowRoleInsert Command
    
    /// <summary>
    /// A class which represents the spUserObjectWorkflowRoleInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectWorkflowRoleInsertCommand:ICommand<spUserObjectWorkflowRoleInsertCommandRequest, spUserObjectWorkflowRoleInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spUserObjectWorkflowRoleInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spUserObjectWorkflowRoleInsertCommandResponse Execute(spUserObjectWorkflowRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spUserObjectWorkflowRoleInsertCommandResponse response = new spUserObjectWorkflowRoleInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@GrantToObjectID", request.GrantToObjectID);

            p.Add("@GrantOnObjectID", request.GrantOnObjectID);

            p.Add("@WorkflowRoleID", request.WorkflowRoleID);

            p.Add("@Active", request.Active);

            p.Add("@DenyObjectRole", request.DenyObjectRole);

            p.Add("@UserObjectWorkflowRoleID", value: request.UserObjectWorkflowRoleID, dbType: DbType.Int64, direction: ParameterDirection.InputOutput);					
            p.Add("@SegmentId", request.SegmentId);


            var data = 
                _Connection
                .Execute(
                    "spUserObjectWorkflowRoleInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.UserObjectWorkflowRoleID = p.Get<Int64?>("@UserObjectWorkflowRoleID");					

            return response;
        }

    }

    #endregion

    #region  spUserObjectWorkflowRoleInsert Command Request
        /// <summary>
    /// A class which represents the spUserObjectWorkflowRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectWorkflowRoleInsertCommandRequest
    {
        public Int64? GrantToObjectID { get ; set; }
        public Int64? GrantOnObjectID { get ; set; }
        public Int64? WorkflowRoleID { get ; set; }
        public Boolean? Active { get ; set; }
        public Boolean? DenyObjectRole { get ; set; }
        public Int64? UserObjectWorkflowRoleID { get ; set; }
        public Int32? SegmentId { get ; set; }

    }

    #endregion

    #region  spUserObjectWorkflowRoleInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spUserObjectWorkflowRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectWorkflowRoleInsertCommandResponse
    {
            public Int64? UserObjectWorkflowRoleID{ get; set; }					


    }

    #endregion

    #region spUserObjectWorkflowRoleInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spUserObjectWorkflowRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spUserObjectWorkflowRoleInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spWorkflowRoleActionInsert

    #region  spWorkflowRoleActionInsert Command
    
    /// <summary>
    /// A class which represents the spWorkflowRoleActionInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleActionInsertCommand:ICommand<spWorkflowRoleActionInsertCommandRequest, spWorkflowRoleActionInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spWorkflowRoleActionInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spWorkflowRoleActionInsertCommandResponse Execute(spWorkflowRoleActionInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spWorkflowRoleActionInsertCommandResponse response = new spWorkflowRoleActionInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@WorkflowRoleId", request.WorkflowRoleId);

            p.Add("@WorkflowActionId", request.WorkflowActionId);

            p.Add("@SegmentId", request.SegmentId);

            p.Add("@WorkflowRoleActionID", value: request.WorkflowRoleActionID, dbType: DbType.Int64, direction: ParameterDirection.InputOutput);					
            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					

            var data = 
                _Connection
                .Execute(
                    "spWorkflowRoleActionInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.WorkflowRoleActionID = p.Get<Int64?>("@WorkflowRoleActionID");					
             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					

            return response;
        }

    }

    #endregion

    #region  spWorkflowRoleActionInsert Command Request
        /// <summary>
    /// A class which represents the spWorkflowRoleActionInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleActionInsertCommandRequest
    {
        public Int64? WorkflowRoleId { get ; set; }
        public Int32? WorkflowActionId { get ; set; }
        public Int32? SegmentId { get ; set; }
        public Int64? WorkflowRoleActionID { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }

    }

    #endregion

    #region  spWorkflowRoleActionInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spWorkflowRoleActionInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleActionInsertCommandResponse
    {
            public Int64? WorkflowRoleActionID{ get; set; }					

            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					


    }

    #endregion

    #region spWorkflowRoleActionInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spWorkflowRoleActionInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleActionInsertCommandResponseData{}


    #endregion

    #endregion


    #region  spWorkflowRoleInsert

    #region  spWorkflowRoleInsert Command
    
    /// <summary>
    /// A class which represents the spWorkflowRoleInsert procedure request in the Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleInsertCommand:ICommand<spWorkflowRoleInsertCommandRequest, spWorkflowRoleInsertCommandResponse>
    {
        private readonly IDbConnection _Connection;
        private readonly Int32?        _CommandTimeout;

        public spWorkflowRoleInsertCommand(IDbConnection connection, Int32? commandTimeout)
        {
            Debug.Assert(!ReferenceEquals(connection, null), "connection can't be null");

            _Connection = connection;
            _CommandTimeout = commandTimeout;
        }
        
        public spWorkflowRoleInsertCommandResponse Execute(spWorkflowRoleInsertCommandRequest request)
        {
            Debug.Assert(!ReferenceEquals(request, null), "request can't be null");

            spWorkflowRoleInsertCommandResponse response = new spWorkflowRoleInsertCommandResponse();

            var p = new DynamicParameters();

            p.Add("@RoleName", request.RoleName);

            p.Add("@ModuleId", request.ModuleId);

            p.Add("@Active", request.Active);

            p.Add("@WorkflowRoleID", value: request.WorkflowRoleID, dbType: DbType.Int32, direction: ParameterDirection.InputOutput);					
            p.Add("@Created", value: request.Created, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@Updated", value: request.Updated, dbType: DbType.DateTime, direction: ParameterDirection.InputOutput);					
            p.Add("@SegmentId", request.SegmentId);


            var data = 
                _Connection
                .Execute(
                    "spWorkflowRoleInsert", 
                    p,
                    commandTimeout: _CommandTimeout,
                    commandType: CommandType.StoredProcedure);

             response.WorkflowRoleID = p.Get<Int32?>("@WorkflowRoleID");					
             response.Created = p.Get<DateTime?>("@Created");					
             response.Updated = p.Get<DateTime?>("@Updated");					

            return response;
        }

    }

    #endregion

    #region  spWorkflowRoleInsert Command Request
        /// <summary>
    /// A class which represents the spWorkflowRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleInsertCommandRequest
    {
        public String RoleName { get ; set; }
        public Byte? ModuleId { get ; set; }
        public Boolean? Active { get ; set; }
        public Int32? WorkflowRoleID { get ; set; }
        public DateTime? Created { get ; set; }
        public DateTime? Updated { get ; set; }
        public Int32? SegmentId { get ; set; }

    }

    #endregion

    #region  spWorkflowRoleInsert Command Response
        /// <summary>
    /// A class which represents the result data returned from executing spWorkflowRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleInsertCommandResponse
    {
            public Int32? WorkflowRoleID{ get; set; }					

            public DateTime? Created{ get; set; }					

            public DateTime? Updated{ get; set; }					


    }

    #endregion

    #region spWorkflowRoleInsert Response Data

    
    /// <summary>
    /// A class which represents the result data returned from executing spWorkflowRoleInsert procedure request in the coder_av Database.
    /// </summary>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class spWorkflowRoleInsertCommandResponseData{}


    #endregion

    #endregion

}
    