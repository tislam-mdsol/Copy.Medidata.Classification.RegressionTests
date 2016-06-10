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

        internal SessionElementScope GetNavigationLink(string linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            var navigationLinks = GetNavigationLinks();

            var navigationLink = navigationLinks.FirstOrDefault(x => x.Text.EqualsIgnoreCase(linkText));

            return navigationLink;
        }

        internal bool IsNavigationLinkAvailable(String linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");
            
            var link = GetNavigationLink(linkText);

            bool linkAvailable = !ReferenceEquals(link, null);

            return linkAvailable;
        }

        private bool OpenNavigationLink(string linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            if (!IsNavigationLinkAvailable(linkText))
            {
                return false;
            }

            var link = GetNavigationLink(linkText);

            link.Click();

            return true;
        }

        private bool OpenEDCNavigationLink(string linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            if (GoToEDCTab(linkText))
            {
                return true;
            }

            return OpenNavigationLink(linkText);
        }

        private bool OpenArchitectNavigationLink(string linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            if (GoToArchitectTab(linkText))
            {
                return true;
            }

            return OpenNavigationLink(linkText);
        }

        private SessionElementScope GetHorizontalTabsTable()
        {
            var tabsTable = _Session.FindSessionElementByXPath("//table[contains(@id, 'TabTable')]");

            return tabsTable;
        }

        private IList<SessionElementScope> GetTabs()
        {
            var tabsTable = GetHorizontalTabsTable();

            var tabs = tabsTable.FindAllSessionElementsByXPath(".//a");

            return tabs.ToList();
        }

        private SessionElementScope GetTab(String tabName)
        {
            if(String.IsNullOrWhiteSpace(tabName)) throw new ArgumentNullException("tabName");

            var tabs = GetTabs();

            var tabLink = tabs.FirstOrDefault(x => x.Text.Equals(tabName));

            return tabLink;
        }

        internal bool OnTab(String tabName)
        {
            var tabs    = GetTabs();

            var lastTab = tabs.LastOrDefault();

            if (ReferenceEquals(lastTab, null))
            {
                return false;
            }
            
            bool onTab  = lastTab.Text.Equals(tabName);

            return onTab;
        }

        internal bool IsTabAvailable(String tabName)
        {
            if (String.IsNullOrWhiteSpace(tabName)) throw new ArgumentNullException("tabName");

            var tab = GetTab(tabName);

            bool tabAvailable = !ReferenceEquals(tab, null);

            return tabAvailable;
        }

        internal void GoToTab(String tabName)
        {
            if (!OnTab(tabName))
            {
                var tabLink = GetTab(tabName);

                if (ReferenceEquals(tabLink, null))
                {
                    throw new MissingHtmlException(String.Format("No tab found for {0}", tabName));
                }

                tabLink.Click();
            }
        }

        internal bool GoToEDCTab(String tabName)
        {
            if (IsTabAvailable("Architect") || !IsTabAvailable(tabName))
            {
                return false;
            }
            
            GoToTab(tabName);

            return true;
        }

        internal bool GoToArchitectTab(String tabName)
        {
            if (!IsTabAvailable("Architect") || !IsTabAvailable(tabName))
            {
                return false;
            }

            GoToTab(tabName);

            return true;
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

        internal bool OpenAdverseEventsPage()
        {
            return OpenArchitectNavigationLink("Adverse Events");
        }

        internal bool OpenArchitectPage()
        {
            return OpenArchitectNavigationLink("Architect");
        }

        internal bool OpenArchitectUploadDraftPage()
        {
            return OpenArchitectNavigationLink("Upload Draft");
        }

        internal bool OpenArchitectFormsPage()
        {
            return OpenArchitectNavigationLink("Forms");
        }
        
        internal bool OpenArchitectAmendmentManagerPage()
        {
            return OpenArchitectNavigationLink("Amendment Manager");
        }

        internal bool OpenArchitectExecuteAmendmentMigrationPlanPage()
        {
            return OpenArchitectNavigationLink("Execute Plan");
        }

        internal bool OpenArchitectDefineCopySourcesPage()
        {
            return OpenArchitectNavigationLink("Define Copy Sources");
        }

        internal bool OpenArchitectCopyDraftWizardPage()
        {
            return OpenArchitectNavigationLink("Copy to Draft");
        }

        internal bool OpenArchitectEnvironmentSetupPage()
        {
            return OpenArchitectNavigationLink("Studies Environment Setup");
        }

        internal bool OpenFormPage(string formName)
        {
            if (ReferenceEquals(formName, null)) throw new ArgumentNullException("formName");

            return OpenEDCNavigationLink(formName);
        }

        internal bool OpenUserAdministrationPage()
        {
            return OpenEDCNavigationLink("User Administration");
        }

        internal bool OpenConfigurationPage()
        {
            return OpenEDCNavigationLink("Configuration");
        }

        internal bool OpenConfigurationLoaderPage()
        {
            return OpenEDCNavigationLink("Configuration Loader");
        }

        internal bool OpenConfigurationOtherSettingsPage()
        {
            return OpenEDCNavigationLink("Other Settings");
        }
        
        internal bool OpenClinicalViewsPage()
        {
            return OpenEDCNavigationLink("Clinical Views");
        }
        
        internal bool OpenClinicalViewSettingsPage()
        {
            return OpenEDCNavigationLink("Clinical View Settings");
        }

        internal bool OpenReportsPage()
        {
            return OpenEDCNavigationLink("Reporter");
        }
    }
}
