/*******************************************************************************************************
 *	THIS IS AN AUTO-GENERATED FILE.  
 *  DO NOT ALTER OR YOUR CHANGES WILL BE LOST.
 *******************************************************************************************************/
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using Medidata;
using System.Data;
using System.CodeDom.Compiler;
using Medidata.Dapper;

namespace Coder.DeclarativeBrowser.Db 
{
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderKeyedReadersRepository
    {

    }
	    
	[GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderKeyedReadersRepository : ICoderKeyedReadersRepository
    {


        public CoderKeyedReadersRepository(
            CoderDbConfig config,
            IPrimaryKeyReadableRepositoryFactory repoFactory)
        {
            Debug.Assert(!ReferenceEquals(config, null), "config can't be null");
            Debug.Assert(!ReferenceEquals(repoFactory, null), "repoFactory can't be null");



        }


    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderKeyedReaders
    {
    
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderKeyedReaders:ICoderKeyedReaders
    {
        private readonly IDbConnection                                 _Connection;
        private readonly ICoderKeyedReadersRepository _Repo;

        public CoderKeyedReaders(
            IDbConnection connection,
            ICoderKeyedReadersRepository repo)
        {
            Debug.Assert(!ReferenceEquals(connection , null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(repo       , null), "repo can't be null");

            _Connection     = connection;
            _Repo           = repo;
        }




    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderKeyedReadersTester:ICoderKeyedReaders
    {


    }
}
