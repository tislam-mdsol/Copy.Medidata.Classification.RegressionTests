/*******************************************************************************************************
 *	THIS IS AN AUTO-GENERATED FILE.  
 *  DO NOT ALTER OR YOUR CHANGES WILL BE LOST.
 *******************************************************************************************************/

using Medidata.Dapper;
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.CodeDom.Compiler;

namespace Coder.DeclarativeBrowser.Db 
{
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface IAllRecordsRepositoryFactory
    {
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class AllRecordsRepositoryFactory:IAllRecordsRepositoryFactory
    {
        Medidata.Dapper.IDapperRepositoryFactory _DapperFactory;

        /// <summary>
        /// Initializes a new instance of the AllRecordsRepositoryFactory class.
        /// </summary>
        /// <param name="dapperFactory"></param>
        public AllRecordsRepositoryFactory(Medidata.Dapper.IDapperRepositoryFactory dapperFactory)
        {
            Debug.Assert(!ReferenceEquals(dapperFactory , null), "dapperFactory can't be null");

            _DapperFactory = dapperFactory;
        }

        public AllRecordsRepositoryFactory(Func<String, String> urlDecoder) : this(new Medidata.Dapper.DapperRepositoryFactory(urlDecoder)) { }

    }
}
