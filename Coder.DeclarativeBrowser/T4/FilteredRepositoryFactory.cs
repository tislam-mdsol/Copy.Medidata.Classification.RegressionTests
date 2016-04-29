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
using System.CodeDom.Compiler;

namespace Coder.DeclarativeBrowser.Db 
{
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface IFilteredRepositoryFactory
    {
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class FilteredRepositoryFactory:IFilteredRepositoryFactory
    {
        private readonly IDapperRepositoryFactory _RepoFactory;
        private readonly bool                     _ThrowIfFilterInvalid;

        public FilteredRepositoryFactory(
            IDapperRepositoryFactory repoFactory,
            Boolean throwIfFilterInvalid)
        {
            Debug.Assert(!ReferenceEquals(repoFactory , null), "repoFactory can't be null");

            _RepoFactory          = repoFactory;
            _ThrowIfFilterInvalid = throwIfFilterInvalid;
        }

        public FilteredRepositoryFactory(
            Func<String, String> urlDecoder,
            Boolean throwIfFilterInvalid)
            : this(
                new DapperRepositoryFactory(urlDecoder),
                throwIfFilterInvalid) { }

    }
}
