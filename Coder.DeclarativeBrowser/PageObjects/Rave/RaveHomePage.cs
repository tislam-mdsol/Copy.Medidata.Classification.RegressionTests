using Coypu;
using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveHomePage
    {
        private readonly BrowserSession _Session;
        
        internal RaveHomePage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetStudiesSearchLabel()
        {
            var studiesSearchLabel = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_lblFind");

            return studiesSearchLabel;
        }

        private SessionElementScope GetStudySearchTextBox()
        {
            var studySearchTextBox = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_txtSearch");

            return studySearchTextBox;
        }

        private SessionElementScope GetStudySearchButton()
        {
            var studySearchButton = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_ibSearch");

            return studySearchButton;
        }

        private SessionElementScope GetStudiesGrid()
        {
            var studiesGrid = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_dgObjects");

            return studiesGrid;
        }

        private IList<SessionElementScope> GetStudies()
        {
            var studiesGrid = GetStudiesGrid();

            var studies = studiesGrid.FindAllSessionElementsByXPath(".//a");

            return studies.ToList();
        }

        internal void SearchForStudy(string study)
        {
            if (String.IsNullOrWhiteSpace(study)) throw new ArgumentNullException("study");

            _Session.WaitUntilElementExists(GetStudySearchTextBox);

            var studySearchTextBox = GetStudySearchTextBox();

            var searchText = study.GetRaveSearchText();

            studySearchTextBox.FillInWith(searchText).SendKeys(Keys.Return);
        }

        internal bool IsHomePageLoaded()
        {
            bool searchLabelExists = GetStudiesSearchLabel().Exists(Config.ExistsOptions);

            if (!searchLabelExists)
            {
                return false;
            }

            bool pageIsLoaded = GetStudiesSearchLabel().Text.Equals("Study");

            return pageIsLoaded;
        }
        
        internal void OpenStudy(string studyName)
        {
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");
            
            RetryPolicy.FindElement.Execute(() =>
            {
                var studies = GetStudies();

                if (!studies.Any())
                {
                    throw new MissingHtmlException("No Studies were found.");
                }
                
                var studyLink = studies.FirstOrDefault(x => x.Text.EqualsIgnoreCase(studyName));

                if (ReferenceEquals(studyLink, null))
                {
                    throw new MissingHtmlException(String.Format("Study, {0}, was not found.", studyName));
                }

                studyLink.Click();
            });
        }
    }
}
