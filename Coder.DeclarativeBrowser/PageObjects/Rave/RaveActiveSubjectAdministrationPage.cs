using System;
using System.Collections.Generic;
using Coypu;
using Coder.DeclarativeBrowser.ExtensionMethods;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveActiveSubjectAdministrationPage
    {
        private readonly BrowserSession _Session;

        private const string _SubjectNameHeaderText = "Subject Name";
        private const string _SubjectEditLinkHeaderText = "Edit";
        private const string _SubjectActiveCheckboxHeaderText = "Active";

        internal RaveActiveSubjectAdministrationPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private void SearchSubjectByName(string subjectName)
        {
            GetSearchSubjectTextbox().FillInWith(subjectName);
            GetSearchButton().Click();
        }

        private void DeactivateSubjectByName(string subjectName)
        {
            SearchSubjectByName(subjectName);
            GetSubjectLink(subjectName).Click();
            GetActiveCheckBox(subjectName).Uncheck();
            GetUpdateLink(subjectName).Click();

        }

        private object GetUpdateLink(string subjectName)
        {
            if (String.IsNullOrWhiteSpace(subjectName)) throw new ArgumentNullException("subjectName");

            var subjectsGrid = GetSubjectDisplayGrid();

            var updateLinkCell = subjectsGrid.FindTableCell(_SubjectNameHeaderText, subjectName, _SubjectActiveCheckboxHeaderText);

            var updateLinks = updateLinkCell.FindAllSessionElementsByXPath(".//a").ToArray();

            return activeLink;
        }
        ccsdsds
        private SessionElementScope GetActiveCheckBox(string subjectName)
        {
            if (String.IsNullOrWhiteSpace(subjectName)) throw new ArgumentNullException("subjectName");

            var subjectsGrid = GetSubjectDisplayGrid();

            var activeLinkCell = subjectsGrid.FindTableCell(_SubjectNameHeaderText, subjectName, _SubjectActiveCheckboxHeaderText);

            var activeLink = activeLinkCell.FindSessionElementByXPath(".//input");

            return activeLink;
        }

        private SessionElementScope GetSubjectLink(string subjectName)
        {
            if (String.IsNullOrWhiteSpace(subjectName)) throw new ArgumentNullException("subjectName");

            var subjectsGrid = GetSubjectDisplayGrid();

            var subjectLinkCell = subjectsGrid.FindTableCell(_SubjectNameHeaderText, subjectName, _SubjectEditLinkHeaderText);

            var subjectLink = subjectLinkCell.FindSessionElementByXPath(".//a");

            return subjectLink;
        }

        private SessionElementScope GetSubjectDisplayGrid()
        {
            var subjectDisplayGrid = _Session.FindSessionElementById("_ctl0_Content_DisplayGrid");

            return subjectDisplayGrid;
        }

        private SessionElementScope GetSearchButton()
        {
            var searchButton = _Session.FindSessionElementById("_ctl0_Content_FilterButton");

            return searchButton;
        }

        private SessionElementScope GetSearchSubjectTextbox()
        {
            var searchSubjectTextbox = _Session.FindSessionElementById("_ctl0_Content_SubjectNameBox");

            return searchSubjectTextbox;
        }


    }
}
