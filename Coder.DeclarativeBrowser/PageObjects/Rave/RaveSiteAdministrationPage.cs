using System;
using Coypu;
using Coder.DeclarativeBrowser.ExtensionMethods;


namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveSiteAdministrationPage
    {
        private readonly BrowserSession _Session;

        private const string _SiteNameHeaderText = "Site Name";
        private const string _SiteLinkHeaderText = "";

        internal RaveSiteAdministrationPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetStudyDropDown()
        {
            var studyDropDown = _Session.FindSessionElementById("_ctl0_Content_StudyDDL");

            return studyDropDown;
        }

        private SessionElementScope GetSearchButton()
        {
            var studyDropDown = _Session.FindSessionElementById("_ctl0_Content_FilterButton");

            return studyDropDown;
        }
        private SessionElementScope GetSiteContentDisplayGrid()
        {
            var siteDisplayGrid = _Session.FindSessionElementById("_ctl0_Content_DisplayGrid");

            return siteDisplayGrid;
        }

        private SessionElementScope GetSiteLink(string siteName)
        {
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("siteName");

            var sitesGrid = GetSiteContentDisplayGrid();

            var siteLinkCell = sitesGrid.FindTableCell(_SiteNameHeaderText, siteName, _SiteLinkHeaderText);

            var siteLink = siteLinkCell.FindSessionElementByXPath(".//a");

            return siteLink;
        }

        internal void OpenSite(string siteName, string studyName)
        {
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("siteName");

            var siteLink = SearchForSiteLink(siteName, studyName);

            if (ReferenceEquals(siteLink, null))
            {
                throw new MissingHtmlException(String.Format("Site, {0}, was not found.", siteName));
            }

            RetryPolicy.FindElement.Execute(() =>
                _Session.TryUntil(
                    () => siteLink.Click(),
                    () => _Session.GetRaveSiteAdministrationPage().GetSiteContentDisplayGrid().Exists(),
                    Config.ExistsOptions.RetryInterval,
                    Config.ExistsOptions)
            );
        }

        private SessionElementScope SearchForSiteLink(string siteName, string studyName)
        {
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("siteName");

            if (ReferenceEquals(GetSiteLink(siteName), null))
            {
                _Session.WaitUntilElementExists(GetStudyDropDown);

                var studyDropDown = GetStudyDropDown();

                studyDropDown.SelectOption(studyName);

                _Session.WaitUntilElementExists(GetSiteContentDisplayGrid);
            }

            return GetSiteLink(siteName);
        }

        internal void OpenSubjectAdministrationForSite(string subjectName, string siteName)
        {
            OpenSite(siteName, subjectName);
            var subjectAdministrationLink = GetSubjectAdministrationLink();
            subjectAdministrationLink.Click();
        }

        private SessionElementScope GetSubjectAdministrationLink()
        {
            var subjectAdministrationLink = _Session.FindSessionElementByXPath("_ctl0_Content_WizardTitleBox_AddStudySiteWzrd_StudyGrid__ctl2_SubjectAdminImgLnks");
            return subjectAdministrationLink;
        }
    }
}
