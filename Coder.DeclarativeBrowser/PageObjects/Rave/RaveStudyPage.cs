using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System.Linq;
using System.Collections.Generic;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveStudyPage
    {
        private readonly BrowserSession _Session;

        internal RaveStudyPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetAddSubjectLink()
        {
            var addSubjectLink = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_lbAddSubject");

            return addSubjectLink;
        }

        private SessionElementScope GetSubjectSearchTextBox()
        {
            var subjectSearchTextBox = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_txtSearch");

            return subjectSearchTextBox;
        }

        private SessionElementScope GetSubjectSearchButton()
        {
            var subjectSearchButton = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_ibSearch");

            return subjectSearchButton;
        }

        private SessionElementScope GetSubjectsGrid()
        {
            var subjectsGrid = _Session.FindSessionElementById("_ctl0_Content_ListDisplayNavigation_dgObjects");

            return subjectsGrid;
        }

        private IList<SessionElementScope> GetSubjects()
        {
            var subjectsGrid = GetSubjectsGrid();

            var subjects = subjectsGrid.FindAllSessionElementsByXPath(".//a");

            return subjects.ToList();
        }
        
        internal void SearchForSubject(string subjectId)
        {
            if (String.IsNullOrWhiteSpace(subjectId)) throw new ArgumentNullException("subjectId");

            _Session.WaitUntilElementExists(GetSubjectSearchTextBox);

            var subjectSearchTextBox = GetSubjectSearchTextBox();

            subjectSearchTextBox.FillInWith(subjectId).SendKeys(Keys.Return);
        }
        
        internal void OpenSubject(string subjectId)
        {
            if (String.IsNullOrWhiteSpace(subjectId)) throw new ArgumentNullException("subjectId");
            
            RetryPolicy.FindElement.Execute(() =>
            {
                var subjects = GetSubjects();

                if (!subjects.Any())
                {
                    throw new MissingHtmlException(String.Format("No Subjects were found for search text, {0}.",
                        subjectId));
                }

                var subjectLink = subjects.FirstOrDefault(x => x.Text.EqualsIgnoreCase(subjectId));

                if (ReferenceEquals(subjectLink, null))
                {
                    throw new MissingHtmlException(String.Format("Subject, {0}, was not found.",
                        subjectId));
                }

                subjectLink.Click();
            });
        }
        
        internal bool IsSubjectsGridLoaded()
        {
            return GetSubjectsGrid().Exists(Config.ExistsOptions);
        }
        
        internal void OpenAddSubjectPage()
        {
            _Session.WaitUntilElementExists(GetAddSubjectLink);

            var addSubjectLink = GetAddSubjectLink();

            addSubjectLink.Click();
        }
    }
}
