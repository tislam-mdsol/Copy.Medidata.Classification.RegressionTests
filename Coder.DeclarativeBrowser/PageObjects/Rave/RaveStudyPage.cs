using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveStudyPage
    {
        private readonly BrowserSession _Session;

        internal RaveStudyPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }
        
        private SessionElementScope GetSiteSearchLabel()
        {
            var siteSearchLabel = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_lblFind");

            return siteSearchLabel;
        }

        private SessionElementScope GetSiteSearchTextBox()
        {
            var siteSearchTextBox = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_txtSearch");

            return siteSearchTextBox;
        }

        private SessionElementScope GetSiteSearchButton()
        {
            var siteSearchButton = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_ibSearch");

            return siteSearchButton;
        }

        private SessionElementScope GetSitesGrid()
        {
            var sitesGrid = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_dgObjects");

            return sitesGrid;
        }

        private IList<SessionElementScope> GetSites()
        {
            var sitesGrid = GetSitesGrid();

            var sites = sitesGrid.FindAllSessionElementsByXPath(".//a");

            return sites.ToList();
        }

        internal void SearchForSite(string siteName)
        {
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("siteName");

            _Session.WaitUntilElementExists(GetSiteSearchTextBox);

            var siteSearchTextBox = GetSiteSearchTextBox();

            siteSearchTextBox.FillInWith(siteName).SendKeys(Keys.Return);
        }

        internal bool IsStudyPageLoaded()
        {
            bool searchLabelExists = GetSiteSearchLabel().Exists(Config.ExistsOptions);

            if (!searchLabelExists)
            {
                return false;
            }

            bool pageIsLoaded = GetSiteSearchLabel().Text.Equals("Sites");

            return pageIsLoaded;
        }
        
        internal void OpenSite(string siteName)
        {
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("siteName");

            RetryPolicy.FindElement.Execute(() =>
            {
                var sites = GetSites();

                if (!sites.Any())
                {
                    throw new MissingHtmlException("No sites were found.");
                }

                var siteLink = sites.FirstOrDefault(x => x.Text.EqualsIgnoreCase(siteName));

                if (ReferenceEquals(siteLink, null))
                {
                    throw new MissingHtmlException(String.Format("Site, {0}, was not found.", siteName));
                }

                siteLink.Click();
            });
        }
    }
}
