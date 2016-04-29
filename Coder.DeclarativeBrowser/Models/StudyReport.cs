
namespace Coder.DeclarativeBrowser.Models
{
    internal class StudyReport
    {
        internal string Study                   { get; set; }
        internal string CurrentVersion          { get; set; }
        internal string InitialVersion          { get; set; }
        internal string NumberOfMigrations      { get; set; }
        internal string NotCoded                { get; set; }
        internal string CodedButNotYetCompleted { get; set; }
        internal string OpenQuery               { get; set; }
        internal string Completed               { get; set; }
        internal string Dictionary              { get; set; }
    }
}
