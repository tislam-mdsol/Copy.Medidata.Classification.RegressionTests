using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models.ETEModels
{
    /// <summary>
    /// Class should be able to generically represent a user in a Medidata system
    /// </summary>
    public class MedidataUser
    {
        /// <summary>
        /// Should hold user's databaase PK value
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Should hold user's iMedidata GUID ID Value
        /// </summary>
        public string MedidataId { get; set; }

        public string Username { get; set; }
        public string Password { get; set; }
    }
}
