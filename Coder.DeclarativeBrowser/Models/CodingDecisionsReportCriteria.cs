using System;

namespace Coder.DeclarativeBrowser.Models
{
    public class CodingDecisionsReportCriteria
    {
        public string Study                { get; set; }
        public string Dictionary           { get; set; }
        public string Locale               { get; set; }
        public string Verbatim             { get; set; }
        public string StartDate            { get; set; }
        public string EndDate              { get; set; }
        public string CurrentStatus        { get; set; }
        public string CodedBy              { get; set; }
        public bool IncludeAutoCodedItems  { get; set; }
        public bool AllColumns             { get; set; }
    }
}
