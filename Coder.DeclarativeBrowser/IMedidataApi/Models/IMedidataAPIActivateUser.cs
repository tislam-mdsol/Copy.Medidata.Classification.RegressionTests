using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.IMedidataApi.Models
{
    public class IMedidataAPIActivateUser
    {
        public string password                                     { get; set; }
        public bool eula_agreed_to                                 { get; set; }
        public IMedidataAPISecurityQuestion user_security_question { get; set; }
    }
}
