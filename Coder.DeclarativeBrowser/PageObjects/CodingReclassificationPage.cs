using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;
using FluentAssertions;
using NUnit.Framework;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CodingReclassificationPage
    {
        private readonly BrowserSession _Browser;
        private const int               NumberOfReclassifyTableColumns = 11;
        private const string            PageName                       = "Reclassification";

        internal CodingReclassificationPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        internal bool OnReclassificationPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnReclassificationPage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }

        internal SessionElementScope GetStudyMigrationWarningIndicator()
        {
            var studyMigrationIndicator =
                _Browser.FindSessionElementById("ctl00_Content_StudyMigrationMsg");

            return studyMigrationIndicator;
        }
        
        internal SessionElementScope GetIncludeAutoCodedItemsCheckBox()
        {
            var includeAutoCodedItemsCheckBox =
                _Browser.FindSessionElementById("ctl00_Content_controlACG_ChkIncludeAutoCodedItems");

            return includeAutoCodedItemsCheckBox;
        }

        internal SessionElementScope GetSearchButton()
        {
            var searchButton = _Browser.FindSessionElementById("ctl00_Content_btnSearch");

            return searchButton;
        }

        internal SessionElementScope GetReclassifyGrid()
        {
            var reclassifyGrid = _Browser.FindSessionElementById("ctl00_Content_gridTask_DXMainTable");

            
            return reclassifyGrid;
        }

        internal IList<SessionElementScope> GetReclassifyGridRows()
        {
            var reclassifyGridRows = GetReclassifyGrid().FindAllSessionElementsByXPath("tbody/tr[contains(@id, 'ctl00_Content_gridTask_DXDataRow')]");

            return reclassifyGridRows;
        }

        internal SessionElementScope GetReasonTextArea()
        {
            var reasonTextArea = _Browser.FindSessionElementById("txtComment");

            return reasonTextArea;
        }

        internal SessionElementScope GetReasonOkButton()
        {
            var reasonOkButton = _Browser.FindSessionElementById("ctl00_Content_reasonForReclassify_acg2_GoAheadWithReclassify");

            return reasonOkButton;
        }

        internal SessionElementScope GetVerbatimTextBox()
        {
            var verbatimTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtVerbatim");

            return verbatimTextBox;
        }

        internal SessionElementScope GetPriorStatusListBox()
        {
            var priorStatusOptionList = _Browser
                .FindSessionElementById("ctl00_Content_controlACG_LstPriorWorkflowStates");

            return priorStatusOptionList;
        }

        internal SessionElementScope GetCodedByListBox()
        {
            var priorStatusOptionList = _Browser
                .FindSessionElementById("ctl00_Content_controlACG_LstUsers");

            return priorStatusOptionList;
        }

        internal SessionElementScope GetPriorActionsListBox()
        {
            var priorStatusOptionList = _Browser
                .FindSessionElementById("ctl00_Content_controlACG_LstPriorWorkflowActions");

            return priorStatusOptionList;
        }

        internal SessionElementScope GetCodeTextBox()
        {
            var codeTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtCode");

            return codeTextBox;
        }

        internal SessionElementScope GetTermTextBox()
        {
            var termTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtTerm");

            return termTextBox;
        }

        internal SessionElementScope GetSubjectTextBox()
        {
            var subjectTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtSubject");

            return subjectTextBox;
        }

        internal SessionElementScope GetFromTextBox()
        {
            var fromTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtWorkflowActionStartDate");

            return fromTextBox;
        }

        internal SessionElementScope GetToTextBox()
        {
            var toTextBox = _Browser.FindSessionElementById("ctl00_Content_controlACG_TxtWorkflowActionEndDate");

            return toTextBox;
        }

        internal SessionElementScope GetReclassifyAndRetireButton()
        {
            var reclassifyAndButton = _Browser.FindSessionElementById("ctl00_Content_ReclassifyActions_ReclassifyRestAndDeactivateAutoCodeRules");

            return reclassifyAndButton;
        }

        internal SessionElementScope GetReclassifyGroupButton()
        {
            var getReclassifyGroupButton = _Browser.FindSessionElementById("ctl00_Content_ReclassifyActions_ReclassifyRest");

            return getReclassifyGroupButton;
        }

        internal SessionElementScope GetReclassifyButton()
        {
            var reclassifyButton = _Browser.FindSessionElementById("ctl00_Content_ReclassifyActions_ReClassify");

            return reclassifyButton;
        }

        internal SessionElementScope GetReclassifyButtonByType(ReclassificationTypes reclassificationType)
        {
            if (reclassificationType.Equals(ReclassificationTypes.Reclassify))                  return GetReclassifyButton();
            if (reclassificationType.Equals(ReclassificationTypes.ReclassifyGroup))             return GetReclassifyGroupButton();
            if (reclassificationType.Equals(ReclassificationTypes.ReclassifyAndRetire)
                || reclassificationType.Equals(ReclassificationTypes.ReclassifyGroupAndRetire)) return GetReclassifyAndRetireButton();

            throw new NotFoundException(String.Format("Unable to find Reclassify button based on the reclassification type: {0}", reclassificationType));
        }

        internal SessionElementScope GetReclassifyGridRowByVerbatim(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 

            var reclassifyRowXPath = String.Format("//tr[contains(@id, 'ctl00_Content_gridTask_DXDataRow')]/td[3]//span[text()='{0}']", verbatim.ToUpper());
            var verbatimRow        = _Browser.FindAllSessionElementsByXPath(reclassifyRowXPath).FirstOrDefault();

            if (ReferenceEquals(verbatimRow, null)) throw new MissingHtmlException(String.Format("Unable to find the reclassification row for the verbatim: {0}", verbatim));

            return verbatimRow;
        }

        internal IList<ReclassificationSearch> GetReclassifyTableValues()
        {
            var reclassifyTableValues = new List<ReclassificationSearch>();

            if (IsReclassifyGridEmpty()) { return reclassifyTableValues; }

            var reclassifyGridRows = GetReclassifyGridRows();

            foreach (var row in reclassifyGridRows)
            {
                var rowColumns = row.FindAllSessionElementsByXPath("td");

                Debug.Assert(rowColumns.Count.Equals(NumberOfReclassifyTableColumns),
                    "Not enough reclassifyRowColumns fields provided. Check that the source data has the correct number of columns.");

                var reclassifyRowValues = new ReclassificationSearch
                {
                    Study    = rowColumns[0].Text,
                    Subject  = rowColumns[1].Text,
                    Verbatim = rowColumns[2].Text,
                    Term     = rowColumns[3].Text,
                    Code     = rowColumns[4].Text,
                    Priority = rowColumns[9].Text,
                    Form     = rowColumns[10].Text
                };

                reclassifyTableValues.Add(reclassifyRowValues);
            }

            return reclassifyTableValues;
        }

        //related to mevdownload
        internal SessionElementScope GetTaskGridVerbatimElementByVerbatimTerm(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            var verbatimElementXPath = string.Format("//table[@id = 'ctl00_Content_gridTask_DXMainTable']//span[text() = '{0}']", verbatim.ToUpper());
            var taskGridVerbatimElement = _Browser.FindSessionElementByXPath(verbatimElementXPath);

            return taskGridVerbatimElement;
        }

        internal SessionElementScope GetDictionaryDropDownList()
        {
            var dictionaryDropDownList = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlDictionaryNameAndLocales");

            return dictionaryDropDownList;
        }

        internal SessionElementScope GetVersionDropDownList()
        {
            var versionDropDownList = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlDictionaryVersions");

            return versionDropDownList;
        }

        internal SessionElementScope GetStudyDropDownList()
        {
            var studyDropDownList = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlStudies");

            return studyDropDownList;
        }

        internal string GetPagingLabel()
        {
            var pageSummary = _Browser
                .FindSessionElementByXPath("//table[@id='ctl00_Content_gridTask_DXPagerBottom']//td[@class='dxpSummary_Main_Theme']")
                .Text;

            return pageSummary;
        }

        internal string GetResultsLabel()
        {
            var pageSummary = _Browser
                .FindSessionElementByXPath("//span[@id='ctl00_Content_showWarning_ShowXofYResults']")
                .Text;

            return pageSummary;
        }

        internal IList<ReclassificationSearch> ExecuteSearchAndReturnExpectedResults()
        {
            GetSearchButton().Click();

            var results = GetReclassifyTableValues();

            if(results.Count.Equals(0)) throw new MissingHtmlException("Data rows should be returned");

            return results;
        }

        internal void SearchAndSelectVerbatimRow(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 

            GetSearchButton().Click();
            GetReclassifyGridRowByVerbatim(verbatim).Click();
        }

        internal void AssertThatTaskAvailable(string term, string dictionary, string locale, string version, string includeAutoCodedItems)
        {
            if (String.IsNullOrEmpty(term))                  throw new ArgumentNullException("term");
            if (String.IsNullOrEmpty(dictionary))            throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(locale))                throw new ArgumentNullException("locale");
            if (String.IsNullOrEmpty(version))               throw new ArgumentNullException("version");
            if (String.IsNullOrEmpty(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems");

            //select two ddls, dictionary and version
            GetDictionaryDropDownList().SelectOption(dictionary + " (" + locale + ")");
            GetVersionDropDownList().SelectOption(version);

            if (includeAutoCodedItems.Equals("True", StringComparison.OrdinalIgnoreCase))
            {
                GetIncludeAutoCodedItemsCheckBox().SetCheckBoxState(includeAutoCodedItems);
            }

            RetryPolicy
                .FindElement
                .Execute(() => AssertTermValue(term));
        }

        internal void AssertThatTaskAvailable(ReclassificationSearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null))         throw new ArgumentNullException("searchCriteria");
            if (String.IsNullOrEmpty(searchCriteria.Verbatim)) throw new ArgumentNullException("searchCriteria.Verbatim");

            SetSearchCritera(searchCriteria);
            GetSearchButton().Click();

            GetReclassifyTableValues().Count.Should().Be(0, "Task was found in the reclassify results.");
        }

        internal void SetSearchCritera(ReclassificationSearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");
            
            GetVerbatimTextBox().SetTextBoxSearchCriteria(searchCriteria.Verbatim);
            GetTermTextBox().SetTextBoxSearchCriteria(searchCriteria.Term);
            GetCodeTextBox().SetTextBoxSearchCriteria(searchCriteria.Code);
            GetSubjectTextBox().SetTextBoxSearchCriteria(searchCriteria.Subject);
            GetFromTextBox().SetTextBoxSearchCriteria(searchCriteria.StartDate);
            GetToTextBox().SetTextBoxSearchCriteria(searchCriteria.EndDate);
            GetPriorStatusListBox().SetSingleListBoxOptionCriteria(searchCriteria.PriorStatus);
            GetCodedByListBox().SetSingleListBoxOptionCriteria(searchCriteria.CodedBy);
            GetPriorActionsListBox().SetSingleListBoxOptionCriteria(searchCriteria.PriorActions);
            GetIncludeAutoCodedItemsCheckBox().SetCheckBoxState(searchCriteria.IncludeAutoCodedItems);

            // Select Lists must be set last. There is some conflict with the other elements during their post back.
            GetStudyDropDownList().SelectOptionAlphanumericOnly(searchCriteria.Study);
            GetDictionaryDropDownList().SelectOptionAlphanumericOnly(searchCriteria.DictionaryType);
            GetVersionDropDownList().SelectOptionAlphanumericOnly(searchCriteria.Version);
        }
       
        private bool IsReclassifyGridEmpty()
        {
            var isReclassifyGridEmpty = _Browser
                .FindSessionElementByXPath("//tr[contains(@class, 'dxgvEmptyDataRow_Main_Theme')]")
                .Exists(Config.ExistsOptions);

            return isReclassifyGridEmpty;
        }

        private void AssertTermValue(string term)
        {
            GetSearchButton().Click();
            var termElement = GetTaskGridVerbatimElementByVerbatimTerm(term);
            Assert.That(termElement.InnerHTML, Is.EqualTo(term));
        }

        public void AssertThatAllTasksAreFinishedProcessing(string expectedResultsLabel)
        {
            if (String.IsNullOrWhiteSpace(expectedResultsLabel)) throw new ArgumentNullException("expectedResultsLabel");

            var options = Config.GetDefaultCoypuOptions();

            _Browser.TryUntil(
                () => GetSearchButton().Click(),
                () => GetResultsLabel().Equals(expectedResultsLabel),
                options.WaitBeforeClick,
                options);
        }
    }
}
