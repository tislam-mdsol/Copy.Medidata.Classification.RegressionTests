using System;

namespace Coder.DeclarativeBrowser.Models
{
    public class CodingDecisionsReportCriteria
    {
        public string Study                { get; set; }
        public string Dictionary           { get; set; }
        public string VersionLocale        { get; set; }
        public string Verbatim             { get; set; }
        public string StartDate            { get; set; }
        public string EndDate              { get; set; }
        public string SingleCodedBy        { get; set; }
        public string SingleStatus         { get; set; }
        public string SingleColumn         { get; set; }
        public bool IncludeAutoCodedItems  { get; set; }
        public bool ExcludeAutoCodedItems  { get; set; }
        public bool AllColumns             { get; set; }
        public bool AllStatus              { get; set; }
        public bool AllCodedBy             { get; set; }
    }
}
