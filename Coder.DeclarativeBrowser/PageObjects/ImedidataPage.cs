using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class ImedidataPage
    {
        private readonly BrowserSession _Browser;

        internal static readonly string RaveEdcAppName     = "Rave EDC";
        internal static readonly string RaveModulesAppName = "Rave Modules";
        internal static readonly string CoderAppName       = "Coder";

        private readonly IDictionary<string,string> _AppIds = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            {RaveEdcAppName    , "app_type_1" },
            {RaveModulesAppName, "app_type_4" },
            {CoderAppName      , "app_type_9" }
        };

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
            var segmentSearchBox = _Browser.FindSessionElementByXPath("//form[@id='studies_search']//input[@id='search_field_search_terms']");

            return segmentSearchBox;
        }

        private SessionElementScope GetHomeLink()
        {
            var homeLink = _Browser.FindSessionElementByXPath("//a[@title='Home']");

            return homeLink;
        }

        private SessionElementScope GetiMedidataLink()
        {
            var iMedidataLink = _Browser.FindSessionElementByXPath("//a[@class='mcc-logo']");

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

        private SessionElementScope GetManageLink(Func<IList<SessionElementScope>> getRows, string groupName)
        {
            if (String.IsNullOrWhiteSpace(groupName)) throw new ArgumentNullException("groupName");

            var row = GetRow(getRows, groupName);

            var manageLink = row.FindSessionElementByXPath("div[1]/a");

            return manageLink;
        }

        private SessionElementScope GetAppLink(Func<IList<SessionElementScope>> getRows, string groupName, string appName)
        {
            if (String.IsNullOrWhiteSpace(appName)) throw new ArgumentNullException("appName");
            if (String.IsNullOrWhiteSpace(groupName)) throw new ArgumentNullException("groupName");

            var row = GetRow(getRows, groupName);

            var appLink = row.FindSessionElementByLink(appName);

            return appLink;
        }

        private SessionElementScope GetAppLinkAfterSearching(string appName)
        {
            if (String.IsNullOrWhiteSpace(appName)) throw new ArgumentNullException("appName");

            var appLink = _Browser.FindSessionElementByLink(appName);

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

        private SessionElementScope GetAppLink(string appName)
        {
            if (String.IsNullOrWhiteSpace(appName)) throw new ArgumentNullException("appName");

            var appLink = _Browser.FindSessionElementById(appName);

            return appLink;
        }
        
        internal void LoadSegmentForApp(string appName, string segment)
        {
            if (String.IsNullOrEmpty(appName))   throw new ArgumentNullException("appName");
            if (String.IsNullOrEmpty(segment))   throw new ArgumentNullException("segment");
            if (!_AppIds.Keys.Contains(appName)) throw new ArgumentException(String.Format("Unknown application appName, '{0}'", appName));

            bool loadSuccessful = LoadSegmentFromAppList(appName, segment);

            if (!loadSuccessful)
            {
                LoadSearchedSegmentForApp(appName, segment);
            }
        }

        private bool  LoadSegmentFromAppList(string appName, string segment)
        {
            if (String.IsNullOrEmpty(appName))   throw new ArgumentNullException("appName");
            if (String.IsNullOrEmpty(segment))   throw new ArgumentNullException("segment");
            if (!_AppIds.Keys.Contains(appName)) throw new ArgumentException(String.Format("Unknown application appName, '{0}'", appName));
            
            var app = GetAppLink(_AppIds[appName]);

            if (ReferenceEquals(app, null) || String.IsNullOrEmpty(app.Text))
            {
                return false;
            }

            string appText = app.Text.Replace("\r\n", " ");

            if (!appText.Contains(appName, StringComparison.OrdinalIgnoreCase) || !appText.Contains(segment, StringComparison.OrdinalIgnoreCase))
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
        
        private void LoadSearchedSegmentForApp(string segment, string app)
        {
            if (String.IsNullOrEmpty(segment)) throw new ArgumentNullException("segment");
            if (String.IsNullOrEmpty(app)) throw new ArgumentNullException("app");
            
            SearchImedidataSegment(segment);
            
            GetAppLinkAfterSearching(app).Click();
        }

        private void SearchImedidataSegment(string segmentName)
        {
            GetSegmentSearchBox().FillInWith(segmentName);

            GetSegmentSearchButton().Click();
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

            _Browser.GetImedidataPage().WaitForPageToFinishLoading();
        }
    }
}
