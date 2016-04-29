using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.Models.GridModels;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal static class SynonymDisplay
    {
        internal static SynonymStatus GetSynonymStatus(string statusInput)
        {
            if (String.IsNullOrWhiteSpace(statusInput)) throw new ArgumentNullException("statusInput");

            var statusDictionary = new Dictionary<string, SynonymStatus>(StringComparer.OrdinalIgnoreCase)
            {
                {"active"     , SynonymStatus.Approved},
                {"approved"   , SynonymStatus.Approved},
                {"provisional", SynonymStatus.Provisional}
            };

            var responseStatus = statusDictionary[statusInput];

            return responseStatus;
        }
    }
}
