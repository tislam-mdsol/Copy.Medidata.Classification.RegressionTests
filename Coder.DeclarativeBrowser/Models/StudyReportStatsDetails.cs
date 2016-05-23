using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Org.BouncyCastle.Asn1.Esf;

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

            var result = Study        .Equals(other.Study,      StringComparison.OrdinalIgnoreCase)
                         && Verbatim  .Equals(other.Verbatim,   StringComparison.OrdinalIgnoreCase)
                         && Dictionary.Equals(other.Dictionary, StringComparison.OrdinalIgnoreCase)
                         && Status    .Equals(other.Status,     StringComparison.OrdinalIgnoreCase)
                         && Batch     .Equals(other.Batch,      StringComparison.OrdinalIgnoreCase);

            if (!ReferenceEquals(other.SelectedTerm, null))
            {
                result = SelectedTerm.Equals(other.SelectedTerm);
            }

            if (!ReferenceEquals(other.SelectedTermpath, null))
            {
                var otherSelectedTermPath = other.SelectedTermpath.ToArray();

                var actualSelectedTermPath = SelectedTermpath.ToArray();

                for (var i = 0; i < actualSelectedTermPath.Length; i++)
                {
                    result = actualSelectedTermPath[i].Equals(otherSelectedTermPath[i]);
                }
            }

            return result;
        }
    }
}
