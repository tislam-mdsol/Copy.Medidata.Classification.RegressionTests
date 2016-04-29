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

        private void SearchForSite(string siteName)
        {
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("siteName");

            _Session.WaitUntilElementExists(GetStudySearchTextBox);

            var studySearchTextBox = GetStudySearchTextBox();

            studySearchTextBox.FillInWith(siteName).SendKeys(Keys.Return);

            _Session.WaitUntilElementExists(GetStudiesGrid);
        }

        internal void OpenStudy(string studyName)
        {
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");
            
            var searchText = studyName.Split('(').ToArray()[0];

            SearchForSite(searchText);
            
            RetryPolicy.FindElement.Execute(() =>
            {
                var studies = GetStudies();

                if (!studies.Any())
                {
                    throw new MissingHtmlException(String.Format("No Studies were found for search text, {0}",
                        searchText));
                }
                
                var studyLink = studies.FirstOrDefault(x => x.Text.EqualsIgnoreCase(studyName));

                if (ReferenceEquals(studyLink, null))
                {
                    throw new MissingHtmlException(String.Format("Study, {0},  was not found for search text, {1}",
                        studyName, searchText));
                }

                studyLink.Click();
            })
            ;
        }
    }
}
