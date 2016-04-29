using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using Coder.DeclarativeBrowser.Helpers;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class DictionarySearchSteps
    {
        private readonly CoderDeclarativeBrowser  _Browser;
        private readonly StepContext              _StepContext;
        private readonly DictionarySearchCriteria _SearchCriteria;
        private readonly IList<TermPathRow>       _RowsToExpand;
        private readonly GlobalSteps              _GlobalSteps;
        private IList<DictionarySearchCriteria>   _SearchCriteriaList;
        private IList<DictionarySearchResult>     _SearchResultList; 
        private TimeSpan                          _SearchTime;

        public DictionarySearchSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext           = stepContext;
            _Browser               = _StepContext.Browser;
            _SearchCriteriaList    = new List<DictionarySearchCriteria>();
            _RowsToExpand          = new List<TermPathRow>();
            _GlobalSteps           = new GlobalSteps(_StepContext);

            _SearchCriteriaList.Add(new DictionarySearchCriteria());
            _SearchCriteria = _SearchCriteriaList[0];
        }

        [Given(@"the following dictionary searches")]
        public void GivenTheFollowingDictionarySearches(Table featureData)
        {
            if(ReferenceEquals(featureData,null))                        throw new ArgumentNullException("featureData");
            if(String.IsNullOrWhiteSpace(featureData.Rows[0]["Levels"])) throw new ArgumentNullException("each search must contain one entry for Levels");

            var transformedTable = featureData.TransformFeatureTableStrings(_StepContext);

            _SearchCriteriaList.Clear();
            _SearchCriteriaList = transformedTable.CreateSet<DictionarySearchCriteria>().ToList();

            for (int i = 0; i < _SearchCriteriaList.Count(); i++)
            {
                _SearchCriteriaList[i].Levels = new string[] {featureData.Rows[i]["Levels"]};
            }
        }

        [Given(@"I begin a search in dictionary ""(.*)""")]
        public void GivenIBeginASearchInDictionary(string dictionary)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            _SearchCriteria.DictionaryName = dictionary;
        }

        [Given(@"I select Synonym List ""(.*)"" and Template ""(.*)""")]
        public void GivenISelectSynonymListAndTemplate(string synonymList, string template)
        {
            if (String.IsNullOrWhiteSpace(synonymList)) throw new ArgumentNullException("synonymList");
            if (String.IsNullOrWhiteSpace(template)) throw new ArgumentNullException("template");

            _SearchCriteria.SynonymList = synonymList;
            _SearchCriteria.Template    = template;
        }

        [Given(@"I enter ""(.*)"" as a ""(.*)"" search")]
        public void GivenIEnterAsASearch(string searchText, string textTarget)
        {
           if (String.IsNullOrWhiteSpace(searchText)) throw new ArgumentNullException("searchText");
           if (String.IsNullOrWhiteSpace(textTarget)) throw new ArgumentNullException("textTarget");

            _SearchCriteria.SearchText = searchText;
            _SearchCriteria.TextTarget = textTarget;
        }

        [Given(@"I select the following levels for the search")]
        public void GivenISelectTheFollowingLevelsForTheSearch(Table table)
        {
            if (ReferenceEquals(table,null)) throw new ArgumentNullException("table");

            var levelCount = table.RowCount;

            _SearchCriteria.Levels = new string[levelCount];
            for (int i = 0; i < levelCount; i++)
            {
                _SearchCriteria.Levels[i] = table.Rows[i][0];
            }
        }

        [Given(@"I select the following attributes for the search")]
        public void GivenISelectTheFollowingAttributesForTheSearch(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            _SearchCriteria.AttributeFilters = table.CreateSet<DictionarySearchFilter>().ToArray();
        }

        [Given(@"I select the following higher level terms for the search")]
        public void GivenISelectTheFollowingHigherLevelTermsForTheSearch(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            _SearchCriteria.HigherLevelFilters = table.CreateSet<DictionarySearchFilter>().ToArray();
        }

        [Given(@"I want only exact match results")]
        [When(@"I want only exact match results")]
        public void GivenIWantOnlyExactMatchResults()
        {
            _SearchCriteria.ExactMatchOnly = true;
        }

        [Given(@"I want only primary path results")]
        public void GivenIWantOnlyPrimaryPathResults()
        {
            _SearchCriteria.PrimaryPathOnly = true;
        }

        [Given(@"I do not want primary path results")]
        [When(@"including non primary paths in the dictionary search criteria")]
        public void GivenIDoNotWantPrimaryPathResults()
        {
            _SearchCriteria.PrimaryPathOnly = false;
        }

        [Given(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)""")]
        public void GivenTaskIsCodedToTermAtSearchLevelWithCodeAtLevel(string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText)) throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode)) throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");

            var searchCriteria = GetSearchCriteria(searchText, searchLevel);
            var targetResult = GetTargetResult(searchText, targetCode, targetLevel);

            _SearchTime = _Browser.CodeAndNext(verbatim, searchCriteria, targetResult, false);
        }

        [Given(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and a synonym is created")]
        public void GivenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreated(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText)) throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode)) throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");

            var searchCriteria = GetSearchCriteria(searchText, searchLevel);
            var targetResult = GetTargetResult(searchText, targetCode, targetLevel);

            _Browser.CompleteBrowseAndCode(verbatim, searchCriteria, targetResult, true);
        }


        [Given(@"a browse and code for task ""(.*)"" is performed")]
        [When(@"a browse and code for task ""(.*)"" is performed")]
        public void GivenABrowseAndCodeForTaskIsPerformed(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            _Browser.InitiateBrowseAndCode(verbatim);
        }

        [When(@"the browse and code search is done for ""(.*)"" against ""(.*)"" at Level ""(.*)""")]
        public void WhenTheBrowseAndCodeSearchIsDoneForAgainstAtLevel(string searchText, string textTarget, string level)
        {
            if (String.IsNullOrWhiteSpace(searchText)) throw new ArgumentNullException("searchText");
            if (String.IsNullOrWhiteSpace(textTarget)) throw new ArgumentNullException("textTarget");
            if (String.IsNullOrWhiteSpace(level))      throw new ArgumentNullException("level");

            _SearchCriteria.SearchText = searchText;
            _SearchCriteria.Levels     = new string[] { level };
            _SearchCriteria.TextTarget = textTarget;

            _Browser.RerunBrowseAndCodeSearch(_SearchCriteria);
        }

        [When(@"the above specified dictionary searches are executed")]
        public void WhenTheAboveSpecifiedDictionarySearchesAreExecuted()
        {
            foreach (var searchCriteria in _SearchCriteriaList)
            {
                ValidateSearchCriteriaInput(searchCriteria);
            }

            _SearchResultList = _Browser.ExecuteMultipleOpenDictionarySearches(_SearchCriteriaList);
        }

        [When(@"I execute the above specified search")]
        public void WhenIExecuteTheAboveSpecifiedSearch()
        {
            ValidateSearchCriteriaInput(_SearchCriteria);

            _SearchTime = _Browser.ExecuteOpenDictionarySearch(_SearchCriteria);
        }

        [When(@"I expand the search result for term ""(.*)"" with code ""(.*)"" at level ""(.*)""")]
        public void WhenIExpandTheSearchResultForTermWithCodeAtLevel(string term, string expectedCode, string level)
        {
            if (String.IsNullOrWhiteSpace(term))         throw new ArgumentNullException("term");
            if (String.IsNullOrWhiteSpace(expectedCode)) throw new ArgumentNullException("expectedCode");
            if (String.IsNullOrWhiteSpace(level))        throw new ArgumentNullException("level");

            var termPathRow = new TermPathRow() {TermPath = term, Code = expectedCode, Level = level};

            _RowsToExpand.Add(termPathRow);
        }

        [When(@"I expand the following search result terms")]
        public void WhenIExpandTheFollowingSearchResultTerms(Table featureData)
        {
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            var termsToExpand = featureData.CreateSet<TermPathRow>();

            foreach (var term in termsToExpand)
            {
                _RowsToExpand.Add(term);
            }
        }

        [When(@"new task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and a synonym is created and the coding decision is manually approved")]
        public void WhenNewTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreatedAndTheCodingDecisionIsManuallyApproved(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim))    throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))  throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))  throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");
            
            BrowserUtility.CreateNewTask(_StepContext, verbatim);

            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreatedAndTheCodingDecisionIsManuallyApproved(verbatim, searchText, searchLevel,
                targetCode, targetLevel);
        }

        [When(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and a synonym is created and the coding decision is manually approved")]
        public void WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreatedAndTheCodingDecisionIsManuallyApproved(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim))    throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))  throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))  throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");
            
            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreated(verbatim, searchText, searchLevel,
                targetCode, targetLevel);

            _GlobalSteps.WhenApprovingTask(verbatim);
        }

        [When(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and a synonym is created")]
        public void WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreated(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim))    throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))  throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))  throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");

            var searchCriteria  =   GetSearchCriteria(searchText, searchLevel);
            var targetResult    =   GetTargetResult(searchText, targetCode, targetLevel);

            _SearchTime = _Browser.CompleteBrowseAndCode(verbatim, searchCriteria, targetResult, true);
        }

        [When(@"new task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and the coding decision is manually approved")]
        public void WhenNewTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndTheCodingDecisionIsManuallyApproved(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim))    throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))  throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))  throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");

            BrowserUtility.CreateNewTask(_StepContext, verbatim);

            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndTheCodingDecisionIsManuallyApproved(verbatim, searchText, searchLevel,
                targetCode, targetLevel);
        }

        [When(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and the coding decision is manually approved")]
        public void WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndTheCodingDecisionIsManuallyApproved(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim))    throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))  throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))  throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");
            
            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevel(verbatim, searchText, searchLevel,
                targetCode, targetLevel);

            _GlobalSteps.WhenApprovingTask(verbatim);
        }

        [When(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)""")]
        public void WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevel(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim))    throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))  throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))  throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");

            var searchCriteria = GetSearchCriteria(searchText, searchLevel);
            var targetResult   = GetTargetResult(searchText, targetCode, targetLevel);

            _SearchTime = _Browser.CompleteBrowseAndCode(verbatim, searchCriteria, targetResult, false);
        }

        [When(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and higher level terms")]
        public void CodeTaskWithHigherLevelTerms(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel, Table higherLevelTerms)
        {
            if (String.IsNullOrEmpty(verbatim))          throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))        throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel))       throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))        throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel))       throw new ArgumentNullException("targetLevel");
            if (ReferenceEquals(higherLevelTerms, null)) throw new ArgumentNullException("higherLevelTerms");

            CodeTaskWithHigherLevelTerms(
                verbatim,
                searchText,
                searchLevel,
                targetCode,
                targetLevel,
                higherLevelTerms,
                createSynonym: false);
        }

        [When(@"task ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)"" and higher level terms with a synonym created")]
        public void CodeTaskWithHigherLevelTermsAndCreateSynonym(
            string verbatimFeature, string searchText, string searchLevel, string targetCode, string targetLevel, Table higherLevelTerms)
        {
            if (String.IsNullOrEmpty(verbatimFeature))        throw new ArgumentNullException("verbatimFeature");
            if (String.IsNullOrEmpty(searchText))             throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel))            throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))             throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel))            throw new ArgumentNullException("targetLevel");
            if (ReferenceEquals(higherLevelTerms, null))      throw new ArgumentNullException("higherLevelTerms");
            
            var verbatim = StepArgumentTransformations.TransformFeatureString(verbatimFeature, _StepContext);

            CodeTaskWithHigherLevelTerms(
                verbatim,
                searchText,
                searchLevel,
                targetCode,
                targetLevel,
                higherLevelTerms,
                createSynonym: true);
        }

        private void CodeTaskWithHigherLevelTerms(
            string verbatim, string searchText, string searchLevel, string targetCode, string targetLevel, Table higherLevelTerms, bool createSynonym)
        {
            if (String.IsNullOrEmpty(verbatim))          throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(searchText))        throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel))       throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))        throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel))       throw new ArgumentNullException("targetLevel");
            if (ReferenceEquals(higherLevelTerms, null)) throw new ArgumentNullException("higherLevelTerms");

            GivenABrowseAndCodeForTaskIsPerformed(verbatim);

            GivenISelectTheFollowingHigherLevelTermsForTheSearch(higherLevelTerms);

            WhenTheBrowseAndCodeSearchIsDoneForAgainstAtLevel(searchText, textTarget: "Text", level: searchLevel);

            var targetTerm = new TermPathRow
            {
                TermPath = searchText,
                Level = targetLevel,
                Code = targetCode
            };

            _Browser.CodeTaskWithExistingSearchResult(targetTerm, createSynonym);
        }

        [When(@"the first task ""(.*)"" in group ""(.*)"" is coded to term ""(.*)"" at search level ""(.*)"" with code ""(.*)"" at level ""(.*)""")]
        public void WhenTheFirstTaskInGroupIsCodedToTermAtSearchLevelWithCodeAtLevel(
            string verbatim, string group, string searchText, string searchLevel, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(verbatim))    throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(group))       throw new ArgumentNullException("group");
            if (String.IsNullOrEmpty(searchText))  throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");
            if (String.IsNullOrEmpty(targetCode))  throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");

            var searchCriteria = GetSearchCriteria(searchText, searchLevel);
            var targetResult = GetTargetResult(searchText, targetCode, targetLevel);

            _Browser.CompleteBrowseAndCode(verbatim, searchCriteria, targetResult, false, group);
        }

        [Given(@"""(.*)"" manually approved coding tasks with verbatim ""(.*)"" coded to term ""(.*)"" code ""(.*)"" with a synonym created")]
        public void GivenManuallyApprovedCodingTasksWithVerbatimCodedToTermCodeWithASynonymCreated(int numberOfTasks, string verbatim, string term, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(term)) throw new ArgumentNullException("term");
            if (String.IsNullOrWhiteSpace(code)) throw new ArgumentNullException("code");

            string dictionaryLevel     = BrowserUtility.GetDefaultDictionaryLevel(_StepContext.Dictionary);
            string fullDictionaryLevel = dictionaryLevel.ConvertToFullDictionaryLevelName();

            _Browser.SetupCodingTaskGroup(_StepContext, verbatim, dictionaryLevel, numberOfTasks);
            
            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreatedAndTheCodingDecisionIsManuallyApproved(
                verbatim:    verbatim, 
                searchText:  term, 
                searchLevel: fullDictionaryLevel, 
                targetCode:  code,
                targetLevel: dictionaryLevel);
        }

        [Given(@"""(.*)"" manually approved coding tasks with verbatim ""(.*)"" coded to term ""(.*)"" code ""(.*)""")]
        public void GivenManuallyApprovedCodingTasksWithVerbatimCodedToTermCode(int numberOfTasks, string verbatim, string term, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(term)) throw new ArgumentNullException("term");
            if (String.IsNullOrWhiteSpace(code)) throw new ArgumentNullException("code");

            string dictionaryLevel = BrowserUtility.GetDefaultDictionaryLevel(_StepContext.Dictionary);
            string fullDictionaryLevel = dictionaryLevel.ConvertToFullDictionaryLevelName();

            _Browser.SetupCodingTaskGroup(_StepContext, verbatim, dictionaryLevel, numberOfTasks);

            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndTheCodingDecisionIsManuallyApproved(
                verbatim: verbatim,
                searchText: term,
                searchLevel: fullDictionaryLevel,
                targetCode: code,
                targetLevel: dictionaryLevel);
        }

        [Given(@"""(.*)"" unapproved coding tasks with verbatim ""(.*)"" coded to term ""(.*)"" code ""(.*)"" with a synonym created")]
        public void GivenUnapprovedCodingTasksWithVerbatimCodedToTermCodeWithASynonymCreated(int numberOfTasks, string verbatim, string term, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(term)) throw new ArgumentNullException("term");
            if (String.IsNullOrWhiteSpace(code)) throw new ArgumentNullException("code");

            string dictionaryLevel = BrowserUtility.GetDefaultDictionaryLevel(_StepContext.Dictionary);
            string fullDictionaryLevel = dictionaryLevel.ConvertToFullDictionaryLevelName();

            _Browser.SetupCodingTaskGroup(_StepContext, verbatim, dictionaryLevel, numberOfTasks);

            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevelAndASynonymIsCreated(
                verbatim: verbatim,
                searchText: term,
                searchLevel: fullDictionaryLevel,
                targetCode: code,
                targetLevel: dictionaryLevel);
        }

        [Given(@"""(.*)"" unapproved coding tasks with verbatim ""(.*)"" coded to term ""(.*)"" code ""(.*)""")]
        public void GivenUnapprovedCodingTasksWithVerbatimCodedToTermCode(int numberOfTasks, string verbatim, string term, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(term)) throw new ArgumentNullException("term");
            if (String.IsNullOrWhiteSpace(code)) throw new ArgumentNullException("code");

            string dictionaryLevel     = BrowserUtility.GetDefaultDictionaryLevel(_StepContext.Dictionary);
            string fullDictionaryLevel = dictionaryLevel.ConvertToFullDictionaryLevelName();

            _Browser.SetupCodingTaskGroup(_StepContext, verbatim, dictionaryLevel, numberOfTasks);

            WhenTaskIsCodedToTermAtSearchLevelWithCodeAtLevel(
                verbatim:    verbatim,
                searchText:  term,
                searchLevel: fullDictionaryLevel,
                targetCode:  code,
                targetLevel: dictionaryLevel);
        }
        
        [When(@"I reclassify tasks ""(.*)"" with Include Autocoded Items set to ""(.*)""")]
        public void GivenIReclassifyTasksWithIncludeAutocodedItemsSetTo(string term, string includeAutoCodedItems, Table table)
        {
            if (ReferenceEquals(term, null))                  throw new ArgumentNullException("term");
            if (ReferenceEquals(includeAutoCodedItems, null)) throw new ArgumentNullException("includeAutoCodedItems");
            for (var i = 0; i < table.RowCount; i++)
            {
                var verbatim = table.Rows[i]["Verbatim"];
                _Browser.ReclassifyTask(
                    verbatim             : verbatim,
                    comment              : Config.DefaultReclassficationComment, 
                    includeAutoCodedItems: includeAutoCodedItems,
                    reclassificationType : ReclassificationTypes.Reclassify);
            }
        }

        [When(@"selecting the primary path ""(.*)"" dictionary result for term ""(.*)"" code ""(.*)"" level ""(.*)""")]
        public void WhenSelectingThePrimaryPathDictionaryResultForTermCodeLevel(bool primaryPath, string verbatim, string code, string level)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(code))     throw new ArgumentNullException("code");
            if (String.IsNullOrWhiteSpace(level))    throw new ArgumentNullException("level");
 
            var targetResult = GetTargetResult(verbatim, code, level);
            _Browser.SelectDictionarySearchResult(targetResult, primaryPath);
        }

        //TODO: revisit and change to use model class
        [When(@"I code next available task")]
        public void WhenICodeNextAvailableTask(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");
            for (var i = 0; i < table.RowCount; i++)
            {
                var task = table.Rows[i]["Verbatim"];
                var term = table.Rows[i]["SearchText"];
                var searchLevel = table.Rows[i]["SearchLevel"];
                var code = table.Rows[i]["Code"];
                var level = table.Rows[i]["Level"];
                var searchCriteria = GetSearchCriteria(term, searchLevel);
                var targetResult = GetTargetResult(term, code, level);
                var createSynonym = table.Rows[i]["CreateSynonym"].ToBoolean();
                _Browser.CodeAndNext(term, searchCriteria, targetResult, createSynonym);
            }
        }

        [When(@"the task is coded to term ""(.*)"" at level ""(.*)"" with code ""(.*)"" and a synonym is created")]
        public void WhenTheTaskIsCodedToTermAtLevelWithCodeAndASynonymIsCreated(string term, string level, string code)
        {
            var targetTerm = new TermPathRow
            {
                TermPath = term,
                Level = level,
                Code = code
            };

            _Browser.CodeTaskWithExistingSearchResult(targetTerm, true );
        }


        [Then(@"I verify the results count message indicates ""(.*)"" results")]
        public void ThenIVerifyTheResultsCountMessageIndicatesResults(int resultsCount)
        {
            if(resultsCount < 0) throw new ArgumentOutOfRangeException("resultsCount");

            var actualResults = GetSearchResultsAfterRowExpansion();

            actualResults.SearchResults.Count().ShouldBeEquivalentTo(resultsCount);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following information is contained in the browser search results")]
        public void ThenIVerifyTheFollowingInformationIsContainedInTheBrowserSearchResults(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var expectedResults = table.CreateSet<TermPathRow>().ToArray();
            var actualResults   = GetSearchResultsAfterRowExpansion();

            AssertSearchResultsContainExpected(actualResults, expectedResults);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the dictionary search results should contain only the following terms")]
        public void ThenTheDictionarySearchResultsShouldContainOnlyTheFollowingTerms(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var expectedResults = table.CreateSet<TermPathRow>().ToArray();
            var actualResults   = GetSearchResultsAfterRowExpansion();

            actualResults.SearchResults.Count().ShouldBeEquivalentTo(expectedResults.Length);

            AssertSearchResultsContainExpected(actualResults, expectedResults);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Selected Search Result Properties are displayed for term ""(.*)"" with code ""(.*)"" at level ""(.*)""")]
        public void ThenIVerifyTheFollowingSelectedSearchResultPropertiesAreDisplayedForTermWithCodeAtLevel(string term, string expectedCode, string level, Table table)
        {
            if (String.IsNullOrWhiteSpace(term))                    throw new ArgumentNullException("term");
            if (String.IsNullOrWhiteSpace(expectedCode))            throw new ArgumentNullException("expectedCode");
            if (String.IsNullOrWhiteSpace(level))                   throw new ArgumentNullException("level");
            if (ReferenceEquals(table, null))                       throw new ArgumentNullException("table");
            if (ReferenceEquals(table.Rows.FirstOrDefault(), null)) throw new ArgumentNullException("properties table must have at least one row");
            
            var expectedProperties = GetPropertiesDictionary(table);

            var termPathRow = new TermPathRow() {TermPath = term, Code = expectedCode, Level = level};

            AssertTermHasProperties(termPathRow, expectedProperties);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the search results do not contain any terms at the following levels")]
        public void ThenIVerifyTheSearchResultsDoNotContainAnyTermsAtTheFollowingLevels(Table table)
        {
            if (ReferenceEquals(table,null)) throw new ArgumentNullException("table");

            var featureData = table.CreateSet<String>().ToArray();

            var htmlData      = GetSearchResultsAfterRowExpansion();
            var actualResults = htmlData.SearchResults;
            var resultLevels  = actualResults.SelectMany(x => x.Level.Distinct()).ToArray();

            foreach (var level in featureData)
            {
                resultLevels.Should().NotContain(level,
                    String.Format("results should not contain terms at {0}",level));
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the current dictionary search criteria should be using a synonym list")]
        public void ThenTheCurrentDictionarySearchCriteriaShouldBeUsingASynonymList()
        {
            var searchCriteria = _Browser.GetDictionarySearchCriteria();

            searchCriteria.UsingSynonymList.Should().BeTrue();
        }

        [Then(@"All results returned should have the following properties")]
        public void ThenAllResultsReturnedShouldHaveTheFollowingProperties(Table table)
        {
            if (ReferenceEquals(table,null))              throw new ArgumentNullException("table");
            if (ReferenceEquals(!table.Rows.Any(), null)) throw new ArgumentNullException("properties table must have at least one row");

            var expectedProperties = GetPropertiesDictionary(table);

            var searchResults = GetSearchResultsAfterRowExpansion();

            foreach (var searchResult in searchResults.SearchResults)
            {
                AssertTermHasProperties(searchResult, expectedProperties);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"all searches executed should have completed within ""(.*)"" seconds")]
        public void ThenAllSearchesExecutedShouldHaveCompletedWithinSeconds(int seconds)
        {
            if (seconds <= 0) throw new ArgumentOutOfRangeException("seconds should be greater than 0");

            var expectedSeconds = TimeSpan.FromSeconds(seconds);

            foreach (var searchResult in _SearchResultList)
            {
                searchResult.ExecutionTime.Should().BeLessOrEqualTo(expectedSeconds) ;
            }
        }

        [Then(@"the task should be able to be coded to the following terms")]
        public void ThenTheTaskShouldBeAbleToBeCodedToTheFollowingTerms(Table featureData)
        {
            if (ReferenceEquals(featureData,null)) throw new ArgumentNullException("featureData");

            AssertThatTermsCanBeCodedValueMatchExpectedValue(featureData, true);
        }

        [Then(@"the task should not be able to be coded to the following terms")]
        public void ThenTheTaskShouldNotBeAbleToBeCodedToTheFollowingTerms(Table featureData)
            {
            if (ReferenceEquals(featureData,null)) throw new ArgumentNullException("featureData");

            AssertThatTermsCanBeCodedValueMatchExpectedValue(featureData, false);
        }

        [Then(@"the synonyms for term ""(.*)"" with code ""(.*)"" at level ""(.*)"" are distinct")]
        public void ThenTheSynonymsForTermWithCodeAtLevelAreDistinct(string term, string code, string level)
        {
            if (String.IsNullOrWhiteSpace(term))  throw new ArgumentNullException("term");
            if (String.IsNullOrWhiteSpace(code))  throw new ArgumentNullException("code");
            if (String.IsNullOrWhiteSpace(level)) throw new ArgumentNullException("level");

            var searchResult         = new TermPathRow() { TermPath = term, Code = code, Level = level };
            var selectedSearchResult = _Browser.GetDictionarySelectedSearchResultInformation(searchResult);
            var synonymVerbatims     = selectedSearchResult.Synonyms.Select(x => x.Verbatim).ToArray();

            foreach (var verbatim in synonymVerbatims)
            {
                var count = synonymVerbatims.Select(x => x.Equals(verbatim)).Count();

                count.ShouldBeEquivalentTo(1, String.Format("{0} is duplicated", verbatim));
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        private DictionarySearchResult GetSearchResultsAfterRowExpansion()
        {
            var results = _Browser.GetDictionarySearchResults(_RowsToExpand);

            return results;
        }

        private void AssertSearchResultsContainExpected(DictionarySearchResult actualResults, IEnumerable<TermPathRow> expectedResults)
        {
            if (ReferenceEquals(actualResults,null))   throw new ArgumentNullException("actualResults");
            if (ReferenceEquals(expectedResults,null)) throw new ArgumentNullException("expectedResults");

            foreach (var expectedResult in expectedResults)
            {
                bool anyMatch = actualResults.SearchResults.Any(x => x.Equals(expectedResult));
                anyMatch.Should().BeTrue
                    (String.Format("Results should contain term {0} code {1} at level {2} and has synonym: {3}",
                    expectedResult.TermPath,
                    expectedResult.Code,
                    expectedResult.Level,
                    expectedResult.HasSynonym));
            }
        }

        private void AssertThatTermsCanBeCodedValueMatchExpectedValue(Table featureData, bool isCodeable)
        {
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            var expectedCodableTerms = featureData.CreateSet<TermPathRow>();
            var searchResults        = GetSearchResultsAfterRowExpansion();

            foreach (var expectedCodableTerm in expectedCodableTerms)
            {
                var selectedResultContent = _Browser
                    .GetDictionarySelectedSearchResultInformation(expectedCodableTerm);

                selectedResultContent.CanBeCoded.ShouldBeEquivalentTo(isCodeable);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        private IDictionary<string, string> GetPropertiesDictionary(Table table)
        {
            if (ReferenceEquals(table, null))             throw new ArgumentNullException("table");
            if (ReferenceEquals(!table.Rows.Any(), null)) throw new ArgumentNullException("properties table must have at least one row");

            var featureDataKeys = table.Rows.FirstOrDefault().Keys.ToArray();

            if (featureDataKeys.Count() != 2) throw new ArgumentException("Properties table should be key and value pairs");

            var featureData = table.Rows
                .ToDictionary(featureDataKeys[0], featureDataKeys[1]);

            return featureData;
        }

        private void AssertTermHasProperties(TermPathRow searchResult, IDictionary<string, string> expectedProperties)
        {
            if (ReferenceEquals(expectedProperties,null)) throw new ArgumentNullException("expectedProperties");
            if (ReferenceEquals(searchResult, null))      throw new ArgumentNullException("searchResult");

            var selectedSearchResult = _Browser.GetDictionarySelectedSearchResultInformation(searchResult);
            var selectedProperties = selectedSearchResult.Properties;

            foreach (var expectedProperty in expectedProperties)
            {
                selectedProperties.Should().ContainKey(expectedProperty.Key);
                selectedProperties[expectedProperty.Key].Should().BeEquivalentTo(expectedProperty.Value);
            }
        }

        private DictionarySearchCriteria GetSearchCriteria(string searchText, string searchLevel)
        {
            if (String.IsNullOrEmpty(searchText)) throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(searchLevel)) throw new ArgumentNullException("searchLevel");

            var searchCriteria = new DictionarySearchCriteria()
            {
                SearchText  = searchText,
                Levels      = new string[] { searchLevel }
            };

            return searchCriteria;
        }

        private TermPathRow GetTargetResult(string searchText, string targetCode, string targetLevel)
        {
            if (String.IsNullOrEmpty(searchText)) throw new ArgumentNullException("searchText");
            if (String.IsNullOrEmpty(targetCode)) throw new ArgumentNullException("targetCode");
            if (String.IsNullOrEmpty(targetLevel)) throw new ArgumentNullException("targetLevel");

            var targetResult = new TermPathRow()
            {
                TermPath    = searchText,
                Code        = targetCode,
                Level       = targetLevel
            };

            return targetResult;
        }

        private void ValidateSearchCriteriaInput(DictionarySearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null))                    throw new InvalidOperationException("Search Criteria has not been provided");
            if (String.IsNullOrWhiteSpace(searchCriteria.DictionaryName)) throw new InvalidOperationException("Search Dictionary has not been provided");
            if (String.IsNullOrWhiteSpace(searchCriteria.SearchText))     throw new InvalidOperationException("Search Text has not been provided");
            if (!searchCriteria.Levels.Any())                             throw new InvalidOperationException("Search criteria must contain at least one level");
            if (String.IsNullOrWhiteSpace(searchCriteria.Levels[0]))      throw new InvalidOperationException("Search criteria must contain at least one level");
        }
    }
}
