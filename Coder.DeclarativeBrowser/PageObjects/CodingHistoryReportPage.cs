using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;
using System.Collections.Generic;
using System.Linq;

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

        private IList<SessionElementScope> GetStatusOptions()
        {
            var allStats = _Browser.FindAllSessionElementsByXPath("//input[contains(@id, 'currentStatus-')]");

            return allStats;
        }

        private void SelectOptions(IEnumerable<string> currentOptions, IList<SessionElementScope> elementsToSelect)
        {
            var optionsToSelect = from element in elementsToSelect
                                  where currentOptions.Contains(element.Text)
                                  select element;

            foreach (var option in optionsToSelect)
            {
                option.Click();
            }
        }

        private IList<SessionElementScope> ExportColumnOptions()
        {
            var currentStatus = _Browser.FindAllSessionElementsByXPath("//input[contains(@id, 'exportColumn-')]");

            return currentStatus;
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

        private SessionElementScope GetDeSelectAllCodedBy()
        {
            var codedBy = _Browser.FindSessionElementById("deSelectAllCodedBy");

            return codedBy;
        }

        private SessionElementScope GetSelectAllCodedBy()
        {
            var codedBy = _Browser.FindSessionElementById("selectAllCodedBy");

            return codedBy;
        }

        private SessionElementScope GetStatusSelectAll()
        {
            var allStatus = _Browser.FindSessionElementById("selectAllStatuses");

            return allStatus;
        }

        private SessionElementScope GetAllColumns()
        {
            var allColumns = _Browser.FindSessionElementById("selectAllExportColumns");

            return allColumns;
        }

        private SessionElementScope GetDeselectExportColumns()
        {
            var deselectColumns = _Browser.FindSessionElementById("deSelectAllExportColumns");

            return deselectColumns;
        }

        private SessionElementScope GetDeselectAllStatus()
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

        private SessionElementScope GetCodingHistoryReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(nameof(descriptionText));

            var enterDescriptionTextbox = _Browser.FindSessionElementById("reportDescription");

            return enterDescriptionTextbox;
        }

        private SessionElementScope GetCreateNewCodingHistoryReportButton()
        {
            var createButton = _Browser.FindSessionElementById("createNew");

            return createButton;
        }

        private SessionElementScope GetTermTextBox()
        {
            var termTextBox = _Browser.FindSessionElementById("term");

            return termTextBox;
        }

        private SessionElementScope GetCodeTextBox()
        {
            var codeTextBox = _Browser.FindSessionElementById("verbatim");

            return codeTextBox;
        }

        private SessionElementScope GetEnterCoderByUserInput()
        {
            var codedByTextBox = _Browser.FindSessionElementByXPath("//input[contains(@role, 'combobox')]");

            return codedByTextBox;
        }

        internal void AddUsersCodedBy(IEnumerable<string> searchUsersToAdd)
        {
            var enterUserTextBox = GetEnterCoderByUserInput();

            foreach (var option in searchUsersToAdd)
            {
                enterUserTextBox.SendKeys(option);
                enterUserTextBox.SendKeys("{ENTER}");
            }
        }

        internal void NewCodingHistoryReportButton()
        {
            var createNewIngReportButton = GetCreateNewCodingHistoryReportButton();

            createNewIngReportButton.Click();
        }

        internal void EnterCodingHistoryReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(nameof(descriptionText));

            var enterDescriptionTextbox = GetCodingHistoryReportDescription(descriptionText);

            enterDescriptionTextbox.FillInWith(descriptionText);
        }

        internal void SetReportCriteria(CodingHistoryReportCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException(nameof(searchCriteria));

            GetStudyDropDown()                 .SelectOptionAlphanumericOnly(searchCriteria.Study);
            GetDictionaryDropDown()            .SelectOptionAlphanumericOnly(searchCriteria.DictionaryLocale);
            GetVersionDropDown()               .SelectOptionAlphanumericOnly(searchCriteria.Version);
            GetVerbatimTextBox()               .SetTextBoxSearchCriteria(searchCriteria.Verbatim);
            GetTermTextBox()                   .SetTextBoxSearchCriteria(searchCriteria.Term);
            GetCodeTextBox()                   .SetTextBoxSearchCriteria(searchCriteria.Code);
            GetToDateTextBox()                 .SetTextBoxSearchCriteria(searchCriteria.EndDate);
            GetFromDateTextBox()               .SetTextBoxSearchCriteria(searchCriteria.StartDate);
            GetIncludeAutocodedItemsCheckbox() .SetCheckBoxState(searchCriteria.IncludeAutoCodedItems);

            AddUsersCodedBy(searchCriteria.CodedByAddUsers);

            if (searchCriteria.IncludeAutoCodedItems.Equals(true)) GetIncludeAutocodedItemsCheckbox().Click();
            else                                                   GetExcludeAutocodedItemsCheckbox().Click();

            if (searchCriteria.StatusOptions.ToString().Equals("None", StringComparison.OrdinalIgnoreCase))         GetDeselectAllStatus().Click();
            else if (searchCriteria.StatusOptions == null)                                                          throw new ArgumentNullException((nameof(searchCriteria.StatusOptions)));
            else if (!(searchCriteria.StatusOptions.ToString().Equals("All", StringComparison.OrdinalIgnoreCase)))  SelectOptions(searchCriteria.StatusOptions, GetStatusOptions());

            if (searchCriteria.ExportColumns.ToString().Equals("None", StringComparison.OrdinalIgnoreCase))         GetDeselectExportColumns().Click();
            else if (searchCriteria.ExportColumns == null)                                                          throw new ArgumentNullException((nameof(searchCriteria.ExportColumns)));
            else if (!(searchCriteria.ExportColumns.ToString().Equals("All", StringComparison.OrdinalIgnoreCase)))  SelectOptions(searchCriteria.ExportColumns, ExportColumnOptions());

            if (searchCriteria.CodedByOptions.ToString().Equals("None", StringComparison.OrdinalIgnoreCase))        GetDeSelectAllCodedBy().Click();
            else if (searchCriteria.CodedByOptions == null)                                                         throw new ArgumentNullException((nameof(searchCriteria.CodedByOptions)));
            else if (!(searchCriteria.CodedByOptions.ToString().Equals("All", StringComparison.OrdinalIgnoreCase))) SelectOptions(searchCriteria.CodedByOptions, GetCodedByUsersSpans());

        }

    }
}
