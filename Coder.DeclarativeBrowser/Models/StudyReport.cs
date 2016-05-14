using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyReport
    {
        public IEnumerable<StudyReportStats> StudyStats             { get; set; }

        public IEnumerable<StudyReportUpVersion> UpversionHistories { get; set; }
    }
}
