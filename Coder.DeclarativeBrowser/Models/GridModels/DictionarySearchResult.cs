using System;
using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class DictionarySearchResult
    {
        public int ResultsCount            { get; set; }
        public string HumanReadableQuery   { get; set; }
        public IEnumerable<TermPathRow> SearchResults { get; set; }
        public TimeSpan ExecutionTime      { get; set; }
    }
}