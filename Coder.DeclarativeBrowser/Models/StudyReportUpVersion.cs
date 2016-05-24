using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyReportUpVersion
    {
        public string StudyName           { get; set; }
        public string Dictionary          { get; set; }
        public string NumberOfUpversions  { get; set; }
        public string InitialVersion      { get; set; }
        public string CurrentVersion      { get; set; }

        public IEnumerable<StudyReportUpversionHistoryDetails> UpversioningDetails { get; set; }
    }
}
