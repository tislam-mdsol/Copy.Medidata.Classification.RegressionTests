
namespace Coder.DeclarativeBrowser.Models
{
    internal class StudyImpactAnalysisDetail
    {
        internal string Verbatim               { get; set; }
        internal string CurrentTerm            { get; set; }
        internal string CurrentCode            { get; set; }
        internal string TermInNewVersion       { get; set; }
        internal string CodeInNewVersion       { get; set; }
        internal TermPathRow[] CurrentNodePath { get; set; }
    }
}
