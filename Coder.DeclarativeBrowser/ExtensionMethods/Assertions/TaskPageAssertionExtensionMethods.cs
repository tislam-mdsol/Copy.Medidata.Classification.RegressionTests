using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using NUnit.Framework;
using System.Collections;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.PageObjects;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class TaskPageAssertionExtensionMethods
    {
        private const int MaximumDisplayableTaskCount = 500;

        public static void AssertThatTheDictionaryListTermHasCodingHistoryComment(
            this CoderDeclarativeBrowser browser,
            string verbatimTerm,
            string dictionaryList,
            string status,
            string codingHistoryComment)
        {
            if (ReferenceEquals(browser, null))                  throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(verbatimTerm))         throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(dictionaryList))       throw new ArgumentNullException("dictionaryList");
            if (String.IsNullOrWhiteSpace(status))               throw new ArgumentNullException("status");
            if (String.IsNullOrWhiteSpace(codingHistoryComment)) throw new ArgumentNullException("codingHistoryComment");

            var session               = browser.Session;
            var codingTaskPage        = session.GetCodingTaskPage();

            codingTaskPage.SelectTaskGridByVerbatimNameAndAdditionalField(
                verbatim: verbatimTerm,
                field   : "Dictionary",
                value   : dictionaryList);

            var codingHistoryTab      = session.GetTaskPageCodingHistoryTab();

            var codingHistoryGridRows = codingHistoryTab.GetCodingHistoryDetailValues();

            codingHistoryGridRows.Any(
                x => x.Status.EqualsIgnoreCase(status))
                .Should()
                .BeTrue();

            codingHistoryGridRows.Any(
                x => x.Comment.EqualsIgnoreCase(codingHistoryComment))
                .Should()
                .BeTrue();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertDataMatchesCodingTaskTable(
            this CoderDeclarativeBrowser browser, 
            IList<CodingTask> codingTasks)
        {
            if (ReferenceEquals(browser, null))     throw new ArgumentNullException("browser");
            if (ReferenceEquals(codingTasks, null)) throw new ArgumentNullException("codingTasks");

            var codingTaskPage = browser.Session.GetCodingTaskPage();

            codingTaskPage.GoTo();

            browser.Session.TryUntil
                (
                () => codingTaskPage.GetFilterButton().Click(),
                () => codingTaskPage.GetCodingTaskValues().Count.Equals(codingTasks.Count),
                Config.GetDefaultCoypuOptions().RetryInterval,
                Config.GetDefaultCoypuOptions()
                );

            var htmlData = codingTaskPage.GetCodingTaskValues();

            for (var taskIndex = 0; taskIndex < codingTasks.Count; taskIndex++)
            {
                var task           = codingTasks[taskIndex];
                var taskProperties = task.GetType().GetProperties();

                foreach (var taskProperty in taskProperties)
                {
                    var taskValue  = task.GetProperty(taskProperty.Name);

                    if (String.IsNullOrEmpty(taskValue)) continue;

                    var tableValue = htmlData[taskIndex].GetProperty(taskProperty.Name);
                    StringAssert.AreEqualIgnoringCase(taskValue, tableValue);
                }
            }
        }

        public static void AssertThatTheTaskHasExpectedStatus(
            this CoderDeclarativeBrowser browser, 
            string verbatim,
            string status)
        {
            if (ReferenceEquals(browser, null))      throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 
            if (String.IsNullOrEmpty(status))        throw new ArgumentNullException("status");

            var session  = browser.Session;
            var taskPage = session.GetCodingTaskPage();

            taskPage.SelectTaskGridByVerbatimName(verbatim);

            var htmlStatus = taskPage.GetSelectedCodingTask().Status;

            status.ShouldBeEquivalentTo(htmlStatus);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatCodingTaskTableIsSorted(
            this CoderDeclarativeBrowser browser, 
            string columnName, 
            bool sortAscending)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            List<string> singleColumnOrderedTaskGridData = GetOrderedTaskGridDataForColumn(browser, columnName);

            if (ReferenceEquals(singleColumnOrderedTaskGridData, null) || singleColumnOrderedTaskGridData.Count == 0)
            {
                throw new NullReferenceException("singleColumnOrderedTaskGridData");
            }

            CollectionAssert.IsOrdered(singleColumnOrderedTaskGridData, new StringCollectionComparer(sortAscending));
        }

        public static void AssertThatCodingTaskTableIsFiltered(
            this CoderDeclarativeBrowser browser, 
            string columnName, 
            string filterCriteria, 
            bool isShrinkingQueue)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(filterCriteria)) throw new ArgumentNullException("filterCriteria");

            List<string> singleColumnOrderedTaskGridData;
            if (isShrinkingQueue)
            {
                singleColumnOrderedTaskGridData = GetOrderedTaskGridDataForColumnFromShrinkingQueue(browser, columnName); 
            }
            else
            {
                singleColumnOrderedTaskGridData = GetOrderedTaskGridDataForColumn(browser, columnName);
            }

            if (ReferenceEquals(singleColumnOrderedTaskGridData, null) || singleColumnOrderedTaskGridData.Count == 0)
            {
                throw new NullReferenceException("singleColumnOrderedTaskGridData");
            }

            foreach (string value in singleColumnOrderedTaskGridData)
            {
                Assert.AreEqual(filterCriteria, value);
            }
        }
        
        public static void AssertThatGroupViewCodingTaskTableIsFiltered(
            this CoderDeclarativeBrowser browser,
            string verbatim,
            string columnName,
            string filterCriteria)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(filterCriteria)) throw new ArgumentNullException("filterCriteria");
            
            var tasks = browser.Session.GetCodingTaskPage().GetCodingTaskValuesForGroup(verbatim);

            if (ReferenceEquals(tasks, null) || tasks.Count == 0)
            {
                throw new NullReferenceException("tasks");
            }

            foreach (var task in tasks)
            {
                if (task.GetPropertyByTaskGridColumnName(columnName).Equals(filterCriteria))
                {
                    Assert.IsEmpty(task.Group);
                }
                else
                {
                    Assert.IsNotEmpty(task.Group);
                }
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
        
        public static void AssertThatCodingTaskQueryIsInTheCorrectStatus(
            this CoderDeclarativeBrowser browser,
            string verbatimTerm,
            string queryStatus)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");
            if (ReferenceEquals(queryStatus, null)) throw new ArgumentNullException("queryStatus");

            var session = browser.Session;

            var codingTaskPage = session.GetCodingTaskPage();
            
            var codingTaskValues = codingTaskPage.GetTaskGridVerbatimElementValuesByVerbatimTerm(verbatimTerm);

            codingTaskValues.VerbatimTerm.Should().BeEquivalentTo(verbatimTerm);
            codingTaskValues.Queries.Should().BeEquivalentTo(queryStatus);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatQueryForTaskCanOnlyBeCanceled(this CoderDeclarativeBrowser browser, string verbatimTerm)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            browser.SelectTaskGridByVerbatimName(verbatimTerm);

            browser.Session.GetCodingTaskPage().IsCancelQueryButtonEnabled().Should().BeTrue();
            browser.Session.GetCodingTaskPage().IsOpenQueryButtonEnabled().Should().BeFalse();
            
            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatQueryForTaskCanOnlyBeOpened(this CoderDeclarativeBrowser browser, string verbatimTerm)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            browser.SelectTaskGridByVerbatimName(verbatimTerm);

            browser.Session.GetCodingTaskPage().IsCancelQueryButtonEnabled().Should().BeFalse();
            browser.Session.GetCodingTaskPage().IsOpenQueryButtonEnabled().Should().BeTrue();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertQueryHistoryHasTheInformationForTask(this CoderDeclarativeBrowser browser, IList<QueryHistoryDetail> featureData, int hoursDiff)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            if (featureData.Count > 0)
            {
                string displayedVerbatim = featureData[0].VerbatimTerm.RemoveAdditionalInformationFromGridDataVerbatim();

                browser.SelectTaskGridByVerbatimName(displayedVerbatim);
            }

            var htmlData = browser.GetQueryHistoryTableValues();
            var additionalInformationValues = browser.GetQueryHistoryTableAdditionalInformationValues();

            for (var i = 0; i < featureData.Count; i++)
            {
                var actualResult   = htmlData[i];
                var expectedResult = featureData[i];
                var result         = actualResult.Equals(expectedResult);

                result.Should().BeTrue(String.Format("QueryHistoryDetail for row {0} should be {1} but was {2}", i, expectedResult.ToString(), actualResult.ToString()));

                if (!String.IsNullOrWhiteSpace(expectedResult.VerbatimTerm))
                { 
                    string displayedVerbatim = expectedResult.VerbatimTerm.RemoveAdditionalInformationFromGridDataVerbatim();

                    displayedVerbatim                 .Should().BeEquivalentTo(actualResult.VerbatimTerm,
                        String.Format("'VerbatimTerm' does not match in row {0}", i));
                    expectedResult.VerbatimTerm.Trim().Should().BeEquivalentTo(actualResult.VerbatimTerm + additionalInformationValues[i].Trim(),
                        String.Format("'Expanded VerbatimTerm' does not match in row {0}", i));
                }

                if (!String.IsNullOrWhiteSpace(expectedResult.TimeStamp))
                {
                    var expectedDateTime   = DateTime.Parse(expectedResult.TimeStamp);
                    var displayedTimeStamp = DateTime.Parse(actualResult.TimeStamp);
                    var timeStampDiff      = expectedDateTime.Subtract(displayedTimeStamp);

                    Math.Abs(timeStampDiff.Hours).Should().BeLessThan(hoursDiff);
                }
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTasksPageSummaryEqualsExpectedValue(
            this CoderDeclarativeBrowser browser,
            string expectedPageSummary)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(expectedPageSummary)) throw new ArgumentNullException("expectedPageSummary");

            var session        = browser.Session;
            var codingTaskPage = browser.Session.GetCodingTaskPage();

            var pageSummary = codingTaskPage.GetPageSummary();

            pageSummary.ShouldBeEquivalentTo(expectedPageSummary);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheTaskCountEqualsExpectedValue(
            this CoderDeclarativeBrowser browser,
            int expectedTaskCount)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (expectedTaskCount < 0)          throw new ArgumentOutOfRangeException("expectedTaskCount");

            var session        = browser.Session;
            var codingTaskPage = session.GetCodingTaskPage();

            codingTaskPage.AssertThatAllTasksAreFinishedProcessing(expectedTaskCount);

            var taskCount = browser.GetHeaderTaskCount();

            taskCount.ShouldBeEquivalentTo(expectedTaskCount);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTaskLoaded(this CoderDeclarativeBrowser browser, string verbatim)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            browser.Session.GetCodingTaskPage().AssertTaskLoaded(verbatim);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

    private static List<string> GetOrderedTaskGridDataForColumn(CoderDeclarativeBrowser browser, string columnName)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            List<string> singleColumnOrderedTaskGridData = new List<string>();
            
            int numberOfTaskPages = browser.GetNumberOfTaskPages();
           
            browser.GoToSpecificTaskPage("FIRST");

            for (int currentPage = 1; currentPage <= numberOfTaskPages; currentPage++)
            {
                browser.AssertExpectedTaskPageIsCurrent(currentPage);

                var tasks = browser.Session.GetCodingTaskPage().GetCodingTaskValues();
                if (ReferenceEquals(tasks, null) || tasks.Count == 0)
                {
                    throw new NullReferenceException("tasks");
                }

                foreach (var task in tasks)
                {
                    singleColumnOrderedTaskGridData.Add(task.GetPropertyByTaskGridColumnName(columnName));
                }

                browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

                browser.GoToSpecificTaskPage("NEXT");
            }

            // Verify that all displayable tasks were added to the collection
            int headerTaskCount = browser.GetHeaderTaskCount();

            Assert.AreEqual(Math.Min(MaximumDisplayableTaskCount, headerTaskCount), singleColumnOrderedTaskGridData.Count);

            return singleColumnOrderedTaskGridData;
        }

        /// <summary>
        /// Gets the data from the task page grid for a specific column while items are being removed from the queue/grid.
        /// This method does not guarantee to return all values, only those that would be visible to a user as they transverse the pages.
        /// Processing will stop once the queue/grid is empty or the final page is reached.
        /// </summary>
        private static List<string> GetOrderedTaskGridDataForColumnFromShrinkingQueue(CoderDeclarativeBrowser browser, string columnName)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            List<string> singleColumnOrderedTaskGridData = new List<string>();

            int pagesProcessed = 0;

            browser.GoToSpecificTaskPage("FIRST");

            do
            {
                var tasks = browser.Session.GetCodingTaskPage().GetCodingTaskValues();
                if (ReferenceEquals(tasks, null) || tasks.Count == 0)
                {
                    throw new NullReferenceException("tasks");
                }

                foreach (var task in tasks)
                {
                    singleColumnOrderedTaskGridData.Add(task.GetPropertyByTaskGridColumnName(columnName));
                }

                browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

                browser.GoToSpecificTaskPage("NEXT");
                pagesProcessed++;

            } while (browser.GetHeaderTaskCount() > 0 &&
                    pagesProcessed < browser.GetNumberOfTaskPages());

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            return singleColumnOrderedTaskGridData;
        }

        internal static void AssertTaskCountForWorkflowState(this CoderDeclarativeBrowser browser, string filter, int expectedTaskCount)
        {
            if (ReferenceEquals(browser,null))     throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(filter)) throw new ArgumentNullException("filter");
            if (expectedTaskCount < 0)             throw new ArgumentOutOfRangeException("expectedTaskCount should be >= 0");

            browser.FilterDisplayedTasks(String.Empty, String.Empty, filter);

            var actualTaskCount = browser.GetHeaderTaskCount();

            actualTaskCount.ShouldBeEquivalentTo(expectedTaskCount,
                String.Format("Autocoding not completed. {0} Tasks still {1}", actualTaskCount, filter));
        }
    }

    public class StringCollectionComparer : IComparer
    {
        private bool m_IsAscending;

        public StringCollectionComparer(bool isAscending)
        {
            m_IsAscending = isAscending;
        }

        public int Compare(object a, object b)
        {
            if (m_IsAscending)
            {
                return (a.ToString()).CompareTo(b.ToString());
            }
            else
            {
                return (b.ToString()).CompareTo(a.ToString());
            }

        }
    }
}
