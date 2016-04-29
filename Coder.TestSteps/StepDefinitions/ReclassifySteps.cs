using System;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    public enum ReclassificationSearchField
    {
        Unknown,
        Verbatim,
        Term,
        Code,
        Subject,
        IncludeAutocodedItems,
        PriorActions,
        PriorStatus
    }

    [Binding]
    public class ReclassifySteps
    {
        private readonly CoderDeclarativeBrowser        _Browser;
        private readonly StepContext                    _StepContext;
        private readonly ReclassificationSearchCriteria _ReclassificationSearchCriteria;

        public ReclassifySteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext                    = stepContext;
            _Browser                        = _StepContext.Browser;
            _ReclassificationSearchCriteria = new ReclassificationSearchCriteria();
        }

        [When(@"reclassifying task ""(.*)"" with a comment ""(.*)"" and Include Autocoded Items set to ""(.*)""")]
        public void WhenReclassifyingTaskWithACommentAndIncludeAutocodedItemsSetTo(string verbatim, string comment, string includeAutoCodedItems)
        {
            if (String.IsNullOrWhiteSpace(verbatim))              throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(comment))               throw new ArgumentNullException("comment"); 
            if (String.IsNullOrWhiteSpace(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems");

            _Browser.ReclassifyTask(
                verbatim             : verbatim, 
                comment              : comment,
                includeAutoCodedItems: includeAutoCodedItems,
                reclassificationType : ReclassificationTypes.Reclassify);
        }

        [When(@"reclassifying task ""(.*)"" with Include Autocoded Items set to ""(.*)""")]
        public void WhenReclassifyingTaskWithIncludeAutocodedItemsSetTo(string verbatim, string includeAutoCodedItems)
        {
            if (String.IsNullOrWhiteSpace(verbatim))              throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems"); 

            _Browser.ReclassifyTask(
                verbatim             : verbatim, 
                comment              : Config.DefaultReclassficationComment, 
                includeAutoCodedItems: includeAutoCodedItems,
                reclassificationType : ReclassificationTypes.Reclassify);
        }

        [When(@"reclassifying and retiring synonym task ""(.*)"" with Include Autocoded Items set to ""(.*)""")]
        public void WhenReclassifyingAndRetiringSynonymTaskWithIncludeAutocodedItemsSetTo(string verbatim, string includeAutoCodedItems)
        {
            if (String.IsNullOrWhiteSpace(verbatim))              throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems"); 

            _Browser.ReclassifyTask(
                 verbatim             : verbatim,
                 comment              : Config.DefaultReclassficationComment,
                 includeAutoCodedItems: includeAutoCodedItems,
                 reclassificationType : ReclassificationTypes.ReclassifyAndRetire);
        }

        [When(@"reclassifying group for the task ""(.*)"" with Include Autocoded Items set to ""(.*)""")]
        public void WhenReclassifyingGroupForTheTaskWithIncludeAutocodedItemsSetTo(string verbatim, string includeAutoCodedItems)
        {
            if (String.IsNullOrWhiteSpace(verbatim))              throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems");

            _Browser.ReclassifyTask(
                 verbatim             : verbatim,
                 comment              : Config.DefaultReclassficationComment,
                 includeAutoCodedItems: includeAutoCodedItems,
                 reclassificationType : ReclassificationTypes.ReclassifyGroup);
        }

        [When(@"reclassifying and retiring group for the task ""(.*)"" with Include Autocoded Items set to ""(.*)""")]
        public void WhenReclassifyingAndRetiringGroupForTheTaskWithIncludeAutocodedItemsSetTo(string verbatim, string includeAutoCodedItems)
        {
            if (String.IsNullOrWhiteSpace(verbatim))              throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems");

            _Browser.ReclassifyTask(
                 verbatim             : verbatim,
                 comment              : Config.DefaultReclassficationComment,
                 includeAutoCodedItems: includeAutoCodedItems,
                 reclassificationType : ReclassificationTypes.ReclassifyGroupAndRetire);
        }

        [When(@"setting reclassification search value ""(.*)"" for ""(.*)""")]
        public void WhenSettingReclassificationSearchValueFor(
            string textValue, 
            ReclassificationSearchField searchField)
        {
            if (String.IsNullOrWhiteSpace(textValue))                    throw new ArgumentNullException("textValue");
            if (searchField.Equals(ReclassificationSearchField.Unknown)) throw new ArgumentOutOfRangeException("searchField");

            SetSearchCritera(searchField, textValue);
        }

        [When(@"performing reclassification search")]
        public void WhenPerformingReclassificationSearch()
        {
            _Browser.PerformReclassificationSearch(_ReclassificationSearchCriteria);
        }

        [Then(@"the reclassification search should contain")]
        public void ThenTheReclassificationSearchShouldContain(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateSet<ReclassificationSearch>().ToArray();

            _Browser.AssertReclassificationSearchResultsMatchesExpectedData(featureData);
        }

        [Then(@"the reclassification results page summary should contain")]
        public void ThenTheReclassificationResultsPageSummaryShouldContain(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            table.Rows.Count.Should().Be(1);

            var tableRow = table.Rows[0];

            var expectedPagingLabel  = tableRow["Paging Label"];
            var expectedResultsLabel = tableRow["Results Label"];

            _Browser.AssertThatReclassificationPagingLabelsEqualsExpectedValue(
                expectedPagingLabel : expectedPagingLabel,
                expectedResultsLabel: expectedResultsLabel);
        }

        [Then(@"the following terms were autocoded and approved")]
        public void ThenTheFollowingTermsWereAutocodedAndApproved(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateSet<ReclassificationSearch>().ToList();

            _ReclassificationSearchCriteria.IncludeAutoCodedItems = true;

            _Browser.PerformReclassificationSearch(_ReclassificationSearchCriteria);
            _Browser.AssertReclassificationSearchResults(featureData);
        }

        [Then(@"reclassification of coding task ""(.*)"" cannot occur while the study migration is in progress")]
        public void ThenReclassificationOfCodingTaskCannotOccurWhileTheStudyMigrationIsInProgress(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            
            _ReclassificationSearchCriteria.Verbatim              = verbatim;
            _ReclassificationSearchCriteria.Version               = _StepContext.SourceSynonymList.Version;
            _ReclassificationSearchCriteria.IncludeAutoCodedItems = true;

            _Browser.AssertCannotReclassifyDuringStudyMigration(_ReclassificationSearchCriteria, _StepContext.TargetSynonymList.Version);
        }

        private void SetSearchCritera(ReclassificationSearchField searchField, string searchValue)
        {
            if (searchField.Equals(ReclassificationSearchField.Verbatim))              { _ReclassificationSearchCriteria.Verbatim              = searchValue;             }
            if (searchField.Equals(ReclassificationSearchField.Term))                  { _ReclassificationSearchCriteria.Term                  = searchValue;             }
            if (searchField.Equals(ReclassificationSearchField.Code))                  { _ReclassificationSearchCriteria.Code                  = searchValue;             }
            if (searchField.Equals(ReclassificationSearchField.Subject))               { _ReclassificationSearchCriteria.Subject               = searchValue;             }
            if (searchField.Equals(ReclassificationSearchField.IncludeAutocodedItems)) { _ReclassificationSearchCriteria.IncludeAutoCodedItems = searchValue.ToBoolean(); }
            if (searchField.Equals(ReclassificationSearchField.PriorActions))          { _ReclassificationSearchCriteria.PriorActions          = searchValue;             }
            if (searchField.Equals(ReclassificationSearchField.PriorStatus))           { _ReclassificationSearchCriteria.PriorStatus           = searchValue;             }
        }
    }
}
