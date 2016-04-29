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
        /// Should hold user's database PK value
        /// </summary>
        public int Id            { get; set; }

        /// <summary>
        /// Should hold user's iMedidata GUID ID Value
        /// </summary>
        public string MedidataId { get; set; }
        public string Username   { get; set; }
        public string Password   { get; set; }
        public string Email      { get; set; }
        public string FirstName  { get; set; }
        
        public string GetDisplayName()
        {
            if (String.IsNullOrWhiteSpace(FirstName)) throw new ArgumentNullException("FirstName");
            if (String.IsNullOrWhiteSpace(Username))  throw new ArgumentNullException("Username");
            
            var userDisplayName = String.Format("{0} ({1})", FirstName, Username);

            return userDisplayName;
        }
    }
}
