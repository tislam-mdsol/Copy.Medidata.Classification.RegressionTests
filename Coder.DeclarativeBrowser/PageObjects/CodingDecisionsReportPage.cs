using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CodingDecisionsReportPage
    {
        private readonly BrowserSession _Browser;
        private const string            PageName = "Coding Decisions Report";

        internal CodingDecisionsReportPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            _Browser = browser;
        }

        internal void GoTo()
        {
            _Browser.GoToReportPage(PageName);
        }

        private SessionElementScope GetVerbatimTextBox()
        {
            var verbatimTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtVerbatimTerm");

            return verbatimTextBox;
        }

        private SessionElementScope GetFromDateTextBox()
        {
            var fromDateTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtWorkflowActionStartDate");
                                                                        
            return fromDateTextBox;
        }

        private SessionElementScope GetToDateTextBox()
        {
            var toDateTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtWorkflowActionEndDate");

            return toDateTextBox;
        }

        private SessionElementScope GetExportButton()
        {
            var exportButton = _Browser.FindSessionElementById("ctl00_Content_btnExportReport");

            return exportButton;
        }

        private SessionElementScope GetIncludeAutocodedItemsCheckbox()
        {
            var includeAutocodedItemsCheckbox = _Browser.FindSessionElementById("ctl00_Content_controlACG_ChkIncludeAutoCodedItems");

            return includeAutocodedItemsCheckbox;
        }

        private SessionElementScope GetCurrentStatusListBox()
        {
            var currentStatus = _Browser.FindSessionElementById("ctl00_Content_controlACG_LstCurrentWorkflowStates");

            return currentStatus;
        }

        private SessionElementScope GetCodedByListBox()
        {
            var currentStatus = _Browser.FindSessionElementById("ctl00_Content_controlACG_LstUsers");

            return currentStatus;
        }

        private SessionElementScope GetCurrentStatus()
        {
            var currentStatus = _Browser.FindSessionElementById("ctl00_Content_controlACG_LstCurrentWorkflowStates");

            return currentStatus;
        }

        private SessionElementScope GetSelectAllCodedBy()
        {
            var currentStatus = _Browser.FindSessionElementById("ctl00_Content_controlACG_LstUsers");

            return currentStatus;
        }

        private IList<SessionElementScope> GetSelectAllCodedByOptions()
        {
            var currentStatusOptions = GetSelectAllCodedBy().FindAllSessionElementsByXPath("option");

            return currentStatusOptions;
        }

        private SessionElementScope GetMoveAllFieldsToRightColumn()
        {
            var moveAllFieldsToRightColumn = _Browser.FindSessionElementById("MoveAllToRight");

            return moveAllFieldsToRightColumn;
        }

        private SessionElementScope GetStudyDropDown()
        {
            var studyDropdown = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlStudies");

            return studyDropdown;
        }

        private SessionElementScope GetDictionaryDropDown()
        {
            var dictionaryDropDown = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlDictionaryAndLocales");

            return dictionaryDropDown;
        }

        private SessionElementScope GetVersionDropDown()
        {
            var versionDropDown = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlDictionaryVersions");

            return versionDropDown;
        }

        internal void SetReportCriteria(CodingDecisionsReportCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");

            GetStudyDropDown()                .SelectOptionAlphanumericOnly(searchCriteria.Study);
            GetVerbatimTextBox()              .SetTextBoxSearchCriteria(searchCriteria.Verbatim);
            GetFromDateTextBox()              .SetTextBoxSearchCriteria(searchCriteria.StartDate);
            GetToDateTextBox()                .SetTextBoxSearchCriteria(searchCriteria.EndDate);
            GetIncludeAutocodedItemsCheckbox().SetCheckBoxState(searchCriteria.IncludeAutoCodedItems);
            GetCurrentStatusListBox()         .SetSingleListBoxOptionCriteria(searchCriteria.CurrentStatus);
            GetCodedByListBox()               .SetSingleListBoxOptionCriteria(searchCriteria.CodedBy);

            if (searchCriteria.AllColumns)
            {
                GetMoveAllFieldsToRightColumn().Click();
            }
        }

        internal void ExportReport()
        {
            var exportButton = GetExportButton();

            exportButton.Click();
        }
    }
}
