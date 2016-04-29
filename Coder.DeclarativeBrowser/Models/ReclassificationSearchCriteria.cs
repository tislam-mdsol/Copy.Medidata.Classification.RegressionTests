
namespace Coder.DeclarativeBrowser.Models
{
    public class ReclassificationSearchCriteria
    {
        public string Study                 { get; set; }
        public string DictionaryType        { get; set; }
        public string Version               { get; set; }
        public string Verbatim              { get; set; }
        public string Term                  { get; set; }
        public string Code                  { get; set; }
        public string Subject               { get; set; }
        public string PriorStatus           { get; set; }
        public string CodedBy               { get; set; }
        public string PriorActions          { get; set; }
        public string StartDate             { get; set; }
        public string EndDate               { get; set; }
        public bool IncludeAutoCodedItems   { get; set; }
    }
}
