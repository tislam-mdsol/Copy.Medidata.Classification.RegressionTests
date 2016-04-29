using System;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class TaskPageTasksTableSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        public TaskPageTasksTableSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [When(@"the time elapsed since task ""(.*)"" was created is ""(.*)"" days and ""(.*)"" hours")]
        public void WhenTheTimeElapsedSinceTaskWasCreatedIsDaysAndHours(string verbatim, int days, int hours)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            int hoursToAge = (days*24) + hours;

            BrowserUtility.AgeTask(_StepContext, verbatim, hoursToAge);
        }

        [When(@"I sort the tasks by ""(.*)"" ""(.*)""")]
        public void WhenISortTheTasksBy(string columnName, string sortDirection)
        {
            if (String.IsNullOrWhiteSpace(columnName))    throw new ArgumentNullException("columnName");
            if (String.IsNullOrWhiteSpace(sortDirection)) throw new ArgumentNullException("sortDirection");

            if (!sortDirection.Equals("ascending", StringComparison.OrdinalIgnoreCase) 
                && !sortDirection.Equals("descending", StringComparison.OrdinalIgnoreCase))
            {
                throw new ArgumentException("sortDirection is not a valid direction");
            }

            var desiredSortDirection = SortStatus.SortedAscending;

            if (sortDirection.Equals("descending", StringComparison.OrdinalIgnoreCase))
            {
                desiredSortDirection = SortStatus.SortedDescending;
            }

            _Browser.SortTasks(columnName, desiredSortDirection);
        }

        [When(@"I limit the displayed tasks by")]
        public void WhenILimitTheDisplayedTasksBy(Table filters)
        {
            if (ReferenceEquals(filters, null)) throw new ArgumentNullException("filters");
            if (filters.RowCount < 1) throw new ArgumentException("No filters specified");
            if (!filters.ContainsColumn("Filter Name") || !filters.ContainsColumn("Filter Criteria"))
            {
                throw new ArgumentException("Filter columns incorrectly named");
            }

            _Browser.GoToTaskPage();

            string sourceSystemFilterCriteria = "";
            string studiesFilterCriteria = "";
            string trackablesFilterCriteria = "";

            foreach (TableRow filter in filters.Rows)
            {
                switch (filter["Filter Name"])
                {
                    case "Source Systems":
                        {
                            sourceSystemFilterCriteria = filter["Filter Criteria"];
                            break;
                        }
                    case "Studies":
                        {
                            studiesFilterCriteria = filter["Filter Criteria"];
                            break;
                        }
                    case "Trackables":
                        {
                            trackablesFilterCriteria = filter["Filter Criteria"];
                            break;
                        }
                    default:
                        {
                            throw new ArgumentException("The Filter Name is not valid or has not yet been mapped to a page object.");
                        }
                }
            }

            _Browser.FilterDisplayedTasks(sourceSystemFilterCriteria, studiesFilterCriteria, trackablesFilterCriteria);
        }

        [When(@"I filter the tasks by")]
        public void WhenIFilterTheTasksBy(Table filters)
        {
            if (ReferenceEquals(filters, null)) throw new ArgumentNullException("filters");
            if (filters.RowCount < 1) throw new ArgumentException("No filters specified");
            if (!filters.ContainsColumn("Column Name") || !filters.ContainsColumn("Filter Criteria"))
            {
                throw new ArgumentException("Filter columns incorrectly named");
            }

            foreach (TableRow filter in filters.Rows)
            {
                WhenIFilterForTasksWithOf(filter["Column Name"], filter["Filter Criteria"]);
            }
        }

        [When(@"I filter for tasks with ""(.*)"" of ""(.*)""")]
        public void WhenIFilterForTasksWithOf(string columnName, string filterCriteria)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(filterCriteria)) throw new ArgumentNullException("filterCriteria");

            _Browser.FilterTasksByColumn(columnName, filterCriteria);
        }

        [When(@"all task filters are cleared")]
        public void WhenAllTaskFiltersAreCleared()
        {
            _Browser.ClearAllTaskPageFilters();
        }

        [When(@"I go to page ""(.*)""")]
        public void WhenIGoToPage(string destinationPage)
        {
            if (String.IsNullOrEmpty(destinationPage)) throw new ArgumentNullException("destinationPage");

            _Browser.GoToSpecificTaskPage(destinationPage);
        }

        [When(@"I open a query for new task ""(.*)"" with comment ""(.*)""")]
        public void WhenIOpenAQueryForNewTaskWithComment(string verbatim, string comment)
        {
            if (string.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (string.IsNullOrEmpty(comment))  throw new ArgumentNullException("comment");

            BrowserUtility.CreateNewTask(_StepContext, verbatim);

            WhenIOpenAQueryForTaskWithComment(verbatim, comment);
        }

        [When(@"I open a query for task ""(.*)"" with comment ""(.*)""")]
        public void WhenIOpenAQueryForTaskWithComment(string verbatim, string comment)
        {
            if (string.IsNullOrEmpty(verbatim))  throw new ArgumentNullException("verbatim"); 
            if (string.IsNullOrEmpty(comment))   throw new ArgumentNullException("comment"); 

            _Browser.OpenQuery(verbatim, comment);

            WhenACodingTaskReturnsToQueryStatus(verbatim, "Queued");
        }

        [When(@"opening a query for task ""(.*)"" with comment ""(.*)"" and not waiting for the task query status to update")]
        public void WhenOpeningAQueryForTaskWithCommentAndNotWaitingForTheTaskQueryStatusToUpdate(string verbatim, string comment)
        {
            if (string.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (string.IsNullOrEmpty(comment))  throw new ArgumentNullException("comment");

            _Browser.OpenQuery(verbatim, comment);
        }

        [When(@"the query sent to marking group ""(.*)"" for new task ""(.*)"" with comment ""(.*)"" is ""(.*)"" with response ""(.*)""")]
        public void WhenTheQuerySentToMarkingGroupForNewTaskWithCommentIsWithResponse(string markingGroup, string verbatim, string comment, string status, string response)
        {
            if (string.IsNullOrWhiteSpace(markingGroup)) throw new ArgumentNullException("markingGroup");
            if (string.IsNullOrWhiteSpace(verbatim))     throw new ArgumentNullException("verbatim");
            if (string.IsNullOrWhiteSpace(comment))      throw new ArgumentNullException("comment");
            if (string.IsNullOrWhiteSpace(status))       throw new ArgumentNullException("status");
            if (string.IsNullOrWhiteSpace(response))     throw new ArgumentNullException("response");

            IsQueryStatusValid(status);

            BrowserUtility.CreateNewTask(_StepContext, verbatim, markingGroup:markingGroup);

            WhenTheQueryForTaskWithCommentIsWithResponse(verbatim, comment, status, response);
        }

        [When(@"the query for new task ""(.*)"" with comment ""(.*)"" is ""(.*)"" with response ""(.*)""")]
        public void WhenTheQueryForNewTaskWithCommentIsWithResponse(string verbatim, string comment, string status, string response)
        {
            if (string.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 
            if (string.IsNullOrWhiteSpace(comment))  throw new ArgumentNullException("comment");  
            if (string.IsNullOrWhiteSpace(status))   throw new ArgumentNullException("status");   
            if (string.IsNullOrWhiteSpace(response)) throw new ArgumentNullException("response");

            IsQueryStatusValid(status);

            BrowserUtility.CreateNewTask(_StepContext, verbatim);

            WhenTheQueryForTaskWithCommentIsWithResponse(verbatim, comment, status, response);
        }

        [When(@"the query for task ""(.*)"" with comment ""(.*)"" is ""(.*)"" with response ""(.*)""")]
        public void WhenTheQueryForTaskWithCommentIsWithResponse(string verbatim, string comment, string status, string response)
        {
            if (string.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (string.IsNullOrWhiteSpace(comment))  throw new ArgumentNullException("comment");
            if (string.IsNullOrWhiteSpace(status))   throw new ArgumentNullException("status");
            if (string.IsNullOrWhiteSpace(response)) throw new ArgumentNullException("response");

            IsQueryStatusValid(status);

            WhenIOpenAQueryForTaskWithComment(verbatim, comment);

            WhenACodingTaskReturnsToQueryStatus(verbatim, "Queued");

            BrowserUtility.SendTaskQueryResponse(
                stepContext: _StepContext,
                verbatim:    verbatim,
                status:      status,
                response:    response,
                comment:     comment);
        }

        [When(@"the latest query for task ""(.*)"" is ""(.*)"" with response ""(.*)""")]
        public void WhenTheLatestQueryForTaskIsWithResponse(string verbatim, string status, string response)
        {
            if (string.IsNullOrWhiteSpace(verbatim))  throw new ArgumentNullException("verbatim"); 
            if (string.IsNullOrWhiteSpace(status))    throw new ArgumentNullException("status"); 
            if (string.IsNullOrWhiteSpace(response))  throw new ArgumentNullException("response");

            IsQueryStatusValid(status);

            BrowserUtility.SendTaskQueryResponse(
                stepContext: _StepContext,
                verbatim:    verbatim,
                status:      status,
                response:    response);
        }

        private void IsQueryStatusValid(string status)
        {
            if (string.IsNullOrWhiteSpace(status)) throw new ArgumentNullException("status");

            if (!"Open Answered Cancelled Closed".Contains(status))
            {
                throw new ArgumentException(String.Format("The status, {0}, is not a valid task query state." +
                   "\nExpected \"Open\", \"Answered\", \"Cancelled\", \"Closed\", or \"Forwarded\"",status));
            }
        }

        [When(@"I cancel the query for task ""(.*)""")]
        public void WhenICancelTheQueryForTask(string verbatim)
        {
            if (string.IsNullOrEmpty(verbatim)) { throw new ArgumentNullException("verbatim"); }
            
            _Browser.CancelQuery(verbatim);

            WhenACodingTaskReturnsToQueryStatus(verbatim, "Queued");
        }

        [When(@"the verbatim term for new task ""(.*)"" is changed to ""(.*)""")]
        public void WhenTheVerbatimTermForNewTaskIsChangedTo(string initalVerbatim, string modifiedVerbatim)
        {
            if (string.IsNullOrEmpty(initalVerbatim))   throw new ArgumentNullException("initalVerbatim");
            if (string.IsNullOrEmpty(modifiedVerbatim)) throw new ArgumentNullException("modifiedVerbatim");

            BrowserUtility.CreateNewTask(_StepContext, initalVerbatim);

            WhenTheVerbatimTermForTaskIsChangedTo(initalVerbatim, modifiedVerbatim);
        }

        [When(@"the verbatim term for new task ""(.*)""  with additional information is changed to ""(.*)""")]
        public void WhenTheVerbatimTermForNewTaskWithAdditionalInformationIsChangedTo(string initalVerbatim, string modifiedVerbatim, Table table)
        {
            if (string.IsNullOrEmpty(initalVerbatim))   throw new ArgumentNullException("initalVerbatim");
            if (string.IsNullOrEmpty(modifiedVerbatim)) throw new ArgumentNullException("modifiedVerbatim");
            if (ReferenceEquals(table, null))           throw new ArgumentNullException("table");
            if (!table.ContainsColumn("SupplementalValues") || !table.ContainsColumn("ComponenetValues"))
            {
                throw new ArgumentException(
                    "Task additional information table requires two columns named 'SupplementalValues' and 'ComponenetValues'. Empty data is acceptable.");
            }

            string supplementalValues = "";
            string componenetValues   = "";

            foreach (TableRow tableRow in table.Rows)
            {
                supplementalValues += String.Format("{0},", tableRow["SupplementalValues"]);
                componenetValues   += String.Format("{0},", tableRow["ComponenetValues"]);
            }

            supplementalValues = supplementalValues.Remove(supplementalValues.Length - 1, 1);
            componenetValues   = componenetValues.Remove(componenetValues.Length - 1, 1);

            BrowserUtility.CreateNewTask(_StepContext, initalVerbatim, supplements:supplementalValues, components:componenetValues);

            WhenTheVerbatimTermForTaskIsChangedTo(initalVerbatim, modifiedVerbatim);
        }

        [When(@"the verbatim term for task ""(.*)"" is changed to ""(.*)""")]
        public void WhenTheVerbatimTermForTaskIsChangedTo(string initalVerbatim, string modifiedVerbatim)
        {
            if (string.IsNullOrEmpty(initalVerbatim))   throw new ArgumentNullException("initalVerbatim");
            if (string.IsNullOrEmpty(modifiedVerbatim)) throw new ArgumentNullException("modifiedVerbatim");
            
            BrowserUtility.ChangeTaskVerbatim(_StepContext, initalVerbatim, modifiedVerbatim);
        }
        
        [When(@"the field workflow settings for task ""(.*)"" are set to ""(.*)""")]
        public void WhenTheFieldWorkflowSettingsForTaskAreSetTo(string verbatim, string setupType)
        {
            if (String.IsNullOrEmpty(verbatim))  throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(setupType)) throw new ArgumentNullException("setupType");

            BrowserUtility.ChangeTaskFieldWorkflowSettings(_StepContext, verbatim, setupType);
        }

        [When(@"The system ""(.*)"" count is at least ""(.*)"" percent of all tasks")]
        public void WhenTheSystemCountIsAtLeastPercentOfAllTasks(string taskableState, int percentThreshold)
        {
            if (String.IsNullOrEmpty(taskableState)) throw new ArgumentNullException("taskableState");

            _Browser.WaitUntilSystemTaskCountAtOrAboveThreshold(taskableState, percentThreshold);
        }

        [When(@"AutoCoding is complete")]
        public void WhenAutoCodingIsComplete()
        {
            _Browser.WaitForAutoCodingToComplete();
        }

        [When(@"a coding task ""(.*)"" returns to ""(.*)"" status")]
        public void WhenACodingTaskReturnsToStatus(string verbatim, string status)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(status))   throw new ArgumentNullException("status");
            
            _Browser.SelectCodingTask(verbatim, field: "Status", value: status);
        }

        [When(@"a coding task ""(.*)"" returns to ""(.*)"" query status")]
        public void WhenACodingTaskReturnsToQueryStatus(string verbatim, string status)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(status))   throw new ArgumentNullException("status");

            _Browser.SelectCodingTask(verbatim, field: "Queries", value: status);
        }

        [Then(@"The ""(.*)"" column header indicates ""(.*)""")]
        public void ThenTheColumnHeaderIndicates(string columnName, string sortDirection)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(sortDirection)) throw new ArgumentNullException("sortDirection");
            if (sortDirection.ToLower() != "ascending" && sortDirection.ToLower() != "descending")
            {
                throw new ArgumentException("sortDirection is not a valid direction");
            }

            SortStatus expectedSortDirection = SortStatus.SortedAscending;
            if (sortDirection.ToLower() == "descending")
            {
                expectedSortDirection = SortStatus.SortedDescending;
            }

            SortStatus tasksSortedByStatus = _Browser.GetTasksSortedByStatus(columnName);

            expectedSortDirection.Should().Be(tasksSortedByStatus);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"The task count is ""(.*)""")]
        public void ThenTheTaskCountIs(int expectedTaskCount)
        {
            if (expectedTaskCount < 0) throw new ArgumentOutOfRangeException("expectedTaskCount");

            _Browser.AssertThatTheTaskCountEqualsExpectedValue(expectedTaskCount);
        }

        [Then(@"The task count is not ""(.*)""")]
        public void ThenTheTaskCountIsNot(int unexpectedTaskCount)
        {
            if (unexpectedTaskCount < 0) throw new ArgumentOutOfRangeException("unexpectedTaskCount");

            _Browser.GoToTaskPage();

            unexpectedTaskCount.Should().NotBe(_Browser.GetHeaderTaskCount());

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the coding task table has the following ordered information")]
        public void ThenTheCodingTaskTableHasTheFollowingOrderedInformation(Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var codingTasks = table.TransformFeatureTableStrings(_StepContext).CreateSet<CodingTask>().ToArray();

            _Browser.AssertDataMatchesCodingTaskTable(codingTasks);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"The current page is ""(.*)""")]
        public void ThenTheCurrentPageIs(int expectedPageNumber)
        {
            if (ReferenceEquals(expectedPageNumber, null)) throw new ArgumentNullException("expectedPageNumber");

            _Browser.AssertExpectedTaskPageIsCurrent(expectedPageNumber);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the following coding decisions require approval")]
        public void ThenTheFollowingCodingDecisionsRequireApproval(Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var codingTasks = table.TransformFeatureTableStrings(_StepContext).CreateSet<CodingTask>().ToArray();

            _Browser.GoToTaskPage();

            WhenAllTaskFiltersAreCleared();

            _Browser.FilterTasksByColumn("Status", "Waiting Approval");
            
            codingTasks.Length.ShouldBeEquivalentTo(_Browser.GetHeaderTaskCount());

            _Browser.AssertDataMatchesCodingTaskTable(codingTasks);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the following coding decisions require manual coding")]
        public void ThenTheFollowingCodingDecisionsRequireManualCoding(Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var codingTasks = table.TransformFeatureTableStrings(_StepContext).CreateSet<CodingTask>().ToArray();

            _Browser.GoToTaskPage();

            WhenAllTaskFiltersAreCleared();

            _Browser.FilterTasksByColumn("Status", "Waiting Manual Code");

            codingTasks.Length.ShouldBeEquivalentTo(_Browser.GetHeaderTaskCount());

            _Browser.AssertDataMatchesCodingTaskTable(codingTasks);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the task ""(.*)"" should have a status of ""(.*)""")]
        public void ThenTheTaskShouldHaveAStatusOf(string verbatimFeature, string status)
        {
            if (ReferenceEquals(verbatimFeature, null)) throw new ArgumentNullException("verbatimFeature");
            if (ReferenceEquals(status, null))          throw new ArgumentNullException("status");

            var verbatim = StepArgumentTransformations.TransformFeatureString(verbatimFeature, _StepContext);

            _Browser.AssertThatTheTaskHasExpectedStatus(verbatim, status);
        }
        
        [Then(@"the tasks will be sorted by ""(.*)"" ""(.*)""")]
        public void ThenTheTasksWillBeSortedBy(string columnName, string sortDirection)
        {
            if (String.IsNullOrEmpty(columnName))    throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(sortDirection)) throw new ArgumentNullException("sortDirection");
            if (sortDirection.ToLower() != "ascending" && sortDirection.ToLower() != "descending")
            {
                throw new ArgumentException("sortDirection is not a valid direction");
            }

            ThenTheColumnHeaderIndicates(columnName, sortDirection);

            bool sortAscending = (sortDirection.ToLower() == "ascending");

            _Browser.AssertThatCodingTaskTableIsSorted(columnName, sortAscending);
        }

        [Then(@"the tasks will be filtered by")]
        public void ThenTheTasksWillBeFilteredBy(Table filters)
        {
            if (ReferenceEquals(filters, null)) throw new ArgumentNullException("filters");
            if (filters.RowCount < 1)           throw new ArgumentException("No filters specified");
            if (!filters.ContainsColumn("Column Name") || !filters.ContainsColumn("Filter Criteria"))
            {
                throw new ArgumentException("Filter columns incorrectly named");
            }

            foreach (TableRow filter in filters.Rows)
            {
                ThenOnlyTasksWithOfWillBeDisplayed(filter["Column Name"], filter["Filter Criteria"]);
            }
        }

        [Then(@"Only tasks with ""(.*)"" of ""(.*)"" will be displayed")]
        public void ThenOnlyTasksWithOfWillBeDisplayed(string columnName, string filterCriteria)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(filterCriteria)) throw new ArgumentNullException("filterCriteria");
            
            _Browser.AssertThatCodingTaskTableIsFiltered(columnName, filterCriteria, isShrinkingQueue:false);
        }

        [Then(@"Only tasks with ""(.*)"" of ""(.*)"" will be displayed and the queue will empty")]
        public void ThenOnlyTasksWithOfWillBeDisplayedAndTheQueueWillEmpty(string columnName, string filterCriteria)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(filterCriteria)) throw new ArgumentNullException("filterCriteria");

            _Browser.AssertThatCodingTaskTableIsFiltered(columnName, filterCriteria, isShrinkingQueue: true);
        }

        [Then(@"the group view of the coding task table for task ""(.*)"" differentiates the tasks with ""(.*)"" of ""(.*)""")]
        public void ThenTheGroupViewOfTheCodingTaskTableForTaskDifferentiatesTheTasksWithOf(string verbatim, string columnName, string filterCriteria)
        {
            if (String.IsNullOrEmpty(verbatim))       throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(columnName))     throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(filterCriteria)) throw new ArgumentNullException("filterCriteria");

            _Browser.AssertThatGroupViewCodingTaskTableIsFiltered(verbatim, columnName, filterCriteria);
        }


        [Then(@"the query status for task ""(.*)"" is ""(.*)""")]
        public void ThenTheTheQueryStatusForTaskIs(string verbatim, string queryStatus)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (ReferenceEquals(queryStatus, null)) throw new ArgumentNullException("queryStatus");

            _Browser.AssertThatCodingTaskQueryIsInTheCorrectStatus(verbatim, queryStatus);
        }

        [Then(@"the query for task ""(.*)"" can only be canceled")]
        public void ThenTheQueryForTaskCanOnlyBeCanceled(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            _Browser.AssertThatQueryForTaskCanOnlyBeCanceled(verbatim);
        }

        [Then(@"the query for task ""(.*)"" can only be opened")]
        public void ThenTheQueryForTaskCanOnlyBeOpened(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            _Browser.AssertThatQueryForTaskCanOnlyBeOpened(verbatim);
        }

        [Then(@"the tasks results should contain page summary ""(.*)""")]
        public void ThenTheTasksResultsShouldContainPageSummary(string expectedPageSummary)
        {
            if (String.IsNullOrWhiteSpace(expectedPageSummary)) throw new ArgumentNullException("expectedPageSummary");

            _Browser.AssertThatTasksPageSummaryEqualsExpectedValue(expectedPageSummary);
        }
    }
}
