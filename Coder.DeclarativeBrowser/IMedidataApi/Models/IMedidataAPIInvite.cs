using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.IMedidataApi.Models
{
    public class IMedidataAPIInvite
    {
        public bool as_owner                     { get; set; }
        public string email                      { get; set; }
        public IEnumerable<IMedidataAPIApp> apps { get; set; } 
    }
}
