using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.Models
{
    internal class AdminSynonymSuggestionDetails
    {
        internal IList<TermPath> PriorTermPath        { get; set; }
        internal IList<TermPath> SuggestedTermPath    { get; set; }
        internal string Details                       { get; set; }
    }
}
