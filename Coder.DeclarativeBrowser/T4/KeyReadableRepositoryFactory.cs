
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
    internal interface IPrimaryKeyReadableRepositoryFactory
    {

    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class PrimaryKeyReadableRepositoryFactory:IPrimaryKeyReadableRepositoryFactory
    {
        private readonly IDapperRepositoryFactory _RepoFactory;

        public PrimaryKeyReadableRepositoryFactory(IDapperRepositoryFactory repoFactory)
        {
            Debug.Assert(!ReferenceEquals(repoFactory , null), "repoFactory can't be null");

            _RepoFactory = repoFactory;
        }

        public PrimaryKeyReadableRepositoryFactory(Func<String, String> urlDecoder) : this(new DapperRepositoryFactory(urlDecoder)) { }


    }
}
