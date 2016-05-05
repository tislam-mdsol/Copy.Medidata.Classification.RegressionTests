using System;
using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.Models
{
    public class CodingDecisionsReportCriteria
    {
        public string Study                { get; set; }
        public string DictionaryLocale     { get; set; }
        public string Version              { get; set; }
        public string Verbatim             { get; set; }
        public string Term                 { get; set; }
        public string Code                 { get; set; }
        public string StartDate            { get; set; }
        public string EndDate              { get; set; }
        public bool IncludeAutoCodedItems  { get; set; }
        public bool ExcludeAutoCodedItems  { get; set; }

        public IEnumerable<string> ExportColumns { get; set; }
        public IEnumerable<string> StatusOptions { get; set; }
        public IEnumerable<string> CodedByOptions { get; set; }

    }
}
