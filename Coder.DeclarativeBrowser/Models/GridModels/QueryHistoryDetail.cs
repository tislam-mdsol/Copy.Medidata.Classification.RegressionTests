using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class QueryHistoryDetail
    {
        public string User          { get; set; }
        public string VerbatimTerm  { get; set; }
        public string QueryStatus   { get; set; }
        public string QueryText     { get; set; }
        public string QueryResponse { get; set; }
        public string OpenTo        { get; set; }
        public string QueryNotes    { get; set; }
        public string TimeStamp     { get; set; }
    }
}
