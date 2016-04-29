using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.Models
{
    internal class AdminSynonymSuggestion
    {
        internal string SynonymName                       { get; set; }
        internal IList<TermPath> PriorTermPath            { get; set; }
        internal IList<TermPath> UpgradedTermPath         { get; set; }
    }
}
