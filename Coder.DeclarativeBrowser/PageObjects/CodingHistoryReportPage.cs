using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CodingHistoryReportPage
    {
        private readonly BrowserSession _Browser;
        private const string PageName = "Coding History Report";

        internal CodingHistoryReportPage(BrowserSession browser)
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
                var verbatimTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtVerbatim");

                return verbatimTextBox;
        }

        private SessionElementScope GetTermTextBox()
        {
                var termTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtTerm");

                return termTextBox;
        }

        private SessionElementScope GetCodeTextBox()
        {
                var codeTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtCode");

                return codeTextBox;
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

        private SessionElementScope GetMoveAllFieldsToRightColumn()
        {
                var moveAllFieldsToRightColumn = _Browser.FindSessionElementById("MoveAllToRight");

                return moveAllFieldsToRightColumn;
        }

        private SessionElementScope GetMoveAllFieldsToLeftColumn()
        {
                var moveAllFieldsToLeftColumn = _Browser.FindSessionElementById("MoveAllToLeft");

                return moveAllFieldsToLeftColumn;
        }

        private SessionElementScope GetMoveOneToRightButton()
        {
            return _Browser.FindSessionElementById("MoveOneToRight");
        }

        private SessionElementScope GetMoveOneToLeftButton()
        {
            return _Browser.FindSessionElementById("MoveOneToLeft");
        }

        private SessionElementScope GetUnselectedReportColumnsListBox()
        {
            return _Browser.FindSessionElementById("ctl00_Content_ReportColumns");
        }

        private SessionElementScope GetSelectedReportColumnsListBox()
        {
            return _Browser.FindSessionElementById("ctl00_Content_SelectedReportColumns");
        }

        private SessionElementScope GetStudyDropDown()
        {
            var studyDropdown = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlStudies");

            return studyDropdown;
        }

        internal void AddExportColumnToReport(string exportColumn)
        {
            if (String.IsNullOrWhiteSpace(exportColumn)) throw new ArgumentNullException("exportColumn");

            GetUnselectedReportColumnsListBox().SelectOption(exportColumn);

            GetMoveOneToRightButton().Click();
        }

        internal void RemoveExportColumnFromReport(string exportColumn)
        {
            if (String.IsNullOrWhiteSpace(exportColumn)) throw new ArgumentNullException("exportColumn");

            GetSelectedReportColumnsListBox().SelectOption(exportColumn);

            GetMoveOneToLeftButton().Click();
        }

        internal void SetReportCriteria(CodingHistoryReportCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");

            GetStudyDropDown()                .SelectOptionAlphanumericOnly(searchCriteria.Study);
            GetVerbatimTextBox()              .SetTextBoxSearchCriteria(searchCriteria.Verbatim);
            GetTermTextBox()                  .SetTextBoxSearchCriteria(searchCriteria.Term);
            GetCodeTextBox()                  .SetTextBoxSearchCriteria(searchCriteria.Code);
            GetFromDateTextBox()              .SetTextBoxSearchCriteria(searchCriteria.StartDate);
            GetToDateTextBox()                .SetTextBoxSearchCriteria(searchCriteria.EndDate);
            GetIncludeAutocodedItemsCheckbox().SetCheckBoxState(searchCriteria.IncludeAutoCodedItems);
            GetCurrentStatusListBox()         .SetSingleListBoxOptionCriteria(searchCriteria.CurrentStatus);
            GetCodedByListBox()               .SetSingleListBoxOptionCriteria(searchCriteria.CodedBy);

            if (!ReferenceEquals(searchCriteria.ExportColumns, null))
            {
                foreach (string exportColumn in searchCriteria.ExportColumns)
                {
                    AddExportColumnToReport(exportColumn.Trim());
                }
            }

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
