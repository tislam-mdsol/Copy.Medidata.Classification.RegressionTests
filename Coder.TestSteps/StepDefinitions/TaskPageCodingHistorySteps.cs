using System;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class TaskPageCodingHistorySteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;

        public TaskPageCodingHistorySteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
        }

        [Then(@"I verify the following Coding History information is displayed")]
        public void ThenIVerifyTheFollowingCodingHistoryInformationIsDisplayed(Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var expectedResults = table.TransformFeatureTableStrings(_StepContext).CreateSet<CodingHistoryDetail>().ToArray();

            _Browser.GetSelectedCodingTaskTab();

            var actualResults = _Browser.GetCodingHistoryTableValues();

            for (var i = 0; i < actualResults.Count; i++)
            {
                var expectedResult = expectedResults[i];
                var actualResult = actualResults[i];

                expectedResult.User.Should().ContainEquivalentOf(actualResult.User);

                expectedResult.Action.Trim().Should().BeEquivalentTo(expectedResult.Action);
                expectedResult.Action.Should()       .BeEquivalentTo(expectedResult.Action);
                expectedResult.Status.Should()       .BeEquivalentTo(expectedResult.Status);
                expectedResult.VerbatimTerm.Should() .BeEquivalentTo(expectedResult.VerbatimTerm);

                if (expectedResults[i].Comment.Trim() == "Transmission Queue Number:")
                {
                    actualResults[i].Comment.Trim().Should().ContainEquivalentOf(expectedResults[i].Comment.Trim());
                }
                else
                {
                    actualResults[i].Comment.Trim().Should().BeEquivalentTo(expectedResults[i].Comment.Trim());
                }

                var actualDateTime = DateTime.Parse(actualResults[i].TimeStamp);
                var timeDiff       = Math.Abs(actualDateTime.Subtract(DateTime.Now).Hours);

                timeDiff.Should().BeLessOrEqualTo(Config.TimeStampHoursDiff);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Given(@"approve and reclassify task ""(.*)"" with Include Autocoded Items set to ""(.*)""")]
        public void GivenApproveAndReclassifyTaskWithIncludeAutocodedItemsSetTo(string verbatim, string includeAutoCodedItems)
        {
            if (String.IsNullOrWhiteSpace(verbatim))              throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems");

            _Browser.CreateATaskWithReconsiderState(
                verbatim             : verbatim, 
                reclassifyComment    : Config.DefaultReclassficationComment,
                includeAutoCodedItems: includeAutoCodedItems);
        }

        [When(@"a user adds a comment ""(.*)"" for task ""(.*)""")]
        public void WhenAUserAddsACommentForTask(string comment, string task)
        {
            if (String.IsNullOrWhiteSpace(comment)) throw new ArgumentNullException("comment"); 
            if (String.IsNullOrWhiteSpace(task))    throw new ArgumentNullException("task"); 

            _Browser.CommentOnCodingTask(comment, task);
        }

        [Then(@"the Coding History contains following information")]
        public void ThenTheCodingHistoryContainsFollowingInformation(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table"); 

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateSet<CodingHistoryDetail>().ToArray();

            if (!featureData.Any())           throw new ArgumentNullException("Feature Data Table is empty.");
            
            string displayedVerbatim = featureData[0].VerbatimTerm.RemoveAdditionalInformationFromGridDataVerbatim();

            _Browser.SelectCodingTask(displayedVerbatim);

            _Browser.AssertCodingHistoryHasTheInformationForTask(featureData, Config.TimeStampHoursDiff);
        }

        [Then(@"the Coding History contains following information for task ""(.*)"" in status ""(.*)""")]
        public void ThenTheCodingHistoryContainsFollowingInformationForTaskInStatus(string verbatim, string status, Table table)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(status))   throw new ArgumentNullException("status");
            if (ReferenceEquals(table, null))        throw new ArgumentNullException("table");

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateSet<CodingHistoryDetail>().ToArray();
            
            _Browser.SelectCodingTask(verbatim, field: "Status", value: status);

            _Browser.AssertCodingHistoryHasTheInformationForTask(featureData, Config.TimeStampHoursDiff);
        }

        [Then(@"I verify the following Coding history term full path information is displayed in row ""(.*)""")]
        public void ThenIVerifyTheFollowingCodingHistoryTermFullPathInformationIsDisplayedInRow(int historyRow, Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateSet<TermPathRow>().ToArray();

            var htmlData = _Browser.GetCodingHistoryTableValues();
            
            var rowIndex = historyRow - 1;

            var htmlExpandedTermPaths = htmlData[rowIndex].ExpandedTermPathRows;

            htmlExpandedTermPaths.ShouldAllBeEquivalentTo(featureData);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Coding history selected term path information is displayed in row ""(.*)""")]
        public void ThenIVerifyTheFollowingCodingHistorySelectedTermPathInformationIsDisplayedInRow(int historyRow, Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var featureData =
                table.TransformFeatureTableStrings(_StepContext).CreateInstance<TermPathRow>();

            var htmlData = _Browser.GetCodingHistoryTableValues();
            var rowIndex = historyRow - 1;

            var htmlSelectedPath = htmlData[rowIndex].SelectedTermPathRow;

            htmlSelectedPath.ShouldBeEquivalentTo(featureData);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"task ""(.*)"" should have the following Coding history selected term path information is displayed in row ""(.*)""")]
        public void ThenTaskShouldHaveTheFollowingCodingHistorySelectedTermPathInformationIsDisplayedInRow(string verbatim, int historyRow, Table table)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");
            if (historyRow <= 0) throw new ArgumentOutOfRangeException("historyRow");

            _Browser.SelectCodingTask(verbatim);

            _StepContext.SetCurrentCodingElementContext();

            ThenIVerifyTheFollowingCodingHistorySelectedTermPathInformationIsDisplayedInRow(historyRow, table);
        }

    }
}
