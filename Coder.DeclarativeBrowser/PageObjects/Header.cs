using System;
using System.Runtime.InteropServices.ComTypes;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using Polly;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class Header
    {
        private readonly BrowserSession _Browser;

        internal Header(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        private SessionElementScope GetSyncIndicator()
        {
            var syncIndicator = _Browser.FindSessionElementById("ctl00_PgHeader_imgStudySync");
            
            return syncIndicator;
        }

        private bool OnDictionaryBrowserPage()
        {
            var pageTitle = _Browser.Title ?? String.Empty;
            if (pageTitle.Contains("browser", StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }

            return false;
        }

        internal SessionElementScope GetSegmentDDL()
        {
            var segmentDDL =
                _Browser.FindSessionElementById("ctl00_PgHeader_ddlSegment");

            return segmentDDL;
        }

        internal SessionElementScope GetReportsTab()
        {
            var reportTab =
                _Browser.FindSessionElementById("ctl00_reportLink");

            return reportTab;
        }

        internal SessionElementScope GetHelpLink()
        {
            var helpMenu = _Browser.FindSessionElementById("ctl00_PgHeader_HlpControl_HelpLink");

            return helpMenu;
        }

        private SessionElementScope GetAdminMenuHeader()
        {
            var adminMenuHeader = _Browser.FindSessionElementByXPath("//*[starts-with(normalize-space(text()),'Administration')]");

            return adminMenuHeader;
        }

        internal SessionElementScope GetReportsMenu()
        {
            var reportMenu =
                _Browser.FindSessionElementById("ctl00_floatingReportsMenu");

            return reportMenu;
        }

        internal SessionElementScope GetHelpMenu()
        {
            var helpMenu =
                _Browser.FindSessionElementById("ctl00_PgHeader_HlpControl_floatingHelpMenu");

            return helpMenu;
        }

        internal SessionElementScope GetReportsMenuItemByName(string menuItemName)
        {
            if (String.IsNullOrEmpty(menuItemName)) throw new ArgumentNullException("menuItemName");

            var reportsMenu         = GetReportsMenu();
            var reportsMenuItem     = GetMenuItemByXPath(reportsMenu, menuItemName);

            return reportsMenuItem;
        }

        internal SessionElementScope GetHelpMenuItemByName(string menuItemName)
        {
            if (String.IsNullOrEmpty(menuItemName)) throw new ArgumentNullException("menuItemName");

            var helpMenu        = GetHelpMenu();
            var helpMenuItem    = GetMenuItemByXPath(helpMenu, menuItemName);

            return helpMenuItem;
        }

        internal SessionElementScope GetTasksTab()
        {
            var tasksTab = _Browser.FindSessionElementByLink("Tasks");

            return tasksTab;
        }

        internal SessionElementScope GetBrowserTab()
        {
            var tasksTab = GetTasksTab();
            tasksTab.Click();

            var browserTab = _Browser.FindSessionElementByLink("Browser");

            return browserTab;
        }

        private SessionElementScope GetLogOutLink()
        {
            var logoutLink = _Browser.FindSessionElementById("ctl00_PgHeader_LogoutLink");

            return logoutLink;
        }

        private string GetPageTitle()
        {
            var pageTitle = _Browser.Title;

            return pageTitle;
        }

        internal bool IsBrowserOnTasksPage()
        {
            var pageTitle = GetPageTitle();

            if (pageTitle.IndexOf("tasks", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return true;
            }

            return false;
        }

        internal void GoToBrowserPage()
        {
            if (!OnDictionaryBrowserPage())
            {
                var browserTab = GetBrowserTab();
                browserTab.Click();
            }
        }

        private SessionElementScope GetIMedidataLink()
        {
            var iMedidataLink = _Browser.FindSessionElementById("ctl00_PgHeader_LnkIMedidata");

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

            _Browser.GetImedidataPage().WaitForPageToFinishLoading();
        }

        internal bool AdminLinkAvailable(string adminPage)
        {
            if (String.IsNullOrWhiteSpace(adminPage)) throw new ArgumentNullException("adminPage");

            var attempt = FindAdminLink(adminPage);

            var linkAvailable = attempt.Outcome.Equals(OutcomeType.Successful);

            return linkAvailable;
        }

        internal void GoToAdminPage(string adminPage)
        {
            if (String.IsNullOrWhiteSpace(adminPage)) throw new ArgumentNullException("adminPage");

            RetryPolicy.RefreshAndFindHtml.Execute(
                () =>
                {
                    _Browser.Refresh();
                    var attempt = FindAdminLink(adminPage);

                    if (attempt.Outcome == OutcomeType.Failure)
                    {
                        _Browser.GoToHomePage();
                        throw attempt.FinalException;
                    }

                    attempt.Result.Click();
                });
        }

        private PolicyResult<SessionElementScope> FindAdminLink(string adminPage)
        {
            if (String.IsNullOrWhiteSpace(adminPage)) throw new ArgumentNullException("adminPage");

            var attempt = RetryPolicy.FindElementShort.ExecuteAndCapture(
                () =>
                {
                    var administrationMenu = GetAdminMenuHeader();
                    administrationMenu.Hover();
                    administrationMenu.Click();

                    var administrationMenuItem = GetMenuItemByXPath(administrationMenu, adminPage);

                    if (!administrationMenuItem.Exists(Config.ExistsOptions))
                    {
                        throw new MissingHtmlException(String.Format("admin menu item {0} not found", adminPage));
                    }

                    return administrationMenuItem;
                });

            return attempt;
        }

        private SessionElementScope GetMenuItemByXPath(SessionElementScope menuElement, string menuItemName)
        {
            if(ReferenceEquals(menuElement, null))      throw new ArgumentNullException("menuElement");
            if (String.IsNullOrEmpty(menuItemName))     throw new ArgumentNullException("menuItemName");

            var menuItem = menuElement.FindSessionElementByXPath(String.Format("//a[text()='{0}']", menuItemName));

            if (!menuItem.Exists(Config.ExistsOptions))
            {
                menuItem = menuElement.FindSessionElementByXPath(String.Format("//a[text()='{0}']", menuItemName.Replace(" ", String.Empty)));
            }

            return menuItem;
        }

        internal void WaitForSync()
        {
            var syncIndicator = GetSyncIndicator();
            var options       = Config.ExistsOptions;

            if (syncIndicator.Exists(options))
            {
                _Browser.Refresh();
                WaitForSync();
            }
        }

        internal void LogoutFromCoder()
        {
            var logoutLink = GetLogOutLink();

            logoutLink.Click();
        }

        internal void OpenReportHeader()
        {
            var mainReportLink = _Browser.FindSessionElementByLink("Reports");

            mainReportLink.Click();
        }

    }
}
