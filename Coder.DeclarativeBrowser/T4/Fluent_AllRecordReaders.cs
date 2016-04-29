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
    internal interface ICoderAllRecordRepository
    {
    }
	    
	[GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderAllRecordRepository : ICoderAllRecordRepository
    {
        public CoderAllRecordRepository(
            IAllRecordsRepositoryFactory repoFactory)
        {
            Debug.Assert(!ReferenceEquals(repoFactory, null), "repoFactory can't be null");

        }

    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderAllRecordReaders
    {
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderAllRecordReaders : ICoderAllRecordReaders
    {
       
        private readonly IDbConnection                _Connection;
        private readonly ICoderAllRecordRepository _RepoFactory;

        public CoderAllRecordReaders(
            IDbConnection connection,
            ICoderAllRecordRepository repoFactory)
        {
            Debug.Assert(!ReferenceEquals(connection , null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(repoFactory, null), "repoFactory can't be null");

            _Connection     = connection;
            _RepoFactory    = repoFactory;
        }


    }
}
