using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.IMedidataApi.Models
{
    public class IMedidataAPIUser
    {
        public const string ActiveStatus = "activation_accepted";

        public string uuid              { get; set; }
        public string login             { get; set; }
        public string password          { get; set; }
        public string locale            { get; set; }
        public string time_zone         { get; set; }
        public string email             { get; set; }
        public string first_name        { get; set; }
        public string last_name         { get; set; }
        public string telephone         { get; set; }
        public string activation_status { get; set; }
        public string activation_code   { get; set; }
    }
}
