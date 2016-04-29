/*******************************************************************************************************
 *	THIS IS AN AUTO-GENERATED FILE.  
 *  DO NOT ALTER OR YOUR CHANGES WILL BE LOST.
 *******************************************************************************************************/
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using Medidata;
using Medidata.Dapper;
using System.Data;
using System.CodeDom.Compiler;

namespace Coder.DeclarativeBrowser.Db {

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderDbFilteredReadersRepository
    {
    }
	    
	[GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderDbFilteredReadersRepository : ICoderDbFilteredReadersRepository
    {

        public CoderDbFilteredReadersRepository(
            CoderDbConfig config,
            IFilteredRepositoryFactory repoFactory)
        {
            Debug.Assert(!ReferenceEquals(config, null), "config can't be null");
            Debug.Assert(!ReferenceEquals(repoFactory, null), "repoFactory can't be null");

        }

    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderDbFilteredReaders
    {
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderDbFilteredReaders:ICoderDbFilteredReaders
    {
        private readonly IDbConnection                                      _Connection;
        private readonly ICoderDbFilteredReadersRepository _Repo;

        public CoderDbFilteredReaders(
            IDbConnection connection,
            ICoderDbFilteredReadersRepository repo)
        {
            Debug.Assert(!ReferenceEquals(connection , null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(repo       , null), "repo can't be null");

            _Connection  = connection;
            _Repo        = repo;
        }


    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderDbFilteredReadersTester:ICoderDbFilteredReaders
    {
    }


}
