using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyReportStatsDetails : IEquatable<StudyReportStatsDetails>
    {
        public string Study             { get; set; }
        public string Verbatim          { get; set; }
        public string Dictionary        { get; set; }
        public string Status            { get; set; }
        public string Batch             { get; set; }

        public TermPathRow SelectedTerm { get; set; }

        public IEnumerable<TermPathRow> SelectedTermpath { get; set; }

        public bool Equals(StudyReportStatsDetails other)
        {
            if (ReferenceEquals(other, null)) throw new ArgumentNullException(nameof(other));

            var result = Study              .Equals(other.Study,      StringComparison.OrdinalIgnoreCase)
                         && Verbatim        .Equals(other.Verbatim,   StringComparison.OrdinalIgnoreCase)
                         && Dictionary      .Equals(other.Dictionary, StringComparison.OrdinalIgnoreCase)
                         && Status          .Equals(other.Status,     StringComparison.OrdinalIgnoreCase)
                         && Batch           .Equals(other.Batch,      StringComparison.OrdinalIgnoreCase)
                         && SelectedTerm    .Equals(other.SelectedTerm)
                         && SelectedTermpath.Equals(other.SelectedTermpath);
                    
            return result;
        }

    }
}
