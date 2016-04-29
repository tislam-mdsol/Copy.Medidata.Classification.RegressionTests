/*******************************************************************************************************
 *	THIS IS AN AUTO-GENERATED FILE.  
 *  DO NOT ALTER OR YOUR CHANGES WILL BE LOST.
 *******************************************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.CodeDom.Compiler;
using System.Diagnostics;
using Dapper;
using Medidata.Dapper;

namespace Coder.DeclarativeBrowser.Db 
{
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderDbConnectionFactory
    {
        ICoderDbConnection Build();
    }
	    
	[GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderDbConnectionFactory : ICoderDbConnectionFactory
    {
        private readonly ICoderDbFilteredReadersRepository _FilteredRepository;
        private readonly ICoderKeyedReadersRepository                       _PrimaryKeyRepository;
        private readonly ICoderAllRecordRepository                      _AllRecordsRepository;
        private readonly String                                             _ConnectionString;
        private readonly Int32?                                             _SqlTimeout;
        private readonly CoderDbConfig                     _Config;

        /// <summary>
        /// Initializes a new instance of the CoderDbConnectionFactory class.
        /// </summary>
        /// <param name="connectionString"></param>
        /// <param name="sqlTimeout"></param>
        /// <param name="map"></param>
        /// <param name="config"></param>
        /// <param name="throwIfInvalid"></param>
        public CoderDbConnectionFactory(
            String connectionString,
            Int32? sqlTimeout,
            Func<String, String> map,
            CoderDbConfig config,
            Boolean throwIfInvalid)
        {
            if (ReferenceEquals(connectionString, null)) throw new ArgumentNullException("connectionString");
            if (ReferenceEquals(map             , null)) throw new ArgumentNullException("map");
            if (ReferenceEquals(config          , null)) throw new ArgumentNullException("config");

            _SqlTimeout                  = sqlTimeout ?? 30;
            _ConnectionString            = connectionString;
            _Config                      = config;
            _FilteredRepository          = new CoderDbFilteredReadersRepository(
                    _Config,
                    new FilteredRepositoryFactory(map, throwIfInvalid));
            _PrimaryKeyRepository        = new CoderKeyedReadersRepository(
					_Config, 
					new PrimaryKeyReadableRepositoryFactory(map));
            _AllRecordsRepository = new CoderAllRecordRepository(new AllRecordsRepositoryFactory(map));
        }

        /// <summary>
        /// Initializes a new instance of the CoderDbConnectionFactory class.
        /// </summary>
        /// <param name="connectionString"></param>
        /// <param name="sqlTimeout"></param>
        public CoderDbConnectionFactory(
            String connectionString,
            Int32? sqlTimeout = null)
            :this(
                connectionString, 
                sqlTimeout, 
                (s => s),
                new CoderDbConfig(),
                true)
        {
        }

        public ICoderDbConnection Build()
        {
            var sqlConnection = new SqlConnection(_ConnectionString);

            var result = new CoderDbConnection(
                sqlConnection,
                _SqlTimeout,
                _Config,
                _FilteredRepository,
                _PrimaryKeyRepository,
                _AllRecordsRepository);

            return result;
        }
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////

    /// <summary>
    /// Connection for the CoderDatabase.
    /// </summary>
    /// <remarks>MULTIPLE CALLS ON SINGLE INSTANCE IS NOT THREAD SAFE!  
    ///  For multi-threading create multiple instances.</remarks>
    /// <example>
    /// 
    ///  CoderDbConfig config = new CoderDbConfig { };
    ///
    ///  using (var db = new CoderDbConnection("ConnectionString", config))
    ///  {
    ///      var result = db.Execute.Request(new spApplicationAdminFetchCommandRequest());
    ///  }
    ///     
    /// /////// Multi-threaded example: //////////////////////////////////
    /// 
    ///  var results = from request in requestCollection.AsParallel().Select(r => 
    ///  {
    ///      using (var db = new CoderDbConnection("ConnectionString", config)) // new connection on each thread
    ///      {
    ///          var result = db.Execute.Request(new spApplicationAdminFetchCommandRequest());
    ///          return result;
    ///      }
    ///  });
    ///  
    /// </example>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal interface ICoderDbConnection: IDisposable
    {
        void BeginTransaction();
        void BeginTransaction(IsolationLevel il);
        void CommitTransaction();
        void RollbackTransaction();

        /// <summary>
        /// Execute a procedure.
        /// </summary>
        /// <value>
        /// The available procedures.
        /// </value>
        ICoderDbCommands Execute { get; }
        /// <summary>
        /// Get a filtered list of database entities.
        /// </summary>
        /// <value>
        /// The available filtered entities.
        /// </value>
        ICoderDbFilteredReaders GetFiltered { get; }
        /// <summary>
        /// Get a database entity by it's primary key.
        /// </summary>
        /// <value>
        /// The available entities.
        /// </value>
        ICoderKeyedReaders Get { get; }
        /// <summary>
        /// Get a database entity by it's primary key.
        /// </summary>
        /// <value>
        /// The available entities.
        /// </value>
        ICoderAllRecordReaders GetAll { get; }

        ICoderDbConnection WithCommandTimeout(Int32? value);

        IEnumerable<T> Query<T>(string sql, dynamic param = null, bool buffered = true, CommandType? commandType = null);

        Int32 ExecuteSql(string sql, dynamic param = null, CommandType? commandType = null);
    }


    /// <summary>
    /// Connection for the CoderDatabase.
    /// </summary>
    /// <remarks>MULTIPLE CALLS ON SINGLE INSTANCE IS NOT THREAD SAFE!  
    ///  For multi-threading create multiple instances.</remarks>
    /// <example>
    /// 
    ///  CoderDbConfig config = new CoderDbConfig { };
    ///
    ///  using (var db = new CoderDbConnection("ConnectionString", config))
    ///  {
    ///      var result = db.Execute.Request(new spApplicationAdminFetchCommandRequest());
    ///  }
    ///     
    /// /////// Multi-threaded example: //////////////////////////////////
    /// 
    ///  var results = from request in requestCollection.AsParallel().Select(r => 
    ///  {
    ///      using (var db = new CoderDbConnection("ConnectionString", config)) // new connection on each thread
    ///      {
    ///          var result = db.Execute.Request(new spApplicationAdminFetchCommandRequest());
    ///          return result;
    ///      }
    ///  });
    ///  
    /// </example>
    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal sealed class CoderDbConnection: ICoderDbConnection, IDisposable
    {
        private readonly IDbConnection                                      _Connection;
        private readonly Int32?                                             _CommandTimeout;
        private readonly CoderDbConfig                     _Config;
        private readonly ICoderDbFilteredReadersRepository _FilteredRepository;

        private readonly ICoderKeyedReadersRepository                       _PrimaryKeyRepository;
        private readonly ICoderAllRecordRepository                       _AllRecordsRepository;

        private IDbTransaction                                _Transaction;

        public CoderDbConnection(
            IDbConnection connection, 
            Int32? commandTimeout,
            CoderDbConfig config,  
            ICoderDbFilteredReadersRepository filteredRepository,
            ICoderKeyedReadersRepository primaryKeyRepository,
            ICoderAllRecordRepository allRecordsRepository)
        {
            Debug.Assert(!ReferenceEquals(connection                 , null), "connection can't be null");
            Debug.Assert(!ReferenceEquals(config                     , null), "config can't be null");
            Debug.Assert(!ReferenceEquals(filteredRepository         , null), "filteredRepository can't be null");
            Debug.Assert(!ReferenceEquals(primaryKeyRepository       , null), "primaryKeyRepository can't be null");
            Debug.Assert(!ReferenceEquals(allRecordsRepository       , null), "allRecordsRepository can't be null");

            _Connection                  = connection;
            _CommandTimeout              = commandTimeout;
            _Config                      = config;
            _FilteredRepository          = filteredRepository;
            _PrimaryKeyRepository        = primaryKeyRepository;
            _AllRecordsRepository        = allRecordsRepository;
        }

        public ICoderDbConnection WithCommandTimeout(Int32? value)
        {
            var result = new CoderDbConnection(
                _Connection ,                
                value,          
                _Config, 
                _FilteredRepository,
                _PrimaryKeyRepository,
                _AllRecordsRepository);

            return result;
        }


        public void BeginTransaction()
        {
            AssertConnectionIsOpen();
            AssertTransactionDoesNotExist();
            _Transaction = _Connection.BeginTransaction();
        }

        public void BeginTransaction(IsolationLevel il)
        {
            AssertConnectionIsOpen();            
            AssertTransactionDoesNotExist();
            _Transaction = _Connection.BeginTransaction(il);
        }

        private void AssertTransactionDoesNotExist()
        {
            if(ReferenceEquals(_Transaction, null))
                return;

            throw new InvalidOperationException("There is an existing transaction open on this connection.  Commit or Rollback before creating another transaction.");
        }

        public void CommitTransaction()
        {
            AssertTransactionExists();

            try
            {
                _Transaction.Commit();
            }
            finally
            {
                _Transaction.Dispose();
                _Transaction = null;
            }
        }

        private void AssertTransactionExists()
        {
            if(! ReferenceEquals(_Transaction, null))
                return;

            throw new InvalidOperationException("There is no open trasaction on this connection.  A transaction must be opened before this action is valid.");
        }

        public void RollbackTransaction()
        {
            AssertTransactionExists();

            try
            {
                _Transaction.Rollback();
            }
            finally
            {
                _Transaction.Dispose();
                _Transaction = null;
            }
        }

        public void Dispose()
        {
            var safeRef = _Connection;

            if (! ReferenceEquals(safeRef, null))
                safeRef.Dispose();

            var safeTransRef = _Transaction;

            if (!ReferenceEquals(safeTransRef, null))
                safeTransRef.Dispose();
        }

        internal void AssertConnectionIsOpen()
        {
            if (_Connection.State == ConnectionState.Closed)
                _Connection.Open();
        }


        /// <summary>
        /// Execute a procedure.
        /// </summary>
        /// <value>
        /// The available procedures.
        /// </value>
        public ICoderDbCommands Execute
        { 
            get
            {
                AssertConnectionIsOpen();

                var result = new CoderDbCommands(_Connection, _CommandTimeout);
                return result;
            }
        }

        /// <summary>
        /// Get a filtered list of database entities.
        /// </summary>
        /// <value>
        /// The available filtered entities.
        /// </value>
        public ICoderDbFilteredReaders GetFiltered
        {
            get
            {
                AssertConnectionIsOpen();

                var result = new CoderDbFilteredReaders(
                                _Connection,  
                                _FilteredRepository);
                return result;
            }
        }


        /// <summary>
        /// Get a database entity by it's primary key.
        /// </summary>
        /// <value>
        /// The available entities.
        /// </value>
        public ICoderKeyedReaders Get
        {
            get
            {
                AssertConnectionIsOpen();

                var result = new CoderKeyedReaders(_Connection, _PrimaryKeyRepository);
                return result;
            }
        }

                /// <summary>
        /// Get a database entity by it's primary key.
        /// </summary>
        /// <value>
        /// The available entities.
        /// </value>
        public ICoderAllRecordReaders GetAll
        {
            get
            {
                AssertConnectionIsOpen();

                var result = new CoderAllRecordReaders(_Connection, _AllRecordsRepository);
                return result;
            }
        }
        
        public IEnumerable<T> Query<T>(
            string sql, 
            dynamic param = null, 
            bool buffered = true, 
            CommandType? commandType = null)
        {
            AssertConnectionIsOpen();

            var result = SqlMapper.Query<T>(_Connection, sql, param, _Transaction, buffered, _CommandTimeout, commandType) as IEnumerable<T>;
            return result;
        }

        public Int32 ExecuteSql(string sql, dynamic param = null, CommandType? commandType = null)
        {
            AssertConnectionIsOpen();

            var result = SqlMapper.Execute(_Connection, sql, param, _Transaction, _CommandTimeout, commandType);
            return result;
        }


    }	

    /////////////////////////////////////////////////////////////////////////////////////////////


    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class CoderDbConnectionTester:ICoderDbConnection
    {
        public void BeginTransaction()
        {
        }

        public void BeginTransaction(IsolationLevel il)
        {
        }

        public void CommitTransaction()
        {
        }

        public void RollbackTransaction()
        {
        }

        public ICoderDbConnection WithCommandTimeout(Int32? commandTimeout)
        {
            return this;
        }

        private readonly CoderDbCommandsTester _CommandsTester = new CoderDbCommandsTester();

        public CoderDbCommandsTester ConfigureExecute
        {
            get { return _CommandsTester; }
        }

        public ICoderDbCommands Execute
        {
            get { return _CommandsTester; }
        }

        private readonly CoderDbFilteredReadersTester _FilterTester = new CoderDbFilteredReadersTester();

        public CoderDbFilteredReadersTester ConfigureGetFiltered
        {
            get { return _FilterTester; }
        }

        public ICoderDbFilteredReaders GetFiltered
        {
            get { return _FilterTester; }
        }

        private readonly CoderKeyedReadersTester _KeyedReaderTester = new CoderKeyedReadersTester();

        public CoderKeyedReadersTester ConfigureGet
        {
            get { return _KeyedReaderTester; }
        }

        public ICoderKeyedReaders Get
        {
            get { return _KeyedReaderTester; }
        }

        public ICoderAllRecordReaders GetAll
        {
            get { throw new NotImplementedException(); }
        }

        public void Dispose()
        {
            
        }
        
        public IEnumerable<T> Query<T>(string sql, dynamic param = null,bool buffered = true, CommandType? commandType = null)
        {
            throw new NotImplementedException();
        }

        public Int32 ExecuteSql(string sql, dynamic param = null, CommandType? commandType = null)
        {
            throw new NotImplementedException();
        }
    }
}
