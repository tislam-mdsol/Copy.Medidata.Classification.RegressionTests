using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.IMedidataApi.Models
{
    public class IMedidataAPIStudy
    {
        public string name           { get; set; }
        public string oid            { get; set; }
        public string uuid           { get; set; }
        public string mcc_study_uuid { get; set; }
        public string phase          { get; set; }
        public string indication     { get; set; }
        public bool is_production    { get; set; }
    }
}
