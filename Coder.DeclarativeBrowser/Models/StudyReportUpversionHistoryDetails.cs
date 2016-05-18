using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyReportUpversionHistoryDetails : IEquatable<StudyReportUpversionHistoryDetails>
    {
        public string FromVersion                  { get; set; }
        public string ToVersion                    { get; set; }
        public string User                         { get; set; }
        public string StartedOn                    { get; set; }
        public string NotAffected                  { get; set; }
        public string CodedToNewVersionSynonym     { get; set; }
        public string CodedToNewVersionBetterMatch { get; set; }
        public string PathChanged                  { get; set; }
        public string CasingChangeOnly             { get; set; }
        public string Obsolete                     { get; set; }
        public string TermNotFound                 { get; set; }

        public bool Equals(StudyReportUpversionHistoryDetails other)
        {
            if (ReferenceEquals(other, null)) throw new ArgumentNullException(nameof(other));

            var result =    FromVersion                 .Equals(other.FromVersion,                  StringComparison.OrdinalIgnoreCase)
                         && ToVersion                   .Equals(other.ToVersion,                    StringComparison.OrdinalIgnoreCase)
                         && User                        .Equals(other.User,                         StringComparison.OrdinalIgnoreCase)
                         && StartedOn                   .Equals(other.StartedOn,                    StringComparison.OrdinalIgnoreCase)
                         && NotAffected                 .Equals(other.NotAffected,                  StringComparison.OrdinalIgnoreCase)
                         && CodedToNewVersionSynonym    .Equals(other.CodedToNewVersionSynonym,     StringComparison.OrdinalIgnoreCase)
                         && CodedToNewVersionBetterMatch.Equals(other.CodedToNewVersionBetterMatch, StringComparison.OrdinalIgnoreCase)
                         && PathChanged                 .Equals(other.PathChanged,                  StringComparison.OrdinalIgnoreCase)
                         && CasingChangeOnly            .Equals(other.CasingChangeOnly,             StringComparison.OrdinalIgnoreCase)
                         && Obsolete                    .Equals(other.Obsolete,                     StringComparison.OrdinalIgnoreCase)
                         && TermNotFound                .Equals(other.TermNotFound,                 StringComparison.OrdinalIgnoreCase);
            return result;
        }
    }
}
