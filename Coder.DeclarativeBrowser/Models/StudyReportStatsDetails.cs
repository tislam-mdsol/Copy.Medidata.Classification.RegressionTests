using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyReportStatsDetails
    {
        public string Study             { get; set; }
        public string Verbatim          { get; set; }
        public string Dictionary        { get; set; }
        public string Status            { get; set; }
        public string Batch             { get; set; }

        public TermPathRow SelectedTerm { get; set; }

        public IEnumerable<TermPathRow> SelectedTermpath { get; set; }
    }
}
