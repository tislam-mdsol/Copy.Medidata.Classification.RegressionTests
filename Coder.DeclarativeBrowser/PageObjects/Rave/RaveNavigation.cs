using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveNavigation
    {
        private readonly BrowserSession _Session;
        
        internal RaveNavigation(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }
        
        private SessionElementScope GetHomePageLink()
        {
            var homePageLink = _Session.FindSessionElementById("_ctl0_PgHeader_HeaderImage");

            return homePageLink;
        }

        private SessionElementScope GetNavigationLinksGrid()
        {
            var navigationLinksGrid = _Session.FindSessionElementById("MasterLeftNav");
                                                                       
            return navigationLinksGrid;
        }

        private IList<SessionElementScope> GetNavigationLinks()
        {

            var navigationLinksGrid = GetNavigationLinksGrid();

            var navigationLinks     = navigationLinksGrid.FindAllSessionElementsByXPath(".//a");

            return navigationLinks.ToList();
        }

        private SessionElementScope GetNavigationLink(string linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            var navigationLinks = GetNavigationLinks();

            if (!navigationLinks.Any())
            {
                throw new MissingHtmlException("No navigation links were found in Rave Navigation");
            }

            var navigationLink = navigationLinks.FirstOrDefault(x => x.Text.EqualsIgnoreCase(linkText));

            if (ReferenceEquals(navigationLink, null))
            {
                throw new MissingHtmlException(String.Format("Navigation link, {0}, was not found in Rave Navigation", linkText));
            }
            return navigationLink;
        }

        internal bool IsNavigationLinksGridLoaded()
        {
            return GetNavigationLinksGrid().Exists(Config.ExistsOptions);
        }

        internal void WaitForNavigationLink(string linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            RetryPolicy.FindElement.Execute(() => GetNavigationLink(linkText));
        }

        internal void OpenHomePage()
        {
            _Session.WaitUntilElementExists(GetHomePageLink);

            GetHomePageLink().Click();
        }

        internal void OpenAdverseEventsPage()
        {
            var adverseEventLink = RetryPolicy.FindElement.Execute(() => GetNavigationLink("Adverse Events"));
            adverseEventLink.Click();
        }

        internal void OpenArchitectPage()
        {
            var architectLink = RetryPolicy.FindElement.Execute(() => GetNavigationLink("Architect"));
            architectLink.Click();
        }

        internal void OpenArchitectUploadDraftPage()
        {
            var architectUploadDraftLink = RetryPolicy.FindElement.Execute(() => GetNavigationLink("Upload Draft"));
            architectUploadDraftLink.Click();
        }
    }
}
