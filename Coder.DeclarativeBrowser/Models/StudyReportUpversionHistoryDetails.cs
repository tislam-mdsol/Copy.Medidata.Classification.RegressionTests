using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyReportUpversionHistoryDetails
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
    }
}
