using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.IMedidataApi.Models
{
    public class IMedidataAPIApp
    {
        public string uuid                         { get; set; }
        public string name                         { get; set; }
        public bool role_required                  { get; set; }
        public IEnumerable<IMedidataAPIRole> roles { get; set; } 
    }
}
