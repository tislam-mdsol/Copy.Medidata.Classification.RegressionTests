using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class DictionarySelectedSearchResult
    {
        public IDictionary<string, string> Properties { get; set; }
        public bool CanBeCoded                        { get; set; }
        public SynonymRow[] Synonyms                  { get; set; }
    }
}
