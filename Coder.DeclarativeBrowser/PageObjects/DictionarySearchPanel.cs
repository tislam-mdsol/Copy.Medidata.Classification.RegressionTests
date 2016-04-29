using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coypu;
using Polly;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal class DictionarySearchPanel
    {
        private const string _ResultIsPrimaryXPath = _ResultLevelXPath + "/i";
        private const string _ResultLevelXPath     = @"span[@class='term-level']";
        private const string _ResultTermPathXPath  = @"span[@class='term-text']";
        private const string _ResultCodeXPath      = @"span[@class='term-code']";
        private const string _HasSynonymXPath      = _ResultTermPathXPath + @"/span[@class='term-hasSynonym']";
        private const char   _HasSynonymIndicator  = '*';
        private Stopwatch _SearchTimer;

        private readonly Policy _FilterCollectionPolicy = RetryPolicy.FilterCollection;
        private readonly BrowserSession _Browser;
        private readonly List<TermPathRow> _ResultSet;

        private bool _ReachedFirstPage;

        internal DictionarySearchPanel(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }

            _Browser = browser;
            _ResultSet = new List<TermPathRow>();
        }

        private SessionElementScope GetSearchCriteriaPanel()
        {
            var searchCriteriaPanel = _Browser.FindSessionElementById("search-criteria");

            return searchCriteriaPanel;
        }

        private SessionElementScope GetDictionarySelectList()
        {
            var searchCriteriaPanel  = GetSearchCriteriaPanel();
            var dictionarySelectList = searchCriteriaPanel.FindSessionElementById("dictionarySelector");

            return dictionarySelectList;
        }

        private SessionElementScope GetSynonymSelectList()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var synonymSelectList   = searchCriteriaPanel.FindSessionElementById("synonymListSelector");

            return synonymSelectList;
        }

        private SessionElementScope GetTemplateSelectList()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var templateSelectList  = searchCriteriaPanel.FindSessionElementById("templateSelector");

            return templateSelectList;
        }

        private SessionElementScope GetTextOrCodeSelectList()
        {
            var searchCriteriaPanel  = GetSearchCriteriaPanel();
            var textOrCodeSelectList = searchCriteriaPanel.FindSessionElementById("search-type-option");

            return textOrCodeSelectList;
        }

        private SessionElementScope GetSearchCriteriaText()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var searchCriteriaText  = searchCriteriaPanel.FindSessionElementById("searchCriteriaText");

            return searchCriteriaText;
        }

        private SessionElementScope GetAddLevelButton()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var addLevelButton      = searchCriteriaPanel.FindSessionElementById("add-or-level");

            return addLevelButton;
        }

        private IList<SessionElementScope> GetLevelSelectLists()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var levelSelectLists    = searchCriteriaPanel.FindAllSessionElementsByXPath(".//div[@ng-repeat='orLevel in vm.level.orLevels']//select");

            return levelSelectLists;
        }

        private IList<SessionElementScope> GetLevelRemoveButtons()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var removeButtons       = searchCriteriaPanel.FindAllSessionElementsByXPath(".//button[starts-with(@id,'remove-or-level-')]");

            return removeButtons;
        }

        private SessionElementScope GetAddHasAttributeButton()
        {
            var searchCriteriaPanel   = GetSearchCriteriaPanel();
            var addHasAttributeButton = searchCriteriaPanel.FindSessionElementById("addComponent");

            return addHasAttributeButton;
        }

        private IList<SessionElementScope> GetAttributeFilters()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var attributeFilters    = searchCriteriaPanel.FindAllSessionElementsByXPath(".//div[@class='attribute']");

            return attributeFilters;
        }

        private SessionElementScope GetAttributeFilterOperatorSelectList(int filterIndex)
        {
            if (filterIndex < 0) throw new ArgumentOutOfRangeException("filterIndex");

            var attributeFilters = GetAttributeFilters();
            var attributeFilter  = attributeFilters.ElementAtOrDefault(filterIndex);

            if (ReferenceEquals(attributeFilter, null)) throw new ArgumentOutOfRangeException("filterIndex");

            var attributeFilterSelectList = attributeFilter.FindSessionElementByXPath(".//select[@ng-model='formComponent.operator']");

            return attributeFilterSelectList;
        }

        private SessionElementScope GetAttributeNameSelectList(int filterIndex)
        {
            if (filterIndex < 0) throw new ArgumentOutOfRangeException("filterIndex");

            var attributeFilters = GetAttributeFilters();
            var attributeFilter  = attributeFilters.ElementAtOrDefault(filterIndex);

            if (ReferenceEquals(attributeFilter, null)) throw new ArgumentOutOfRangeException("filterIndex");

            var attributeFilterSelectList = attributeFilter.FindSessionElementByXPath(".//select[@name='attributeName']");

            return attributeFilterSelectList;
        }

        private SessionElementScope GetAttributeFilterTextValue(int filterIndex)
        {
            if (filterIndex < 0) throw new ArgumentOutOfRangeException("filterIndex");

            var attributeFilters = GetAttributeFilters();
            var attributeFilter  = attributeFilters.ElementAtOrDefault(filterIndex);

            if (ReferenceEquals(attributeFilter, null)) throw new ArgumentOutOfRangeException("filterIndex");

            var filterTextValue = attributeFilter.FindSessionElementByXPath(".//input[@name='component_ofvalue']");

            return filterTextValue;
        }

        private IList<SessionElementScope> GetAttributeFilterRemoveButtons()
        {
            var dictionarySearchPanel = GetSearchCriteriaPanel();
            var removeFilterButtons = dictionarySearchPanel.FindAllSessionElementsByXPath(".//button[starts-with(@id,'removeAttribute')]");

            return removeFilterButtons;
        }

        private SessionElementScope GetAddHasHigherLevelTermButton()
        {
            var searchCriteriaPanel         = GetSearchCriteriaPanel();
            var addHasHigherLevelTermButton = searchCriteriaPanel.FindSessionElementById("addLevel");

            return addHasHigherLevelTermButton;
        }

        private IList<SessionElementScope> GetHigherLevelTermFilters()
        {
            var searchCriteriaPanel    = GetSearchCriteriaPanel();
            var higherLevelTermFilters = searchCriteriaPanel.FindAllSessionElementsByXPath("//div[@ng-repeat='andLevel in vm.level.andLevels']");

            return higherLevelTermFilters;
        }

        private SessionElementScope GetHigherLevelTermFilter(int filterIndex)
        {
            if (filterIndex < 0) throw new ArgumentOutOfRangeException("filterIndex");

            var higherLevelTermFilters = GetHigherLevelTermFilters();
            var higherLevelTermFilter  = higherLevelTermFilters.ElementAtOrDefault(filterIndex);

            if (ReferenceEquals(higherLevelTermFilter, null)) throw new ArgumentOutOfRangeException("filterIndex");

            return higherLevelTermFilter;
        }

        private SessionElementScope GetHigherLevelTermOperatorSelectList(int filterIndex)
        {
            if (filterIndex < 0) throw new ArgumentOutOfRangeException("filterIndex");

            var higherLevelTermFilter = GetHigherLevelTermFilter(filterIndex);
            var filterSelectList      = higherLevelTermFilter.FindSessionElementByXPath(".//select[@ng-model='andLevel.operator']");

            return filterSelectList;
        }

        private SessionElementScope GetHigherLevelTermSelectList(int filterIndex)
        {
            if (filterIndex < 0) throw new ArgumentOutOfRangeException("filterIndex");

            var higherLevelTermFilter = GetHigherLevelTermFilter(filterIndex);
            var filterSelectList      = higherLevelTermFilter.FindSessionElementByXPath(".//select[@name='dictionaryLevel']");

            return filterSelectList;
        }

        private SessionElementScope GetHigherLevelTermText(int filterIndex)
        {
            if (filterIndex < 0) throw new ArgumentOutOfRangeException("filterIndex");

            var higherLevelTermFilter = GetHigherLevelTermFilter(filterIndex);
            var filterTextField       = higherLevelTermFilter.FindSessionElementByXPath(".//input[@name='searchText']");

            return filterTextField;
        }

        private IList<SessionElementScope> GetHigherLevelTermRemoveButtons()
        {
            var dictionarySearchPanel = GetSearchCriteriaPanel();
            var removeFilterButtons = dictionarySearchPanel.FindAllSessionElementsByXPath(".//button[starts-with(@id,'removeLevel')]");

            return removeFilterButtons;
        }

        private SessionElementScope GetExactMatchOnlyCheckbox()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var exactMatchCheckbox  = searchCriteriaPanel.FindSessionElementById("exactmatchonly");

            return exactMatchCheckbox;
        }

        private SessionElementScope GetPrimaryPathOnlyCheckbox()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var primaryPathCheckbox = searchCriteriaPanel.FindSessionElementById("primarypathonly");

            return primaryPathCheckbox;
        }

        private SessionElementScope GetSearchExecuteButton()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var searchButton        = searchCriteriaPanel.FindSessionElementById("search");

            return searchButton;
        }

        private SessionElementScope GetContinueSearchButton()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var continueButton = searchCriteriaPanel.FindSessionElementByXPath(".//button[@text='Continue']");

            return continueButton;
        }

        private SessionElementScope GetDictionarySelectionPanel()
        {
            var dictionarySelectionPanel = _Browser.FindSessionElementById("selected-dictionary-term");

            return dictionarySelectionPanel;
        }

        private SessionElementScope GetCodeAndNextButton()
        {
            var dictionarySelectionPanel = GetDictionarySelectionPanel();
            var codeAndNextButton = dictionarySelectionPanel.FindSessionElementById("codeToTermPathAndNext");

            return codeAndNextButton;
        }

        private SessionElementScope GetHumanReadableQueryElement()
        {
            var searchCriteriaPanel = GetSearchCriteriaPanel();
            var humanReadableQuery  = searchCriteriaPanel.FindSessionElementById("coder-search-syntax");

            return humanReadableQuery;
        }

        internal string GetHumanReadableQuery()
        {
            var queryElement = GetHumanReadableQueryElement();
            var query        = queryElement.Text;

            return query;
        }

        private IList<SessionElementScope> GetSearchResultElements()
        {
            var searchCriteriaPanel  = GetSearchCriteriaPanel();
            var searchResultsSection = searchCriteriaPanel.FindSessionElementById("term-tree");
            var searchResultsContent = searchResultsSection.FindAllSessionElementsByXPath(".//div[@class='term']");

            return searchResultsContent;
        }

        private SessionElementScope GetPreviousPageButton()
        {
            var previousPageButton = _Browser.FindSessionElementById("treeViewPrevPage");

            return previousPageButton;
        }

        private SessionElementScope GetNextPageButton()
        {
            var nextPageButton = _Browser.FindSessionElementById("treeViewNextPage");

            return nextPageButton;
        }

        internal void SelectDictionarySearchResult(TermPathRow termPathRow, bool? primaryPath = null)
        {
            if (ReferenceEquals(termPathRow, null)) throw new ArgumentNullException("termPathRow");

            var searchResult = GetSearchResultElement(termPathRow, primaryPath);
            searchResult.Click();
        }

        private SessionElementScope GetSearchResultElement(TermPathRow termPathRow, bool? primaryPath = null)
        {
            if (ReferenceEquals(termPathRow, null)) throw new ArgumentNullException("termPathRow");

            ResetPagination();

            var resultElements = GetSearchResultElements();

            var resultElement = resultElements
                .FirstOrDefault(
                       el => el.FindSessionElementByXPath(_ResultLevelXPath).Text.Equals(termPathRow.Level, StringComparison.OrdinalIgnoreCase)
                    && el.FindSessionElementByXPath(_ResultTermPathXPath).Text.TrimEnd(_HasSynonymIndicator).Trim().Equals(termPathRow.TermPath, StringComparison.OrdinalIgnoreCase)
                    && el.FindSessionElementByXPath(_ResultCodeXPath).Text.Equals(termPathRow.Code, StringComparison.OrdinalIgnoreCase)
                    && (primaryPath == null || el.FindSessionElementByXPath(_ResultIsPrimaryXPath).Class.Contains("primary", StringComparison.OrdinalIgnoreCase).Equals(primaryPath)));

            if (ReferenceEquals(resultElement, null))
            {
                var nextPageExists = UsePaginationIfAvailable(GetNextPageButton);

                if (nextPageExists)
                {
                    resultElement = GetSearchResultElement(termPathRow, primaryPath);

                    if (!ReferenceEquals(resultElement, null))
                    {
                        return resultElement;
                    }
                }

                throw new ArgumentException(
                    String.Format("Term: {0} Code: {1} Level: {2} Primary: {3} not found",
                        termPathRow.TermPath,
                        termPathRow.Code,
                        termPathRow.Level,
                        primaryPath));
            }

            return resultElement;
        }

        private void ResetPagination()
        {
            var startingPage = GetCurrentPageNumber();

            if (startingPage == 1)
            {
                _ReachedFirstPage = true;
            }
            else if (!_ReachedFirstPage)
            {
                GoToFirstPage();
                _ReachedFirstPage = true;
            }
        }

        private void GoToFirstPage()
        {
            var previousPageExists = UsePaginationIfAvailable(GetPreviousPageButton);
            if (previousPageExists)
            {
                GoToFirstPage();
            }
        }
        
        private SessionElementScope GetSearchResultExpandButton(TermPathRow termPathRow)
        {
            if (ReferenceEquals(termPathRow, null)) throw new ArgumentNullException("termPathRow");

            var searchResultElement      = GetSearchResultElement(termPathRow);
            var searchResultExpandButton = searchResultElement.FindSessionElementByXPath("span[@class='term-expander']/i");

            return searchResultExpandButton;
        }

        private SessionElementScope GetPaginationElement()
        {
            var paginationElement = _Browser.FindSessionElementById("browser-treeview-pagination");

            return paginationElement;
        }

        internal void ExpandSearchResult(TermPathRow termPathRow)
        {
            if (ReferenceEquals(termPathRow,null)) throw new ArgumentNullException("termPathRow");

            var oldCount = GetSearchResultElements().Count;
            GetSearchResultExpandButton(termPathRow).Click();

            RetryPolicy
                .FindElementShort
                .Execute(() => WaitForResultExpansion(oldCount));
        }

        private void WaitForResultExpansion(int oldCount)
        {
            var newCount = GetSearchResultElements().Count;
            if (newCount == oldCount) throw new MissingHtmlException("Results not yet expanded");
        }
       
        private bool UsePaginationIfAvailable(Func<SessionElementScope> getPagebutton)
        {
            if (ReferenceEquals(getPagebutton,null)) throw new ArgumentNullException("getPagebutton");

            var pageButton = getPagebutton();

            if (!pageButton.Exists(Config.ExistsOptions) || pageButton.Disabled)
            {
                return false;
            }
            
            ClickPaginationButton(pageButton);

            return true;
        }

        private void ClickPaginationButton(SessionElementScope pageButton)
        {
            if (ReferenceEquals(pageButton,null)) throw new ArgumentNullException("pageButton");

            pageButton.Click();

            RetryPolicy.FindElement.Execute(WaitForPaginationToComplete);
        }

        private void WaitForPaginationToComplete()
        {
            var previousPageButton = GetPreviousPageButton();
            var nextPageButton     = GetNextPageButton();

            if (previousPageButton.Disabled && nextPageButton.Disabled)
            {
                throw new MissingHtmlException("Pagination not finished");
            }

            WaitForSynonymRetrieval();
        }

        private int GetCurrentPageNumber()
        {
            var currentPageTitle   = _Browser.FindSessionElementById("treeViewCurrentPage");

            if (!currentPageTitle.Exists(Config.ExistsOptions))
            {
                return 1;
            }

            var currentPageElement = currentPageTitle.FindSessionElementByXPath("./span[@data-ng-bind='vm.currentPageNumber']");
            var currentPageString = currentPageElement.Text;

            int pageNumber = 0;
            Int32.TryParse(currentPageString, out pageNumber);

            if (pageNumber == 0)
            {
                throw new MissingHtmlException(String.Format("Failed to convert page title {0} to integer", currentPageTitle.Text));
            }

            return pageNumber;
        }
        
        internal IEnumerable<TermPathRow> GetAllSearchResultTerms()
        {
            var currentRange = GetCurrentBatchSearchResultTerms();
            _ResultSet.AddRange(currentRange);

            var nextPageExists = UsePaginationIfAvailable(GetNextPageButton);

            if (nextPageExists)
            {
                GetAllSearchResultTerms();
            }

            return _ResultSet;
        }

        internal IEnumerable<TermPathRow> GetCurrentBatchSearchResultTerms()
        {
            var searchResultsContent = GetSearchResultElements();

            var pageNumber = GetCurrentPageNumber();

            var resultsList = searchResultsContent.Select(element =>
                new TermPathRow()
                {
                    TermPath   = element.FindSessionElementByXPath(_ResultTermPathXPath).Text.TrimEnd(_HasSynonymIndicator).Trim(),
                    Code       = element.FindSessionElementByXPath(_ResultCodeXPath).Text,
                    Level      = element.FindSessionElementByXPath(_ResultLevelXPath).Text,
                    HasSynonym = element.FindSessionElementByXPath(_HasSynonymXPath).Exists((Config.InstantOptions))
                }).ToArray();

            return resultsList;
        }

        internal TimeSpan ExecuteDictionarySearch(DictionarySearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null))                throw new ArgumentNullException("searchCriteria");
            if (String.IsNullOrWhiteSpace(searchCriteria.SearchText)) throw new InvalidOperationException("Search Text is required");

            _Browser.WaitUntilElementIsActive(GetSearchExecuteButton);

            var dictionarySelect = GetDictionarySelectList();
            dictionarySelect.SelectOptionAlphanumericOnly(searchCriteria.DictionaryName);

            _Browser.WaitUntilElementIsActive(GetSearchExecuteButton);
            
            var synonymSelect = GetSynonymSelectList();
            synonymSelect.SelectOptionAlphanumericOnly(searchCriteria.SynonymList);
            
            var templateSelect = GetTemplateSelectList();
            templateSelect.SelectOptionAlphanumericOnly(searchCriteria.Template);

            var textOrCodeSelect = GetTextOrCodeSelectList();
            textOrCodeSelect.SelectOptionAlphanumericOnly(searchCriteria.TextTarget);

            _Browser.WaitUntilElementDisappears(GetCodeAndNextButton);
            _Browser.WaitUntilElementIsActive(GetSearchExecuteButton);

            var searchCriteriaText = GetSearchCriteriaText();
            searchCriteriaText.FillInWith(searchCriteria.SearchText);

            _FilterCollectionPolicy.Execute(
                () =>
                SetSearchLevelFilters(searchCriteria.Levels));

            _FilterCollectionPolicy.Execute(
                () =>
            SetSearchFilters(
                searchCriteria.AttributeFilters,
                GetAttributeFilterRemoveButtons,
                GetAddHasAttributeButton,
                GetAttributeFilterOperatorSelectList,
                GetAttributeNameSelectList,
                GetAttributeFilterTextValue));

            _FilterCollectionPolicy.Execute(
                () =>
                SetSearchFilters(
                    searchCriteria.HigherLevelFilters,
                    GetHigherLevelTermRemoveButtons,
                    GetAddHasHigherLevelTermButton,
                    GetHigherLevelTermOperatorSelectList,
                    GetHigherLevelTermSelectList,
                    GetHigherLevelTermText));

            var exactMatchCheckbox = GetExactMatchOnlyCheckbox();
            exactMatchCheckbox.SetCheckBoxState(searchCriteria.ExactMatchOnly);

            var primaryPathCheckbox = GetPrimaryPathOnlyCheckbox();

            if (primaryPathCheckbox.Exists(Config.ExistsOptions))
            {
                primaryPathCheckbox.SetCheckBoxState(searchCriteria.PrimaryPathOnly);
            }
            
            _SearchTimer = new Stopwatch();

            RunSearchAndWaitForCompletion();

            return _SearchTimer.Elapsed;
        }

        private void SetSearchLevelFilters(string[] criteriaLevels)
        {
            if (ReferenceEquals(criteriaLevels, null)) return;
            if (!criteriaLevels.Any()) return;

            var levelRemoveButtons = GetLevelRemoveButtons();

            foreach (var button in levelRemoveButtons ?? Enumerable.Empty<SessionElementScope>())
            {
                button.Click();
            }

            var levelsCount = criteriaLevels.Count();

            for (int i = 0; i < levelsCount; i++)
            {
                var selectList = GetLevelSelectLists()[i];
                selectList.SelectOptionAlphanumericOnly(criteriaLevels[i]);

                if (i < levelsCount - 1)
                {
                    GetAddLevelButton().Click();
                }
            }
        }

        private void SetSearchFilters(
            DictionarySearchFilter[] searchFilters,
            Func<IList<SessionElementScope>> getRemoveButtons,
            Func<SessionElementScope> getAddFilterButton, 
            Func<int, SessionElementScope> getOperatorSelectList, 
            Func<int, SessionElementScope> getTargetSelectList, 
            Func<int, SessionElementScope> getFilterValueInput)
        {
            if (ReferenceEquals(searchFilters, null)) return;

            foreach (var button in getRemoveButtons() ?? Enumerable.Empty<SessionElementScope>())
            {
                button.Click();
            }

            for (int i = 0; i < searchFilters.Count(); i++)
            {
                getAddFilterButton().Click();

                var operatorSelectList = getOperatorSelectList(i);
                var targetSelectList   = getTargetSelectList(i);
                var filterTextBox      = getFilterValueInput(i);

                var filter = searchFilters[i];

                operatorSelectList.SelectOptionAlphanumericOnly(filter.Operator);
                targetSelectList.SelectOptionAlphanumericOnly(filter.Attribute);
                filterTextBox.FillInWith(filter.Text);
            }
        }

        private void RunSearchAndWaitForCompletion()
        {
            _Browser.WaitUntilElementIsActive(GetSearchExecuteButton);

            RetryPolicy.FindElementShort.ExecuteAndCapture(BeginSearchExecution);

            _SearchTimer.Start();
            
            RetryPolicy.FindElement.Execute(WaitForSearchCompletion);

            _SearchTimer.Stop();

            WaitForSynonymRetrieval();
        }

        private void WaitForSearchCompletion()
        {
            var searchButton   = GetSearchExecuteButton();
            var continueButton = GetContinueSearchButton();

            if (!searchButton.Disabled)
            {
                return;
            }

            if (continueButton.Exists(Config.ExistsOptions))
            {
                continueButton.Click();
                return;
            }

            throw new MissingHtmlException("Dictionary Search not completed");
        }

        private void WaitForSynonymRetrieval()
        {
            //TODO: DJ replace with check for positive synonym retrieval after MCC-199316
            Thread.Sleep(4000);
        }

        private void BeginSearchExecution()
        {
            var executeButton = GetSearchExecuteButton();
            var pagination    = GetPaginationElement();

            executeButton.Click();

            if (!executeButton.Disabled || !pagination.Exists(Config.ExistsOptions))
            {
                throw new MissingHtmlException("Search button not actually clicked");
            }
        }

        internal DictionarySearchCriteria GetCurrentSearchCriteria()
        {
            _Browser.WaitUntilElementIsActive(GetSearchExecuteButton);

            var currentCriteria = new DictionarySearchCriteria()
            {
                DictionaryName = GetDictionarySelectList().SelectedOption,
                SynonymList    = GetSynonymSelectList().SelectedOption,
                Template       = GetTemplateSelectList().SelectedOption,
                TextTarget     = GetTextOrCodeSelectList().SelectedOption,
                SearchText     = GetSearchCriteriaText().Value,
                Levels         = GetLevelSelectLists().Select(x => x.SelectedOption).ToArray()
            };

            currentCriteria.UsingSynonymList = IsSearchUsingASynonymList(currentCriteria);

            return currentCriteria;
        }

        private bool IsSearchUsingASynonymList(DictionarySearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");

            if (searchCriteria.SynonymList.IndexOf("Without Synonyms", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return false;
            }

            return true;
        }
    }
}
