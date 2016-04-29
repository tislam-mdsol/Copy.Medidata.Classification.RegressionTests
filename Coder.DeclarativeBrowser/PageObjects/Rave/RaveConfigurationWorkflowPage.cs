using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveConfigurationWorkflowPage
    {
        /* 
           The main Coder focus on this page is to restore global configuration values for Rave-Coder scenarios.
           The Rave global configuration upload file has row 9 for both marking and review groups as the 
           Coder defaulted rows that need to be reset.   
        */

        private const int _ReviewGroupEditButtonIndex  = 3;
        private const int _MarkingGroupEditButtonIndex = 4;
        private const int _CoderGroupDefaultIndex = 9; 

        private string _coderReviewGroupNameDefault  = "Coder Review Group";
        private string _coderMarkingGroupNameDefault = "site from system";

        private readonly BrowserSession _Session;
        
        internal RaveConfigurationWorkflowPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetConfigurationOtherSettingsLink()
        {
            var otherSettingsLink = _Session.FindSessionElementByLink("Other Settings");

            return otherSettingsLink;
        }

        private SessionElementScope GetReviewGroupTable()
        {
            var reviewGroupTable = _Session.FindSessionElementById("_ctl0_Content_ReviewGroupsGrid");

            return reviewGroupTable;
        }

        private IList<SessionElementScope> GetReviewTableRows()
        {
            var reviewGroupTable = GetReviewGroupTable();
            var reviewGroupRows  = reviewGroupTable.FindAllSessionElementsByXPath(".//tr");

            return reviewGroupRows;
        }             

        private SessionElementScope GetReviewGroupTableRow(int rowNumber)
        {
            var reviewGroupTableRows = GetReviewTableRows(); 

            var reviewGroupRow       = reviewGroupTableRows.ElementAtOrDefault(rowNumber);

            if (ReferenceEquals(reviewGroupRow, null))
            {
                throw new MissingHtmlException(String.Format("No review group row found at index {0}", rowNumber));
            }

            return reviewGroupRow;
        }

        private SessionElementScope GetReviewGroupEditButton(int rowNumber)
        {
            var reviewGroupTableRow   = GetReviewGroupTableRow(rowNumber);
            var reviewGroupCells      = reviewGroupTableRow.FindAllSessionElementsByXPath("td");
            var reviewGroupEditButton = reviewGroupCells[_ReviewGroupEditButtonIndex];
            
            return reviewGroupEditButton;
        }

        private SessionElementScope GetReviewGroupNameTextBox(int rowNumber)
        {
            var reviewGroupTableRow    = GetReviewGroupTableRow(rowNumber);
            var reviewGroupNameTextBox = reviewGroupTableRow.FindSessionElementById("_ctl0_Content_ReviewGroupsGrid__ctl10_ReviewGroupName");

            return reviewGroupNameTextBox;
        }

        private SessionElementScope GetReviewGroupActiveCheckBox(int rowNumber)
        {
            var reviewGroupTableRow       = GetReviewGroupTableRow(rowNumber);
            var reviewGroupActiveCheckBox = reviewGroupTableRow.FindSessionElementById("_ctl0_Content_ReviewGroupsGrid__ctl10_ReviewGroupActive");

            return reviewGroupActiveCheckBox;
        }

        private SessionElementScope GetReviewGroupUpdateLink(int rowNumber)
        {
            var reviewGroupTableRow   = GetReviewGroupTableRow(rowNumber);
            var reviewGroupUpdateLink = reviewGroupTableRow.FindSessionElementByLink("Update");

            return reviewGroupUpdateLink;
        }

        private SessionElementScope GetMarkingGroupTable()
        {
            var markingGroupTable = _Session.FindSessionElementById("_ctl0_Content_MarkingGroupsGrid");

            return markingGroupTable;
        }

        private IList<SessionElementScope> GetMarkingGroupTableRows()
        {
            var markingGroupTable = GetMarkingGroupTable();
            var markingGroupRows  = markingGroupTable.FindAllSessionElementsByXPath(".//tr");

            return markingGroupRows;
        }

        private SessionElementScope GetMarkingGroupTableRow(int rowNumber)
        {
            var markingGroupTableRows = GetMarkingGroupTableRows();

            var markingGroupRow       = markingGroupTableRows.ElementAtOrDefault(rowNumber);

            if (ReferenceEquals(markingGroupRow, null))
            {
                throw new MissingHtmlException(String.Format("No marking group row found at index {0}", rowNumber));
            }

            return markingGroupRow;
        }

        private SessionElementScope GetMarkingGroupEditButton(int rowNumber)
        {
            var markingGroupTableRow   = GetMarkingGroupTableRow(rowNumber);
            var markingGroupCells      = markingGroupTableRow.FindAllSessionElementsByXPath("td");
            var markingGroupEditButton = markingGroupCells[_MarkingGroupEditButtonIndex];

            return markingGroupEditButton;
        }

        private SessionElementScope GetMarkingGroupNameTextBox(int rowNumber)
        {
            var markingGroupTableRow    = GetMarkingGroupTableRow(rowNumber);
            var markingGroupNameTextBox = markingGroupTableRow.FindSessionElementById("_ctl0_Content_MarkingGroupsGrid__ctl10_MarkingGroupName");

            return markingGroupNameTextBox;
        }

        private SessionElementScope GetMarkingGroupActiveCheckBox(int rowNumber)
        {
            var markingGroupTableRow       = GetMarkingGroupTableRow(rowNumber);
            var markingGroupActiveCheckBox = markingGroupTableRow.FindSessionElementById("_ctl0_Content_MarkingGroupsGrid__ctl10_MarkingGroupActive");

            return markingGroupActiveCheckBox;
        }

        private SessionElementScope GetMarkingGroupUpdateLink(int rowNumber)
        {
            var markingGroupTableRow   = GetMarkingGroupTableRow(rowNumber);
            var markingGroupUpdateLink = markingGroupTableRow.FindSessionElementByLink("Update");

            return markingGroupUpdateLink;
        }

    }
}
