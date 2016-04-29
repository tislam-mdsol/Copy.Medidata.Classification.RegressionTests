using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal class SynonymApprovalPage
    {
        private readonly BrowserSession _Browser;
        private const string PageName                = "Synonym Approval";
        private const string SynonymListOptionFormat = "{0} ({1})";
        private const int VerbatimIndex              = 0;
        private const int CodedByIndex               = 1;
        private const int DictionaryLocaleIndex      = 2;
        private const int TermPathIndex              = 3;
        private const int CreateDateIndex            = 4;
        private const int ListNameIndex              = 5;

        public const string DateFilterOptionAll              = "All Dates";
        public const string DateFilterOptionToday            = "Today";
        public const string DateFilterOptionSeven            = "Last Seven Days";
        public const string DateFilterOptionSevenToFourteen  = "Between Seven And Fourteen Days";
        public const string DateFilterOptionFourteenToThirty = "Between Fourteen And Thirty Days";
        public const string DateFilterOptionThirty           = "Older Than Thirty Days";

        internal SynonymApprovalPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null))
            {
                throw new ArgumentNullException("browser");
            }

            _Browser = browser;
        }

        internal bool OnSynonymApprovalPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnSynonymApprovalPage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }
        
        private SessionElementScope GetStudySelectList()
        {
            var studySelectList = _Browser.FindSessionElementById("ctl00_Content_acg1_ddlStudies");

            return studySelectList;
        }

        private SessionElementScope GetDictionarySelectList()
        {
            var dictionarySelectList = _Browser.FindSessionElementById("ctl00_Content_acg1_ddlDictionaryLocales");

            return dictionarySelectList;
        }

        private SessionElementScope GetSynonymListSelectList()
        {
            var synonymListSelectList = _Browser.FindSessionElementById("ctl00_Content_acg1_ddlSynonymLists");

            return synonymListSelectList;
        }

        private SessionElementScope GetDateRangeSelectList()
        {
            var dateRangeSelectList = _Browser.FindSessionElementById("ctl00_Content_ddlDates");

            return dateRangeSelectList;
        }

        private SessionElementScope GetSearchText()
        {
            var searchText = _Browser.FindSessionElementById("ctl00_Content_acg2_searchString");

            return searchText;
        }

        private SessionElementScope GetSearchButton()
        {
            var searchButton = _Browser.FindSessionElementById("ctl00_Content_acg2_SearchButtonLnk");

            return searchButton;
        }

        private SessionElementScope GetRetireSynonymsButton()
        {
            var retireSynonymsButton = _Browser.FindSessionElementById("ctl00_Content_RetireSynonyms");

            return retireSynonymsButton;
        }

        private SessionElementScope GetActivateSynonymsButton()
        {
            var activateSynonymsButton = _Browser.FindSessionElementById("ctl00_Content_ActivateSynonyms");

            return activateSynonymsButton;
        }

        private SessionElementScope GetSynonymsTable()
        {
            var synonymsTable = _Browser.FindSessionElementById("ctl00_Content_synApprovals_DXMainTable");

            return synonymsTable;
        }

        private SessionElementScope GetFirstSynonymRow()
        {
            var firstRow = _Browser.FindSessionElementById("ctl00_Content_synApprovals_DXDataRow0");

            return firstRow;
        }

        private IList<SessionElementScope> GetSynonymElements()
        {
            WaitUntilFinishLoading();

            var synonymsTable = GetSynonymsTable();
            var synonymRowElements =
                synonymsTable.FindAllSessionElementsByXPath(
                    ".//tr[@id[starts-with(.,'ctl00_Content_synApprovals_DXDataRow')]]");

            return synonymRowElements;
        }

        private SessionElementScope GetSynonymRowElement(SynonymRow synonymToSelect)
        {
            if (ReferenceEquals(synonymToSelect, null)) throw new ArgumentNullException("synonymToSelect");

            var synonymRowElements = GetSynonymElements();
            var synonymRow         = synonymRowElements.FindSynonymRow(synonymToSelect);

            return synonymRow;
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Browser.FindSessionElementById("ctl00_Content_synApprovals_LPV");

            return loadingIndicator;
        }

        private SessionElementScope GetPagingControls()
        {
            var pagingControls = _Browser.FindSessionElementById("ctl00_Content_synApprovals_DXPagerBottom");

            return pagingControls;
        }

        private IList<SessionElementScope> GetPageNumberLinks()
        {
            var pagingControls  = GetPagingControls();
            var pageNumberLinks =
                pagingControls.FindAllSessionElementsByXPath(".//tbody/tr/td/table/tbody/tr/td[contains(@onclick,'PN')]");

            return pageNumberLinks;
        }

        private SessionElementScope GetNextPageLink()
        {
            var pagingControls = GetPagingControls();
            var nextPageLink   = pagingControls.FindSessionElementByXPath(".//td[contains(@onclick,'PBN')]");

            return nextPageLink;
        }

        private void ClickNextPage()
        {
            if (GetPagingControls().Exists(Config.ExistsOptions))
            {
                GetNextPageLink().Click();
                WaitUntilFinishLoading();
            }
        }

        internal SynonymRow[] GetAllProvisionalSynonyms()
        {
            WaitUntilFinishLoading();

            var pageLinksCount = 1;

            if (GetPagingControls().Exists(Config.ExistsOptions))
            {
                pageLinksCount = GetPageNumberLinks().Count;
            }

            var synonymRows   = new List<SynonymRow>();

            for (int i = 0; i < pageLinksCount; i++)
            {
                var currentPageSynonyms = GetSynonymRows();

                synonymRows.AddRange(currentPageSynonyms);

                ClickNextPage();
            }

            return synonymRows.ToArray();
        }

        internal SynonymRow[] GetFilteredProvisionalSynonyms(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");

            ExecuteSynonymApprovalSearch(synonymSearch);

            var synonymRows = GetSynonymRows();

            return synonymRows;
        }

        internal void FindAndApproveSynonym(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrWhiteSpace(synonymSearch.SearchText)) throw new ArgumentNullException("synonymSearch.SearchText");

            FindAndSelectSynonym(synonymSearch);
            GetActivateSynonymsButton().Click();
        }

        internal void FindAndRetireSynonym(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrWhiteSpace(synonymSearch.SearchText)) throw new ArgumentNullException("synonymSearch.SearchText");

            FindAndSelectSynonym(synonymSearch);
            GetRetireSynonymsButton().Click();
        }

        private void FindAndSelectSynonym(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrWhiteSpace(synonymSearch.SearchText)) throw new ArgumentNullException("synonymSearch.SearchText");

            var synonym = FindSynonym(synonymSearch);
            SelectSynonym(synonym);
        }

        private SynonymRow FindSynonym(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrWhiteSpace(synonymSearch.SearchText)) throw new ArgumentNullException("synonymSearch.SearchText");

            var synonymRows = GetFilteredProvisionalSynonyms(synonymSearch);

            if (!synonymRows.Any()) throw new ArgumentException("no synonyms found");
            
            var synonymRow = synonymRows.FirstOrDefault(
                x => x.Verbatim.Equals(synonymSearch.SearchText, StringComparison.OrdinalIgnoreCase) && 
                ( ReferenceEquals(synonymSearch.Code,null) || x.SelectedTermPathRow.Code.Equals(synonymSearch.Code) ));

            ExecuteSynonymApprovalSearch(synonymSearch);

            return synonymRow;
        }

        private void SelectSynonym(SynonymRow synonymRow)
        {
            if (ReferenceEquals(synonymRow, null)) throw new ArgumentNullException("synonymRow");

            var synonymToSelect = GetSynonymRowElement(synonymRow);
            synonymToSelect.Click();
        }

        private SynonymRow[] GetSynonymRows()
        {
            var synonymRowElements = GetSynonymElements();
            var rowCount           = synonymRowElements.Count;
            var synonymRows        = new SynonymRow[rowCount];

            for (int i = 0; i < rowCount; i++)
            {
                var rowColumns = synonymRowElements[i].FindAllSessionElementsByXPath("td");
                synonymRows[i] = new SynonymRow()
                {
                    Verbatim             = rowColumns[VerbatimIndex].Text,
                    CodedBy              = rowColumns[CodedByIndex].Text,
                    DictionaryAndLocale  = rowColumns[DictionaryLocaleIndex].Text,
                    CreationDate         = rowColumns[CreateDateIndex].Text,
                    ListName             = rowColumns[ListNameIndex].Text,

                    SelectedTermPathRow  =
                        TermPathRowDisplay
                            .GetSelectedCodingHistoryTermPathRow(
                                rowColumns[TermPathIndex]),

                    ExpandedTermPathRows =
                        TermPathRowDisplay
                            .GetExpandedCodingHistoryTermPathRows(
                                rowColumns[TermPathIndex])
                };
            }

            return synonymRows;
        }

        private void ExecuteSynonymApprovalSearch(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            GoTo();

            // Select the options in reverse. The higher level selections limit the available options in subsequent lists. 
            // However, if the option is already selected, this will remain the selection
            if (synonymSearch.SynonymList.HasValue())
            {
                var synonymListInput = synonymSearch.SynonymList;
                if (synonymSearch.Version.HasValue())
                {
                    synonymListInput = SynonymListSelectListInput(synonymSearch);
                }
                GetSynonymListSelectList().SelectOptionAlphanumericOnly(synonymListInput);
            }

            if (synonymSearch.Dictionary.HasValue() )
            {
                var dictionaryInput = synonymSearch.Dictionary;
                if (synonymSearch.Version.HasValue())
                {
                    dictionaryInput = DictionarySelectListInput(synonymSearch);
                }
                GetDictionarySelectList().SelectOptionAlphanumericOnly(dictionaryInput);
            }

            if (synonymSearch.Study.HasValue())
            {
                var studySelectList = GetStudySelectList();
                studySelectList.SelectOptionAlphanumericOnly(synonymSearch.Study);
            }

            if (synonymSearch.DateRange.HasValue())
            {
                var dateRangeSelectList = GetDateRangeSelectList();
                dateRangeSelectList.SelectOptionAlphanumericOnly(synonymSearch.DateRange);
            }

            if (synonymSearch.SearchText.HasValue())
            {
                string searchText = synonymSearch.SearchText;
                if (!synonymSearch.AllowOrTextSearch)
                {
                    searchText = searchText.FormatSearchTextForExactSearch();
                }
                GetSearchText().FillInWith(searchText);
            }
              
            ExecuteSynonymApprovalSearch();
        }

        private void ExecuteSynonymApprovalSearch()
        {
            var searchButton = GetSearchButton();
            searchButton.Click();

            WaitUntilFinishLoading();
        }

        private string DictionarySelectListInput(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrWhiteSpace(synonymSearch.Dictionary)) throw new ArgumentNullException("synonymSearch.Dictionary");
            if (String.IsNullOrWhiteSpace(synonymSearch.Locale))     throw new ArgumentNullException("synonymSearch.Locale");

            var dictionaryInput = String.Concat(synonymSearch.Dictionary, '(', synonymSearch.Locale, ')');

            return dictionaryInput;
        }

        private string SynonymListSelectListInput(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrWhiteSpace(synonymSearch.Dictionary)) throw new ArgumentNullException("synonymSearch.SynonymList");
            if (String.IsNullOrWhiteSpace(synonymSearch.Locale))     throw new ArgumentNullException("synonymSearch.Version");

            var synonymListInput = String.Format(SynonymListOptionFormat, synonymSearch.SynonymList, synonymSearch.Version);

            return synonymListInput;
        }

        internal bool IsSynonymApprovalListPopulated()
        {
            _Browser.GetPageHeader().GoToAdminPage("Synonym Approval");

            WaitUntilFinishLoading();

            var isPopulated = GetFirstSynonymRow().Exists(Config.ExistsOptions);

            return isPopulated;
        }

        internal void WaitUntilFinishLoading()
        {
            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);
        }
    }
}