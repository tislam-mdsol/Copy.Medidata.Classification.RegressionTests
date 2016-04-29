using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Models.GridModels;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveHeader
    {
        private readonly BrowserSession _Session;

        internal RaveHeader(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetIMedidataLink()
        {
            var iMedidataLink = _Session.FindSessionElementById("_ctl0_PgHeader_iMedidataLink");

            return iMedidataLink;
        }

        internal bool IMedidataLinkExists()
        {
            var iMedidataLink = GetIMedidataLink();

            return iMedidataLink.Exists(Config.ExistsOptions);
        }

        internal void GoToIMedidata()
        {
            var iMedidataLink = GetIMedidataLink();

            iMedidataLink.Click();

            _Session.GetImedidataPage().WaitForPageToFinishLoading();
        }
    }
}