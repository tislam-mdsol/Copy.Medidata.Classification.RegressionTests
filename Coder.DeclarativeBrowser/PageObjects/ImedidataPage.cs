using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class ImedidataPage
    {
        private readonly BrowserSession _Browser;

        internal const string CoderAppName       = "Coder";
        internal const string RaveEdcAppName     = "Rave EDC";
        internal const string RaveModulesAppName = "Rave Modules";

        internal ImedidataPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser"); 
            
            _Browser = browser;
        }
        
        private SessionElementScope GetIMedidataHomeLink()
        {
            var imedidataLink = GetHomeLink();

            if (!imedidataLink.Exists(Config.ExistsOptions))
            {
                imedidataLink = GetiMedidataLink();
            }

            return imedidataLink;
        }

        private SessionElementScope GetSegmentSearchBox()
        {
            var segmentSearchBox = _Browser.FindSessionElementById("studies_search_term");

            return segmentSearchBox;
        }

        private SessionElementScope GetHomeLink()
        {
            var homeLink = _Browser.FindSessionElementByXPath("//a[@title='Home']");

            return homeLink;
        }

        private SessionElementScope GetiMedidataLink()
        {
            var iMedidataLink = _Browser.FindSessionElementByXPath("//span[@class='mcc-logo']");

            return iMedidataLink;
        }

        private SessionElementScope GetSegmentSearchButton()
        {
            var segmentSearchButton = _Browser.FindSessionElementById("studies_search_submit");

            return segmentSearchButton;
        }

        private SessionElementScope GetNextPageLink()
        {
            var nextPageLink = _Browser.FindSessionElementByXPath("//a[@class='next_label']");

            return nextPageLink;
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Browser.FindSessionElementByXPath("//i[@class='fa spinner-icon']");

            return loadingIndicator;
        }

        private IList<SessionElementScope> GetStudiesAndGroups()
        {
            var studiesTable = _Browser.FindSessionElementById("studies");
            var studyRows    = studiesTable.FindAllSessionElementsByXPath("div/div[contains(@class,'study_row')]");

            return studyRows;
        }

        private IList<SessionElementScope> GetStudies()
        {
            var studiesAndGroups = GetStudiesAndGroups();
            var studies = (
                from study in studiesAndGroups
                where study.Class.IndexOf("study_group", StringComparison.OrdinalIgnoreCase) < 0
                select study).ToList();

            return studies;
        }

        private IList<SessionElementScope> GetStudyGroups()
        {
            var studiesAndGroups = GetStudiesAndGroups();
            var studyGroups = (
                from study in studiesAndGroups
                where study.Class.IndexOf("study_group", StringComparison.OrdinalIgnoreCase) >= 0
                select study).ToList();

            return studyGroups;
        }

        private Tuple<SessionElementScope, SessionElementScope> GetStudyLinks(string studyName)
        {
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");

            var links = GetLinks(GetStudies, studyName);

            return links;
        }

        private Tuple<SessionElementScope, SessionElementScope> GetStudyGroupLinks(string groupName)
        {
            if (String.IsNullOrWhiteSpace(groupName)) throw new ArgumentNullException("groupName");

            var links = GetLinks(GetStudyGroups, groupName);

            return links;
        }
        
        private SessionElementScope GetStudiesGrid()
        {
            var studiesGrid = _Browser.FindSessionElementById("studies");

            return studiesGrid;
        }

        private IEnumerable<SessionElementScope> GetStudyGridLinks()
        {
            var studiesGrid = GetStudiesGrid();

            var studyGridLinks = studiesGrid.FindAllSessionElementsByXPath(".//a");

            return studyGridLinks;
        }

        private SessionElementScope GetAppLinkAfterSearching(string appName)
        {
            if (String.IsNullOrWhiteSpace(appName)) throw new ArgumentNullException("appName");

            var appLinks = GetStudyGridLinks();

            var appLink = appLinks.FirstOrDefault(x => x.Text.EqualsIgnoreCase(appName));

            if (ReferenceEquals(appLink, null))
            {
                appLink = appLinks.FirstOrDefault(x => x.Text.Contains(appName, StringComparison.OrdinalIgnoreCase));
            }

            if (ReferenceEquals(appLink, null))
            {
                throw new MissingHtmlException(String.Format("Could not find a link to app {0}", appName));
            }

            return appLink;
        }

        private Tuple<SessionElementScope, SessionElementScope> GetLinks(Func<IList<SessionElementScope>> getRows, string rowName)
        {
            if (String.IsNullOrWhiteSpace(rowName)) throw new ArgumentNullException("rowName");

            var row = GetRow(getRows, rowName);
            
            var manageLink = row.FindSessionElementByXPath("div[1]/a");

            var coderLink  = row.FindSessionElementByXPath("div[2]/div/a");

            var links = Tuple.Create(manageLink, coderLink);

            return links;
        }

        private SessionElementScope GetRow(Func<IList<SessionElementScope>> getRows, string rowName)
        {
            if (ReferenceEquals(getRows,null))      throw new ArgumentNullException("getRows");
            if (String.IsNullOrWhiteSpace(rowName)) throw new ArgumentNullException("rowName");

            var rows = getRows();
            var row  = rows.FirstOrDefault(x => x.Text.IndexOf(rowName, StringComparison.OrdinalIgnoreCase) >= 0);

            if (ReferenceEquals(row, null))
            {
                var nextPageLink = GetNextPageLink();

                if (nextPageLink.Exists())
                {
                    nextPageLink.Click();
                    _Browser.WaitUntilElementDisappears(GetLoadingIndicator);
                    row = GetRow(getRows, rowName);
                }
                else
                {
                    throw new ArgumentException(String.Format("{0} not found", rowName));
                }
            }

            return row;
        }
        
        private SessionElementScope GetAppsGrid()
        {
            var appsGrid = _Browser.FindSessionElementById("apps");

            return appsGrid;
        }

        private SessionElementScope GetApp(string appName)
        {
            if (String.IsNullOrWhiteSpace(appName)) throw new ArgumentNullException("appName");

            var appsGrid = GetAppsGrid();

            var apps = appsGrid.FindAllSessionElementsByXPath("div");
            
            var app = apps.FirstOrDefault(x => x.Text.Replace("\r\n", " ").Contains(appName, StringComparison.OrdinalIgnoreCase));

            return app;
        }

        private SessionElementScope GetUserMenu()
        {
            var userMenu = _Browser.FindSessionElementById("user");

            return userMenu;
        }

        private SessionElementScope GetUserMenuLink()
        {
            var userMenuList = GetUserMenu().FindSessionElementById("username");

            return userMenuList;
        }

        private IList<SessionElementScope> GetUserMenuItems()
        {
            GetUserMenuLink().Click();

            var menuItems = GetUserMenu().FindAllSessionElementsByXPath("ul/li/a");

            return menuItems;
        }

        private SessionElementScope GetLogoutLink()
        {
            var logoutLink = _Browser.FindSessionElementById("logout");

            return logoutLink;
        }

        internal void LoadSegmentForApp(string appName, string segment)
        {
            if (String.IsNullOrEmpty(appName))   throw new ArgumentNullException("appName");
            if (String.IsNullOrEmpty(segment))   throw new ArgumentNullException("segment");

            bool loadSuccessful = LoadSegmentFromAppList(appName, segment);

            if (!loadSuccessful)
            {
                LoadSearchedSegmentForApp(appName, segment);
            }
        }

        private bool LoadSegmentFromAppList(string appName, string segment)
        {
            if (String.IsNullOrEmpty(appName))   throw new ArgumentNullException("appName");
            if (String.IsNullOrEmpty(segment))   throw new ArgumentNullException("segment");

            var serachAppName = appName;

            if (appName.Contains(ImedidataPage.CoderAppName, StringComparison.OrdinalIgnoreCase))
            {
                serachAppName = ImedidataPage.CoderAppName;
            }
            
            var app = GetApp(serachAppName);

            if (ReferenceEquals(app, null) || String.IsNullOrEmpty(app.Text))
            {
                return false;
            }

            string appText = app.Text.Replace("\r\n", " ");

            if (!appText.Contains(serachAppName, StringComparison.OrdinalIgnoreCase) || !appText.Contains(segment, StringComparison.OrdinalIgnoreCase))
            {
                return false;
            }

            var segmentLinks = app.FindAllSessionElementsByXPath("div/a");
            var segmentLink = segmentLinks.FirstOrDefault(x => x.Text.EqualsIgnoreCase(segment));

            if (ReferenceEquals(segmentLink, null))
            {
                return false;
            }
 
            segmentLink.Click();

            return true;
        }
        
        private void LoadSearchedSegmentForApp(string app, string segment)
        {
            if (String.IsNullOrEmpty(app))     throw new ArgumentNullException("app");
            if (String.IsNullOrEmpty(segment)) throw new ArgumentNullException("segment");

            SearchImedidataSegment(segment);

            RetryPolicy.FindElement.Execute(()=> GetAppLinkAfterSearching(app).Click());
        }

        private void SearchImedidataSegment(string segmentName)
        {
            GetSegmentSearchBox().FillInWith(segmentName).SendKeys(Keys.Return);
        }

        internal ImedidataStudyGroupPage ManageSegment(string studyGroup)
        {
            if (String.IsNullOrEmpty(studyGroup)) throw new ArgumentNullException("studyGroup");

            var links = GetStudyGroupLinks(studyGroup);

            links.Item1.Click();

            return _Browser.GetImedidataStudyGroupPage();
        }

        internal ImedidataStudyPage ManageStudy(string studyName)
        {
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");

            var links = GetStudyLinks(studyName);

            links.Item1.Click();

            return _Browser.GetImedidataStudyPage();
        }

        internal void WaitForPageToFinishLoading()
        {
            _Browser.RetryUntilTimeout(() => GetIMedidataHomeLink().Exists(Config.ExistsOptions), Config.GetLoadingCoypuOptions());
        }
        
        internal bool IMedidataLinkExists()
        {
            var iMedidataLink = GetIMedidataHomeLink();

            return iMedidataLink.Exists(Config.ExistsOptions);
        }

        internal void GoToIMedidata()
        {
            var iMedidataLink = GetIMedidataHomeLink();

            iMedidataLink.Click();

            WaitForPageToFinishLoading();
        }

        internal void OpenStudyGroupPage()
        {
            var adminLink =
                GetUserMenuItems().FirstOrDefault(x => x.Text.Contains("Admin", StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(adminLink, null) || !adminLink.Exists(Config.ExistsOptions))
            {
                throw new MissingHtmlException("Admin link not found");
            }

            adminLink.Click();
            _Browser.FindLink("Study Groups").Click();
        }
        
        private IEnumerable<SessionElementScope> GetInvitationAcceptLinks()
        {
            var invitationAcceptLinks =
                _Browser.FindAllSessionElementsByXPath("//a[(contains(@id, 'accept_study_group_invitation_'))]");

            return invitationAcceptLinks;
        }

        internal void AcceptAllStudyGroupInvitations()
        {
            var invitationAcceptLinks = GetInvitationAcceptLinks();

            foreach (var invitationAcceptLink in invitationAcceptLinks)
            {
                invitationAcceptLink.Click();
            }
        }

        internal bool Logout()
        {
            GetUserMenuLink().Click();

            if (!GetLogoutLink().Exists(Config.ExistsOptions))
            {
                return false;
            }

            GetLogoutLink().Click();

            return true;
        }
    }
}
