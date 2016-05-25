using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyReportStats
    {
        public string StudyStatName       { get; set; }
        public string DictionaryName      { get; set; }

        public int NotCodedCount          { get; set; }
        public int CodedNotCompletedCount { get; set; }
        public int WithOpenQueryCount     { get; set; }
        public int CompletedCount         { get; set; }

        public IEnumerable<StudyReportStatsDetails> NotCodedTasks           { get; set; }
        public IEnumerable<StudyReportStatsDetails> CodedNotCompletedTasks  { get; set; }
        public IEnumerable<StudyReportStatsDetails> WithOpenQueryTasks      { get; set; }
        public IEnumerable<StudyReportStatsDetails> CompletedTasks          { get; set; }
    }
}
