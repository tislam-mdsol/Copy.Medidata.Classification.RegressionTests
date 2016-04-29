using System;
using System.Collections.Specialized;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Models
{
    public class CodingTask
    {
        private string _verbatimTerm;
        private string _group;
        private string _priority;
        private string _status;
        private string _assignedTerm;
        private string _dictionary;
        private string _queries;
        private string _timeElaps;

        private static StringDictionary TaskGridColumnNameToPropertyMap = new StringDictionary
        {
            {"Verbatim Term"     , "VerbatimTerm"},
            {"Group"             , "Group"       },
            {"Priority"          , "Priority"    },
            {"Status"            , "Status"      },
            {"Assigned Term"     , "AssignedTerm"},
            {"Dictionary"        , "Dictionary"  },
            {"Queries"           , "Queries"     },
            {"Time Elapsed"      , "TimeElaps"   },
        };

        public string VerbatimTerm  { get { return _verbatimTerm ?? String.Empty; } set { _verbatimTerm = value; } }
        public string Group         { get { return _group        ?? String.Empty; } set { _group        = value; } }
        public string Priority      { get { return _priority     ?? String.Empty; } set { _priority     = value; } }
        public string Status        { get { return _status       ?? String.Empty; } set { _status       = value; } }
        public string AssignedTerm  { get { return _assignedTerm ?? String.Empty; } set { _assignedTerm = value; } }
        public string Dictionary    { get { return _dictionary   ?? String.Empty; } set { _dictionary   = value; } }
        public string Queries       { get { return _queries      ?? String.Empty; } set { _queries      = value; } }
        public string TimeElaps     { get { return _timeElaps    ?? String.Empty; } set { _timeElaps    = value; } }

        public string GetPropertyByTaskGridColumnName(string columnName)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            return this.GetProperty(TaskGridColumnNameToPropertyMap[columnName]);
        }
    }
}
                                                            