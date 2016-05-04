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
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException(nameof(browser));
            _Browser = browser;
        }

        internal void GoTo()
        {
            _Browser.GoToReportPage(PageName);
        }

        private SessionElementScope GetVerbatimTextBox()
        {
            var verbatimTextBox = _Browser.FindSessionElementById("verbatim");

            return verbatimTextBox;
        }

        private SessionElementScope GetFromDateTextBox()
        {
            var fromDateTextBox = _Browser.FindSessionElementById("startDate");
                                                                        
            return fromDateTextBox;
        }

        private SessionElementScope GetToDateTextBox()
        {
            var toDateTextBox = _Browser.FindSessionElementById("endDate");

            return toDateTextBox;
        }

        private SessionElementScope GetIncludeAutocodedItemsCheckbox()
        {
            var includeAutocodedItemsCheckbox = _Browser.FindSessionElementById("autoCodeItemYes");

            return includeAutocodedItemsCheckbox;
        }

        private SessionElementScope GetExcludeAutocodedItemsCheckbox()
        {
            var excludeAutocodedItemsCheckbox = _Browser.FindSessionElementById("autoCodeItemNo");

            return excludeAutocodedItemsCheckbox;
        }

        private SessionElementScope GetSingleStatusOption(string currentStatus)
        {
            var allStatus = _Browser.FindAllSessionElementsByXPath("//input[contains(@id, 'currentStatus-')]");

            foreach (var item in allStatus)
            {
                if (item.Text == currentStatus) return item;
            }

            throw new ArgumentNullException("Unable to find matching status: " + nameof(currentStatus));
        }

        private IList<SessionElementScope> GetExportColumnOptions()
        {
            var currentStatus = _Browser.FindAllSessionElementsByXPath("//input[contains(@id, 'exportColumn-')]");

            return currentStatus;
        }

        private SessionElementScope GetExportSingleOption(string exportOption)
        {
            var allExportOptions = GetExportColumnOptions();

            foreach (var item in allExportOptions)
            {
                if (item.Text == exportOption) return item;
            }

            throw new ArgumentNullException("Unable to find matching status: " + nameof(exportOption));
        }

        private IList<SessionElementScope> GetCodedByUsersSpans()
        {
            var userSpans = _Browser.FindAllSessionElementsByXPath("//span[contains(@class, 'ui-select-match-item btn btn-default btn-xs')]");

            return userSpans;         
        }

        private SessionElementScope RemoveCodedByUser(string userText)
        {
            var userSpans = GetCodedByUsersSpans();

            foreach (var parentSpan in userSpans)
            {
                if (parentSpan.Text == userText)
                {
                  var closeSpan = parentSpan.FindSessionElementByXPath("//span[contains(@class, 'close ui-select-match')]");

                    return closeSpan;
                }
            }

            throw new ArgumentNullException("Unable to find matching user text: " + nameof(userText));
        }
       
        private SessionElementScope GetSelectAllCodedBy()
        {
            var codedBy = _Browser.FindSessionElementById("selectAllCodedBy");

            return codedBy;
        }

        private SessionElementScope GetDeSelectAllCodedBy()
        {
            var codedBy = _Browser.FindSessionElementById("deSelectAllCodedBy");

            return codedBy;
        }

        private SessionElementScope GetStatusAll()
        {
            var allStatus = _Browser.FindSessionElementById("selectAllStatuses");

            return allStatus;
        }

        private SessionElementScope GetAllColumns()
        {
            var allColumns = _Browser.FindSessionElementById("selectAllExportColumns");

            return allColumns;
        }
        
        private SessionElementScope GetStatusDeselectAll()
        {
            var allColumns = _Browser.FindSessionElementById("deSelectAllStatuses");

            return allColumns;
        }

        private SessionElementScope GetStudyDropDown()
        {
            var studyDropdown = _Browser.FindSessionElementById("study");

            return studyDropdown;
        }

        private SessionElementScope GetDictionaryDropDown()
        {
            var dictionaryDropDown = _Browser.FindSessionElementById("dictionaryType");

            return dictionaryDropDown;
        }

        private SessionElementScope GetVersionDropDown()
        {
            var versionDropDown = _Browser.FindSessionElementById("dictionaryVersion");

            return versionDropDown;
        }

        private SessionElementScope GetCodingDecisionsReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(nameof(descriptionText));

            var enterDescriptionTextbox = _Browser.FindSessionElementById("reportDescription");

            return enterDescriptionTextbox;
        }

        private SessionElementScope GetCreateNewCodingDecisionsReportButton()
        {
            var createButton = _Browser.FindSessionElementById("createNew");

            return createButton;
        }

        internal void NewCodingDecisionsReportButton()
        {
            var createNewIngReportButton = GetCreateNewCodingDecisionsReportButton();

            createNewIngReportButton.Click();
        }

        internal void EnterCodingDecisionsReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(nameof(descriptionText));

            var enterDescriptionTextbox = GetCodingDecisionsReportDescription(descriptionText);

            enterDescriptionTextbox.FillInWith(descriptionText);
        }

        internal void SetDefaultReportCriteria(CodingDecisionsReportCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException(nameof(searchCriteria));

            GetStudyDropDown()                                 .SelectOptionAlphanumericOnly(searchCriteria.Study);
            GetDictionaryDropDown()                            .SelectOptionAlphanumericOnly(searchCriteria.Dictionary);
            GetVersionDropDown()                               .SelectOptionAlphanumericOnly(searchCriteria.VersionLocale);

            GetVerbatimTextBox()                               .SetTextBoxSearchCriteria(searchCriteria.Verbatim);
            GetToDateTextBox()                                 .SetTextBoxSearchCriteria(searchCriteria.EndDate);
            GetFromDateTextBox()                               .SetTextBoxSearchCriteria(searchCriteria.StartDate);

            GetExportSingleOption(searchCriteria.SingleColumn)                                                         .Click();
            GetSingleStatusOption(searchCriteria.SingleStatus)                                                         .Click();

            if (searchCriteria.AllStatus  == true && GetStatusAll().Exists())        GetStatusAll()                    .Click();
            if (searchCriteria.AllColumns == true && GetAllColumns().Exists())       GetAllColumns()                   .Click();
            if (searchCriteria.AllCodedBy == true && GetSelectAllCodedBy().Exists()) GetSelectAllCodedBy()             .Click();
            if (searchCriteria.IncludeAutoCodedItems.Equals(true))                   GetIncludeAutocodedItemsCheckbox().Click();
            else                                                                     GetExcludeAutocodedItemsCheckbox().Click();            
        }

    }
}
