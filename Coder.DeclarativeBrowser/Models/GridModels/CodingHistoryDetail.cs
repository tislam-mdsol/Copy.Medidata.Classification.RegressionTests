using System;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class CodingHistoryDetail
    {
        public string User                        { get; set; }
        public string Action                      { get; set; }
        public string Status                      { get; set; }
        public string VerbatimTerm                { get; set; }
        public string Comment                     { get; set; }
        public string TimeStamp                   { get; set; }
        public TermPathRow SelectedTermPathRow    { get; set; }
        public TermPathRow[] ExpandedTermPathRows { get; set; }
    }
}
